package com.ezen.spm17.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ezen.spm17.dao.IadminDao;

@Service
public class adminService {
	@Autowired
	IadminDao adao;

	public void checkAdminLogin(HashMap<String, Object> paramMap) {
		adao.checkAdminLogin(paramMap);
	}

	public void getAllCountProduct(HashMap<String, Object> paramMap) {
		adao.getAllCountProduct(paramMap);
	}

	public void getProductList(HashMap<String, Object> paramMap) {
		adao.getProductList(paramMap);
	}
}
