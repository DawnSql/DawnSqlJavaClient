package com.dawnsql.client.web;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

/**
 * <p>Project: DawnSqlWeb</p>
 * <p>File: org.dawnsql.client.controller.WebMvcConfig</p>
 * <p>Description: </p>
 *
 * @author Cong
 * @date 2022/11/28
 */
@Configuration
public class WebMvcConfig {
    @Bean
    public WebMvcConfigurerAdapter forwardToIndex() {
        return new WebMvcConfigurerAdapter() {
            @Override
            public void addViewControllers(ViewControllerRegistry registry) {
                registry.addViewController("/").setViewName("forward:/index");
            }
        };
    }
}
