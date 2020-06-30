
mybatis generatorConfig.xml配置：
<properties  url="file:////E:\\lms-tes\\lms-platform\\mybatis-module\\src\\main\\resources\\db.properties"/>
jdbc.path=//e://mysql-connector-java-3.1.14-bin.jar


CURRENT_TIMESTAMP		  //数据库表默认当前时间
allowMultiQueries=true    //mysql访问参数，支持批量语句执行



<insert id="insertAndGetId" useGeneratedKeys="true" keyProperty="userId" parameterType="com.chenzhou.mybatis.User">
    insert into user(userName,password,comment)
    values(#{userName},#{password},#{comment})
</insert>



<insert id="insertByList">
	INSERT INTO tr_lms_course_openinfo ( objid, course_id, NAME,   TYPE, email, phone )
	VALUES
	<foreach collection="list" item="item" separator=",">
		(#{item.objid},#{item.courseId},#{item.name},#{item.type},#{item.email},#{item.phone})
	</foreach>
</insert>

int insertByList(@Param("list")List<TLmsBookshelf> list);

<insert id="insertByList">
	INSERT INTO t_lms_bookshelf ( id, parent, lable, type, level, status, create_by,create_date,update_by,update_date )
	VALUES
	<foreach collection="list" item="item" separator=",">
	  (#{item.id},#{item.parent},#{item.lable},#{item.type},#{item.level},#{item.status},
	   #{item.createBy},#{item.createDate},#{item.updateBy},#{item.updateDate})
	</foreach>
</insert>
  
  
<resultMap id="OrderDetailResultMap" type="com.sf.shiva.oms.query.dto.OrderDetail">
	<result property="totalGoodsCount" column="totalGoodsCount" jdbcType="INTEGER" />
	<association property="order" javaType="com.sf.shiva.oms.query.model.Order" column="order_no" select="selectOrder">
		<id property="orderNo" column="order_no" jdbcType="INTEGER"/>
		<result property="customerNo" column="customer_no" jdbcType="INTEGER"/>
		<result property="amount" column="amount" jdbcType="DOUBLE"/>
	</association>
	<collection property="goodsList" ofType="com.sf.shiva.oms.query.model.Goods"
	select="selectGoods" column="order_no">
	</collection>
</resultMap>

--时间格式化
SELECT DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s');

//字符连接
SELECT GROUP_CONCAT(id) AS NAME FROM t_lms_bookshelf
SELECT course_id,GROUP_CONCAT(DISTINCT link SEPARATOR '') FROM course_link_temp GROUP BY course_id ORDER BY id

//截取第二个 '.' 之前的所有字符。  
select substring_index('www.sqlstudy.com.cn', '.', 2);  


---------------------------------------------------------------------------------------------------------------------
UPDATE t_lms_course c SET 
fmlink=(

SELECT GROUP_CONCAT(DISTINCT t1.link SEPARATOR '') links FROM course_link_temp t1 WHERE t1.course_id=c.id ORDER BY t1.id 
)
WHERE c.id=50001077;
------------
UPDATE t_lms_course c SET 
fmlink=(
SELECT SUBSTRING_INDEX(fmlink,'http://',2) 

)
WHERE c.id=50001077;

SELECT LENGTH(fmlink) FROM  t_lms_course WHERE id=50001077
-----------------------------------------------------------------------------------------------------------------------


//索引
CREATE INDEX index_name ON t_orgs(objid)
SHOW INDEX FROM t_orgs
DROP INDEX index_name ON t_orgs



-- 修改group_concat最大长度 -----------------------------------------------------------------------
SET SESSION group_concat_max_len=102400;
-- 计算字符串被f_delimiter分割的数量-----------------------------------------------------------------------
DELIMITER $$  
DROP FUNCTION IF EXISTS `get_split_string_total`$$  
CREATE FUNCTION `get_split_string_total`(  
f_string LONGTEXT,f_delimiter VARCHAR(5) 
) RETURNS INT(11)  
BEGIN  
DECLARE returnInt INT(11);  
IF LENGTH(f_delimiter)=2  THEN  
 RETURN 1+(LENGTH(f_string) - LENGTH(REPLACE(f_string,f_delimiter,'')))/2;  
ELSE      
 RETURN 1+(LENGTH(f_string) - LENGTH(REPLACE(f_string,f_delimiter,'')));  
END IF;  
END$$  
DELIMITER;  


-- 获取用户对应菜单的权限，判断org_id_input 是否在用户组织权限内:true返回1 flase返回0 -------------------
DELIMITER $$   
DROP FUNCTION IF EXISTS `get_user_org_permission` $$   
CREATE FUNCTION `get_user_org_permission`
-- org_id_input 组织ID, user_id_input 用户ID, menu_name_input 菜单名称
(org_id_input VARCHAR(20) ,user_id_input VARCHAR(20), menu_name_input VARCHAR(255))
RETURNS INT
BEGIN

DECLARE org_super_str VARCHAR(255) DEFAULT ''; 
DECLARE counts INT DEFAULT 0;   
DECLARE i INT DEFAULT 0;
DECLARE org_id VARCHAR(20) DEFAULT ''; 
DECLARE result INT DEFAULT 0;
-- 获取用户的组织权ID字符串
SET org_super_str =  (SELECT GROUP_CONCAT(DISTINCT sr.orgprivilegs) FROM tr_staffs_roles sr 
						LEFT JOIN tr_roles_menus rm ON rm.roleid=sr.roleid 
						LEFT JOIN t_lms_menu m ON rm.menuid=m.id  
						WHERE m.menu_name = menu_name_input AND sr.pernr= user_id_input);
-- 获取org_id总数量			
SET counts = get_split_string_total(org_super_str,','); 
outer_label: BEGIN
WHILE i < counts   
DO   
SET i = i + 1;
	-- 遍历截取 org_id
	SET org_id = REVERSE(SUBSTRING_INDEX(REVERSE(SUBSTRING_INDEX(org_super_str,',',i)),',',1));  
	-- 判断org_id_input是否在用户组织权限内
	SET result = result + (SELECT COUNT(1) FROM t_orgs_normal t WHERE t.objid = org_id_input AND FIND_IN_SET(org_id,t.fullobjid));
	IF result > 0 THEN LEAVE outer_label; END IF;
END WHILE;
END outer_label;
RETURN result;
END$$
-------------------------------------------------------------------------------

-- 查看用户菜单的组织权限 ------------------------------------------
SELECT sr.orgprivilegs,sr.roleid,role.role_name,m.id,m.menu_name,m.parent_id FROM tr_staffs_roles sr 
			LEFT JOIN tr_roles_menus rm ON rm.roleid=sr.roleid 
			LEFT JOIN t_lms_menu m ON rm.menuid=m.id 
			LEFT JOIN t_lms_role role ON sr.roleid=role.id
			WHERE m.menu_name = '书架管理' AND sr.pernr= 00260961

-- 查询用户权限下的书架列表------------------------------------------------------------------
SELECT * FROM t_lms_bookshelf t WHERE STATUS = "Y" AND  t.id IN(

SELECT bo.bookshelf_id FROM  t_lms_bookshelf_org bo WHERE bo.flag ='2'AND get_user_org_permission(bo.org_id,'00226591','书架管理')
	
) ORDER BY t.id

--sqlservice 分页-----------------------------------------------------------------
SELECT t.n,
  tt.id,
  tt.Name,
  tt.ADAccountName,
  tt.Email,
  tt.Mobile FROM UA_EmployeeAccount tt,(
  SELECT TOP (1*30) row_number() OVER (ORDER BY ID) n, ID FROM UA_EmployeeAccount
) t
WHERE tt.ID = t.ID AND t.n > (1-1)*30  ORDER BY t.n
--------------------------
查看MYSQL所有的连接
show full processlist
SELECT CONCAT('KILL ',id,';')  AS command  FROM information_schema.processlist  WHERE  `user`='vkapp'  
kill <id>
--

--------+
DELIMITER //
CREATE FUNCTION lecturer_num() RETURNS varchar(10)
BEGIN  
DECLARE i INT DEFAULT 0;
set i = (select max(num) from t_lecturer_num) + 1;
if i > 9999 then
set i = 1;
end if;
update t_lecturer_num set num = i;
return (select LPAD(i, 4, 0) from dual);
END//
-----------+

====================
DELIMITER //
CREATE PROCEDURE `lecturer_num`()
	BEGIN  
	DECLARE codenum INTEGER DEFAULT 0; 
	start transaction;
	set codenum = (select max(num) from t_lecturer_num) + 1;
	if codenum IS NULL then
	set codenum = 1;
	insert into t_lecturer_num(num) values (codenum);
	end if;
	if codenum > 9999 then
	set codenum = 1;
	end if;
	update t_lecturer_num set num = codenum;
	commit;
	select LPAD(codenum, 4, 0);
END//
=========================


查看所有的连接
show full processlist
kill ID  断开连接
====================
CURRENT_TIMESTAMP


=================================================
DELIMITER //
CREATE PROCEDURE `exam_sql`() 
BEGIN
DECLARE userId VARCHAR(10);
DECLARE examId VARCHAR(50);
DECLARE commitId VARCHAR(50);
DECLARE done INT DEFAULT FALSE;
DECLARE rep CURSOR FOR select user_id from t_exam_user_result GROUP BY user_id;
DECLARE rep2 CURSOR FOR select exam_config_id from t_exam_user_result GROUP BY exam_config_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
OPEN rep;
	loop_1:LOOP
		FETCH rep INTO userId;
			IF done THEN
				LEAVE loop_1;
			END IF;
			OPEN rep2;
				loop_2:LOOP
					FETCH rep2 INTO examId;
						IF done THEN
							LEAVE loop_2;
						END IF;
						set commitId =  (select user_commit_id from t_exam_user_answer where user_id = userId and paper_config_id = examId ORDER BY create_time desc limit 1);
						update t_exam_user_answer set 
						user_commit_id = (select id from t_exam_user_result where user_id = userId and exam_config_id = examId order by create_time desc limit 1)
						where user_commit_id = commitId;
						COMMIT;
				END LOOP;
		  CLOSE rep2;
			SET done=FALSE;
		END LOOP;
CLOSE rep;
END
//
DELIMITER ;
======================================================

SHOW VARIABLES LIKE "group_concat_max_len";  
SET GLOBAL group_concat_max_len=1024000;
SET @@GROUP_CONCAT_MAX_LEN = 1024000;

======================================================
ALTER TABLE  mytable MODIFY COLUMN `content` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci


======================
-- mysql查询树
drop FUNCTION if EXISTS queryTree;
CREATE FUNCTION queryTree(rootId int)
RETURNS VARCHAR(4000)
BEGIN
    DECLARE temp VARCHAR(200);
    DECLARE children VARCHAR(4000);
    SET temp = CAST(rootId as CHAR);
    WHILE temp is not null  DO
        set children = concat_ws(',',children,temp); -- 连接children、temp值，返回新的 children
        select GROUP_CONCAT(id) into temp FROM resource WHERE FIND_IN_SET(parent_id,temp) > 0;  -- 查询所有temp的parent_id ，并重新赋值给temp
END WHILE;
return children;  -- 返回值 1,2,3,4...
END
======================
-- mysql查询树
DELIMITER //
drop FUNCTION if EXISTS query_course_tree;
CREATE FUNCTION query_course_tree(rootId varchar(10))
RETURNS VARCHAR(8000)
BEGIN
DECLARE children varchar(8000);
DECLARE temp varchar(8000);
SET temp=rootId;
WHILE temp is not null  DO
        set children = concat_ws(',',children,temp);
        select GROUP_CONCAT(objid) into temp FROM t_sap_bookshelf WHERE FIND_IN_SET(sobjid,temp) > 0;
END WHILE;
return children;
END//

==================================
-- 查询表字段及注释
select column_name,column_comment,data_type 
from information_schema.columns 
where table_name='查询表名称' and table_schema='数据库名称'
=================






