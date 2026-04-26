package com.example.aerosales.controller;

import com.example.aerosales.common.ApiResponse;
import com.example.aerosales.service.ProductCategoryService;
import com.example.aerosales.service.ProductService;
import com.example.aerosales.vo.CategoryVO;
import com.example.aerosales.vo.ProductDetailVO;
import com.example.aerosales.vo.ProductListVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "用户端产品接口", description = "产品分类、产品列表和产品详情查询")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class ProductController {

    private final ProductCategoryService productCategoryService;

    private final ProductService productService;

    @Operation(summary = "查询产品分类", description = "查询所有启用状态的产品分类，按排序值升序排列")
    @GetMapping("/categories")
    public ApiResponse<List<CategoryVO>> listCategories() {
        return ApiResponse.success(productCategoryService.listEnabledCategories());
    }

    @Operation(summary = "查询产品列表", description = "查询上架产品列表，支持按分类ID筛选")
    @GetMapping("/products")
    public ApiResponse<List<ProductListVO>> listProducts(
            @Parameter(description = "分类ID，可选", example = "1")
            @RequestParam(required = false) Long categoryId
    ) {
        return ApiResponse.success(productService.listProducts(categoryId));
    }

    @Operation(summary = "查询产品详情", description = "查询上架产品详情，并返回该产品下上架状态的SKU列表")
    @GetMapping("/products/{id}")
    public ApiResponse<ProductDetailVO> getProductDetail(
            @Parameter(description = "产品ID", example = "1")
            @PathVariable Long id
    ) {
        return ApiResponse.success(productService.getProductDetail(id));
    }
}
