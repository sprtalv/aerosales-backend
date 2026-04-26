package com.example.aerosales.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.aerosales.common.BusinessException;
import com.example.aerosales.entity.Product;
import com.example.aerosales.entity.ProductSku;
import com.example.aerosales.mapper.ProductMapper;
import com.example.aerosales.mapper.ProductSkuMapper;
import com.example.aerosales.service.ProductService;
import com.example.aerosales.vo.ProductDetailVO;
import com.example.aerosales.vo.ProductListVO;
import com.example.aerosales.vo.ProductSkuVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private static final String STATUS_ON_SALE = "ON_SALE";

    private final ProductMapper productMapper;

    private final ProductSkuMapper productSkuMapper;

    @Override
    public List<ProductListVO> listProducts(Long categoryId) {
        LambdaQueryWrapper<Product> queryWrapper = new LambdaQueryWrapper<Product>()
                .eq(Product::getStatus, STATUS_ON_SALE)
                .orderByDesc(Product::getCreatedAt);

        if (categoryId != null) {
            queryWrapper.eq(Product::getCategoryId, categoryId);
        }

        return productMapper.selectList(queryWrapper)
                .stream()
                .map(this::toProductListVO)
                .toList();
    }

    @Override
    public ProductDetailVO getProductDetail(Long id) {
        Product product = productMapper.selectOne(
                new LambdaQueryWrapper<Product>()
                        .eq(Product::getId, id)
                        .eq(Product::getStatus, STATUS_ON_SALE)
        );
        if (product == null) {
            throw new BusinessException("产品不存在");
        }

        List<ProductSkuVO> skus = productSkuMapper.selectList(
                        new LambdaQueryWrapper<ProductSku>()
                                .eq(ProductSku::getProductId, id)
                                .eq(ProductSku::getStatus, STATUS_ON_SALE)
                                .orderByAsc(ProductSku::getId)
                )
                .stream()
                .map(this::toProductSkuVO)
                .toList();

        ProductDetailVO detailVO = new ProductDetailVO();
        detailVO.setId(product.getId());
        detailVO.setCategoryId(product.getCategoryId());
        detailVO.setName(product.getName());
        detailVO.setBrand(product.getBrand());
        detailVO.setDescription(product.getDescription());
        detailVO.setStatus(product.getStatus());
        detailVO.setSkus(skus);
        return detailVO;
    }

    private ProductListVO toProductListVO(Product product) {
        ProductListVO vo = new ProductListVO();
        vo.setId(product.getId());
        vo.setCategoryId(product.getCategoryId());
        vo.setName(product.getName());
        vo.setBrand(product.getBrand());
        vo.setDescription(product.getDescription());
        vo.setStatus(product.getStatus());
        return vo;
    }

    private ProductSkuVO toProductSkuVO(ProductSku sku) {
        ProductSkuVO vo = new ProductSkuVO();
        vo.setId(sku.getId());
        vo.setSkuName(sku.getSkuName());
        vo.setVolume(sku.getVolume());
        vo.setPackageSpec(sku.getPackageSpec());
        vo.setPrice(sku.getPrice());
        vo.setStock(sku.getStock());
        vo.setWarningStock(sku.getWarningStock());
        vo.setStorageCondition(sku.getStorageCondition());
        vo.setTransportNote(sku.getTransportNote());
        vo.setStatus(sku.getStatus());
        return vo;
    }
}
