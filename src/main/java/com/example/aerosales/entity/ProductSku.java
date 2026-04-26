package com.example.aerosales.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("product_sku")
public class ProductSku {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long productId;

    private String skuName;

    private String volume;

    private String packageSpec;

    private BigDecimal price;

    private Integer stock;

    private Integer warningStock;

    private String storageCondition;

    private String transportNote;

    private String status;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
