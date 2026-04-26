package com.example.aerosales.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "产品列表返回对象")
public class ProductListVO {

    @Schema(description = "产品ID", example = "1")
    private Long id;

    @Schema(description = "分类ID", example = "1")
    private Long categoryId;

    @Schema(description = "产品名称", example = "厨房强力除油气雾剂")
    private String name;

    @Schema(description = "品牌", example = "AeroClean")
    private String brand;

    @Schema(description = "产品描述", example = "适用于厨房灶台、油烟机和瓷砖表面的油污清洁。")
    private String description;

    @Schema(description = "产品状态", example = "ON_SALE")
    private String status;
}
