

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;

/**
 * @author
 * DataSourceAspect
 */
@Aspect
@EnableAspectJAutoProxy(exposeProxy = true)
@Component
public class DataSourceAspect {

    /**
     * 使用空方法定义切点表达式
     */
    @Pointcut("execution(* com.mybatis.*.mapper.*.*(..))")
    public void declareJointPointExpression() {
    }

    /**
     * 根据包名及方法名来判断读还是写数据源
     * @param point
     */
    @Before("declareJointPointExpression()")
    public void setDataSourceKey(JoinPoint point){
        MethodSignature methodSignature = (MethodSignature) point.getSignature();
        Method method = methodSignature.getMethod();
        String className = method.getDeclaringClass().getName();
        String dataSourceName = className.substring(className.indexOf("mybatis.") + 8, className.indexOf(".mapper"));
        String methodName = point.getSignature().getName();
        if (methodName.startsWith("get") || methodName.startsWith("select") || methodName.startsWith("find") || methodName.startsWith("count")){
            DynamicDataSource.setDatabaseType(dataSourceName + MybatisConfig.SLAVE_SUFFIX);
        }else {
            DynamicDataSource.setDatabaseType(dataSourceName + MybatisConfig.MASTER_SUFFIX);
        }
    }
}