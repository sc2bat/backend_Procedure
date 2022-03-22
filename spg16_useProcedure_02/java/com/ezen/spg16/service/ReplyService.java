package com.ezen.spg16.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ezen.spg16.dao.IReplyMapper;

@Service
public class ReplyService {
	
	@Autowired
	IReplyMapper rdao;

	public void insertReply(HashMap<String, Object> paramMap) {
		rdao.insertReply(paramMap);
	}

	public void deleteReply(HashMap<String, Object> paramMap) {
		rdao.deleteReply(paramMap);
	}
}
