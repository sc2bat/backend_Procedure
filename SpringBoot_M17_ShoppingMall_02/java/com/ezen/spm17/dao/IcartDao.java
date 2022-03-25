package com.ezen.spm17.dao;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IcartDao {

	void insertCart(HashMap<String, Object> paramMap);

	void selectCartList(HashMap<String, Object> paramMap);

	void deleteCart(HashMap<String, Object> paramMap);
	
	
}
