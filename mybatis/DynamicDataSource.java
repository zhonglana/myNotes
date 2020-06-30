


import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

/**
 * @author
 * 动态数据源（需要继承AbstractRoutingDataSource）
 */
public class DynamicDataSource extends AbstractRoutingDataSource {

    /**
     * 动态数据源
     * @return
     */
    @Override
    protected Object determineCurrentLookupKey(){
        return contextHolder.get();
    }


    /**
     * 作用:保存一个线程安全的DatabaseType容器
     */
    private static final ThreadLocal<Object> contextHolder = new ThreadLocal<>();

    /**
     * getDatabaseType
     * @return
     */
    public static Object getDatabaseType(){
        return contextHolder.get();
    }

    /**
     * setDatabaseType
     * @param type
     */
    public static void setDatabaseType(Object type){
        contextHolder.set(type);
    }

}
