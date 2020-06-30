

import java.util.List;


class DBClustersProps {

    private List<ClusterProps> clusters;

    public List<ClusterProps> getClusters() {
        return clusters;
    }

    public void setClusters(List<ClusterProps> clusters) {
        this.clusters = clusters;
    }


}

class ClusterProps {
    private String name;
    String driverClassName;
    private String url;
    private String username;
    private String password;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDriverClassName() {
        return driverClassName;
    }

    public void setDriverClassName(String driverClassName) {
        this.driverClassName = driverClassName;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}



