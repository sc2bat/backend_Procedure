package com.ezen.spm17.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ezen.spm17.dao.IproductDao;

@Service
public class productService {
	
	@Autowired
	IproductDao pdao;

	public void getBestNewProduct(HashMap<String, Object> paramMap) {
		pdao.getBestNewProduct(paramMap);
	}

	public void getKindList(HashMap<String, Object> paramMap) {
		pdao.getKindList(paramMap);
	}

	public void getProductDetail(HashMap<String, Object> paramMap) {
		pdao.getProductDetail(paramMap);
	}
}
