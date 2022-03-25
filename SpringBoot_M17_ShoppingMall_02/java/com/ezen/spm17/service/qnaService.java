package com.ezen.spm17.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ezen.spm17.dao.IqnaDao;

@Service
public class qnaService {
	@Autowired
	IqnaDao qdao;

	public void getQnaList(HashMap<String, Object> paramMap) {
		qdao.getQnaList(paramMap);
	}

	public void getQnaView(HashMap<String, Object> paramMap) {
		qdao.getQnaView(paramMap);
	}

	public void insertQna(HashMap<String, Object> paramMap) {
		qdao.insertQna(paramMap);
	}
}
