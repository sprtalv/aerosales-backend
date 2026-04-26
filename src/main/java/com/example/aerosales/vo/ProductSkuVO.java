package com.example.aerosales.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Schema(description = "产品SKU返回对象")
public class ProductSkuVO {

    @Schema(description = "SKU ID", example = "1")
    private Long id;

    @Schema(description = "SKU名称", example = "厨房强力除油 300ml 单瓶装")
    private String skuName;

    @Schema(description = "容量规格", example = "300ml")
    private String volume;

    @Schema(description = "包装规格", example = "1瓶/盒")
    private String packageSpec;

    @Schema(description = "销售价格", example = "29.90")
    private BigDecimal price;

    @Schema(description = "库存数量", example = "120")
    private Integer stock;

    @Schema(description = "库存预警值", example = "20")
    private Integer warningStock;

    @Schema(description = "存储条件", example = "阴凉干燥处保存，远离火源。")
    private String storageCondition;

    @Schema(description = "运输说明", example = "按普通日化品运输，避免高温暴晒。")
    private String transportNote;

    @Schema(description = "SKU状态", example = "ON_SALE")
    private String status;
}
