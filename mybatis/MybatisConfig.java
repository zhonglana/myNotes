


import com.alibaba.druid.pool.DruidDataSourceFactory;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.context.properties.bind.BindResult;
import org.springframework.boot.context.properties.bind.Bindable;
import org.springframework.boot.context.properties.bind.Binder;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.env.Environment;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;


/**
 * @author
 * MybatisConfig
 */
@Configuration
@MapperScan("com.mybatis.*.mapper")
public class MybatisConfig implements EnvironmentAware {

    private static final String ENTITY_PACKAGE = "com.mybatis.*.entity";
    private static final String MAPPER_LOCALTION_PATTERN = "classpath*:com/mybatis/*/mapper/xml/*.xml";

    private static final String DATASOURCE_PROPS_KEY = "custom.datasource";
    public static final String MASTER_SUFFIX = "_master";
    public static final String SLAVE_SUFFIX = "_slave";

    private Environment env;

    @Override
    public void setEnvironment(final Environment environment) {
        this.env = environment;
    }

    /**
     * @Primary 该注解标识在同一个接口有多个实现类可以注入的时候，默认选择哪一个，而不是让@Autowire注解报错
     * @Qualifier 根据名称进行注入，通常是在具有相同多个类型的实例的一个注入
     *
     * @return
     */
    @Bean
    @Primary
    public DynamicDataSource dataSource() throws Exception {
        Map<Object,Object> targetDataSources = new HashMap<>();
        DataSource defaultDataSource = null;
        BindResult<DBClustersProps> bindResult = Binder.get(env).bind(DATASOURCE_PROPS_KEY, Bindable.of(DBClustersProps.class));
        if(bindResult.isBound()){
            DBClustersProps dbClustersProps = bindResult.get();
            for(ClusterProps clusterProps : dbClustersProps.getClusters()){
                targetDataSources.put(clusterProps.getName() + MASTER_SUFFIX,
                        this.getDataSource(clusterProps.getDriverClassName(), clusterProps.getUrl(), clusterProps.getUsername(), clusterProps.getPassword()));
                if(defaultDataSource == null){
                    defaultDataSource = (DataSource) targetDataSources.get(clusterProps.getName() + MASTER_SUFFIX);
                }

                targetDataSources.put(clusterProps.getName() + SLAVE_SUFFIX,
                        this.getDataSource(clusterProps.getDriverClassName(), clusterProps.getUrl(), clusterProps.getUsername(), clusterProps.getPassword()));
            }
        }
        DynamicDataSource dataSource = new DynamicDataSource();
        dataSource.setTargetDataSources(targetDataSources);
        dataSource.setDefaultTargetDataSource(defaultDataSource);
        return dataSource;
    }

    /**
     * 组装数据源
     * @param driverClassName
     * @param url
     * @param userName
     * @param password
     * @return
     * @throws Exception
     */
    private DataSource getDataSource(String driverClassName, String url, String userName, String password) throws Exception {
        Properties props = new Properties();
        props.put("driverClassName", driverClassName);
        props.put("url", url);
        props.put("username", userName);
        props.put("password", password);
        return DruidDataSourceFactory.createDataSource(props);
    }

    /**
     * sqlSessionFactory
     * @return
     * @throws Exception
     */
    @Bean
    public SqlSessionFactory sqlSessionFactory(DynamicDataSource dynamicDataSource) throws Exception {
        SqlSessionFactoryBean ssfb = new SqlSessionFactoryBean();
        org.apache.ibatis.session.Configuration configuration = new org.apache.ibatis.session.Configuration();
        configuration.setCallSettersOnNulls(true);
        ssfb.setConfiguration(configuration);
        ssfb.setDataSource(dynamicDataSource);
        ssfb.setTypeAliasesPackage(ENTITY_PACKAGE);
        ssfb.setMapperLocations(new PathMatchingResourcePatternResolver().getResources(MAPPER_LOCALTION_PATTERN));
        return ssfb.getObject();
    }

    /**
     * 配置事务管理器
     * @param dataSource
     * @return
     */
    @Primary
    @Bean
    public DataSourceTransactionManager transactionManager (DynamicDataSource dataSource){
        return new DataSourceTransactionManager(dataSource);
    }

}
