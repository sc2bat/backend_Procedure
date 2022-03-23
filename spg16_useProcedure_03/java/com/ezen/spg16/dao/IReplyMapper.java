package com.ezen.spg16.dao;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IReplyMapper {

	void insertReply(HashMap<String, Object> paramMap);

	void deleteReply(HashMap<String, Object> paramMap);
}
