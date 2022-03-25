package com.ezen.spm17.dao;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IqnaDao {

	void getQnaList(HashMap<String, Object> paramMap);

	void getQnaView(HashMap<String, Object> paramMap);

	void insertQna(HashMap<String, Object> paramMap);

}
