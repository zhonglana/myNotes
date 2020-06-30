package com.vanke.emp.platform.esbservice.base.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.context.config.ConfigFileApplicationListener;
import org.springframework.boot.context.properties.bind.BindResult;
import org.springframework.boot.context.properties.bind.Bindable;
import org.springframework.boot.context.properties.bind.Binder;
import org.springframework.boot.env.EnvironmentPostProcessor;
import org.springframework.boot.env.PropertiesPropertySourceLoader;
import org.springframework.boot.env.YamlPropertySourceLoader;
import org.springframework.core.Ordered;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.FileUrlResource;
import org.springframework.core.io.Resource;
import org.springframework.util.ObjectUtils;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author
 * 配置文件加载类
   custom.config.location[0]=profile/${spring.profiles.active}/application.properties
 */
public class CustomEnvironmentPostProcessor implements EnvironmentPostProcessor, Ordered {
    private static Logger logger = LoggerFactory.getLogger(CustomEnvironmentPostProcessor.class);


    /**
     * 加载自定义配置文件
     *
     * @param environment
     * @param application
     */
    @Override
    public void postProcessEnvironment(ConfigurableEnvironment environment, SpringApplication application) {

        List<Resource> resources = getCustomConfigLocations(environment);
        if (ObjectUtils.isEmpty(resources)) {
            return;
        }
        YamlPropertySourceLoader yamlPropertySourceLoader = new YamlPropertySourceLoader();
        PropertiesPropertySourceLoader propertiesPropertySourceLoader = new PropertiesPropertySourceLoader();
        try {
            for (Resource resource : resources) {
                if (resource.getFilename().trim().endsWith(".yml")) {
                    environment.getPropertySources().addLast(yamlPropertySourceLoader.load(resource.getDescription(), resource).get(0));
                } else if (resource.getFilename().trim().endsWith(".properties")) {
                    environment.getPropertySources().addLast(propertiesPropertySourceLoader.load(resource.getDescription(), resource).get(0));
                }
            }
        } catch (IOException e) {
            logger.error(e.getMessage(), e);
            logger.error(e.getMessage(), e);
        }
    }

    /**
     * 转换配置文件为资源
     *
     * @param environment
     * @return
     */
    private List<Resource> getCustomConfigLocations(ConfigurableEnvironment environment) {
        BindResult<List<String>> bindResult = Binder.get(environment).bind("custom.config.location", Bindable.listOf(String.class));
        if (bindResult.isBound()) {
            List<Resource> resources = new ArrayList<Resource>();
            for (String config : bindResult.get()) {
                try {
                    Resource resource = new ClassPathResource(config);
                    if (resource.exists()) {
                        resources.add(resource);
                        continue;
                    }
                    resource = new FileSystemResource(config);
                    if (resource.exists()) {
                        resources.add(resource);
                        continue;
                    }
                    resource = new FileUrlResource(config);
                    if (resource.exists()) {
                        resources.add(resource);
                        continue;
                    }
                } catch (MalformedURLException e) {
                    logger.error(e.getMessage(), e);
                }
            }
            return resources;
        }
        return null;
    }

    /**
     * 解析类优先级
     *
     * @return
     */
    @Override
    public int getOrder() {
        return ConfigFileApplicationListener.DEFAULT_ORDER + 1000;
    }
}
