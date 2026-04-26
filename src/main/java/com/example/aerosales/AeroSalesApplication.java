package com.example.aerosales;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@MapperScan("com.example.aerosales.mapper")
@SpringBootApplication
public class AeroSalesApplication {

    public static void main(String[] args) {
        SpringApplication.run(AeroSalesApplication.class, args);
    }
}
