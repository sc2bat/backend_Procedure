package com.ezen.spm17.dao;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IorderDao {

	void insertOrder(HashMap<String, Object> paramMap);

	void getOrderList(HashMap<String, Object> paramMap);
	
}
