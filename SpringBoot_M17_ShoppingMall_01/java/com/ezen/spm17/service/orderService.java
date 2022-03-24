package com.ezen.spm17.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ezen.spm17.dao.IorderDao;

@Service
public class orderService {
	@Autowired
	IorderDao odao;
	
	@Transactional(rollbackFor = Exception.class)
	public void insertOrder(HashMap<String, Object> paramMap) {
		odao.insertOrder(paramMap);
	}

	public void getOrderList(HashMap<String, Object> paramMap) {
		odao.getOrderList(paramMap);
	}
}
