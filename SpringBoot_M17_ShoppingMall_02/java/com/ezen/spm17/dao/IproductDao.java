package com.ezen.spm17.dao;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IproductDao {

	void getBestNewProduct(HashMap<String, Object> paramMap);

	void getKindList(HashMap<String, Object> paramMap);

	void getProductDetail(HashMap<String, Object> paramMap);
}
