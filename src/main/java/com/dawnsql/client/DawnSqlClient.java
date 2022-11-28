package com.dawnsql.client;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DawnSqlClient implements CommandLineRunner {

    public static void main( String[] args )
    {
        SpringApplication.run(DawnSqlClient.class, args);
    }

    @Override
    public void run(String... strings) throws Exception {

    }
}
