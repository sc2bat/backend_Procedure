package com.ezen.spm17.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ezen.spm17.dao.IcartDao;

@Service
public class cartService {

	@Autowired
	IcartDao cdao;

	@Transactional(rollbackFor = Exception.class)
	public void insertCart(HashMap<String, Object> paramMap) {
		cdao.insertCart(paramMap);
	}

	public void selectCartList(HashMap<String, Object> paramMap) {
		cdao.selectCartList(paramMap);
	}

	public void deleteCart(HashMap<String, Object> paramMap) {
		cdao.deleteCart(paramMap);
	}
}
