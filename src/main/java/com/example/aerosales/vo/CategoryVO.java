package com.example.aerosales.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "产品分类返回对象")
public class CategoryVO {

    @Schema(description = "分类ID", example = "1")
    private Long id;

    @Schema(description = "分类名称", example = "家居清洁气雾剂")
    private String name;

    @Schema(description = "排序值", example = "10")
    private Integer sortOrder;
}
