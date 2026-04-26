package com.example.aerosales.service;

import com.example.aerosales.vo.ProductDetailVO;
import com.example.aerosales.vo.ProductListVO;

import java.util.List;

public interface ProductService {

    List<ProductListVO> listProducts(Long categoryId);

    ProductDetailVO getProductDetail(Long id);
}
