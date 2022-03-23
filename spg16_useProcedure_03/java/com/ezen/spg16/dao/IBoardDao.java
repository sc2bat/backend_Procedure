package com.ezen.spg16.dao;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IBoardDao {

	void selectBoard(HashMap<String, Object> paramMap);

	void getAllCount(HashMap<String, Object> paramMap);

	void plusReadCount(HashMap<String, Object> paramMap);

	void boardView(HashMap<String, Object> paramMap);

	void getBoardOne(HashMap<String, Object> paramMap);

	void updateBoard(HashMap<String, Object> paramMap);

	void deleteBoard(HashMap<String, Object> paramMap);

	void insertBoard(HashMap<String, Object> paramMap);
	
}
