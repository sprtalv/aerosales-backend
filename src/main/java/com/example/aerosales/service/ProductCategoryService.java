package com.example.aerosales.service;

import com.example.aerosales.vo.CategoryVO;

import java.util.List;

public interface ProductCategoryService {

    List<CategoryVO> listEnabledCategories();
}
