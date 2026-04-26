package com.example.aerosales.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.aerosales.entity.ProductCategory;
import com.example.aerosales.mapper.ProductCategoryMapper;
import com.example.aerosales.service.ProductCategoryService;
import com.example.aerosales.vo.CategoryVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductCategoryServiceImpl implements ProductCategoryService {

    private static final String STATUS_ON_SALE = "ON_SALE";

    private final ProductCategoryMapper productCategoryMapper;

    @Override
    public List<CategoryVO> listEnabledCategories() {
        List<ProductCategory> categories = productCategoryMapper.selectList(
                new LambdaQueryWrapper<ProductCategory>()
                        .eq(ProductCategory::getStatus, STATUS_ON_SALE)
                        .orderByAsc(ProductCategory::getSortOrder)
        );

        return categories.stream()
                .map(this::toCategoryVO)
                .toList();
    }

    private CategoryVO toCategoryVO(ProductCategory category) {
        CategoryVO vo = new CategoryVO();
        vo.setId(category.getId());
        vo.setName(category.getName());
        vo.setSortOrder(category.getSortOrder());
        return vo;
    }
}
