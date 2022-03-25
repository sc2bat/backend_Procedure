package com.ezen.spm17.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.ezen.spm17.service.productService;

@Controller
public class productController {
	private ModelAndView mav;
	private HashMap<String, Object> paramMap;
	
	@Autowired
	productService ps;
	
	@RequestMapping("/")
	public ModelAndView main(HttpServletRequest request, Model model) {
		mav = new ModelAndView();
		paramMap = new HashMap<String, Object>();
		paramMap.put("ref_cursor_best", null);
		paramMap.put("ref_cursor_new", null);
		
		ps.getBestNewProduct(paramMap);
		
		ArrayList<HashMap<String, Object>> bestList = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor_best");
		ArrayList<HashMap<String, Object>> newList = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor_new");
		
		mav.addObject("bestProductList", bestList);
		mav.addObject("newProductList", newList);
		
		mav.setViewName("main");
		
		return mav;
	}
	
	@RequestMapping("/category")
	public String category(@RequestParam("kind")String kind, Model model) {
		paramMap = new HashMap<String, Object>();
		paramMap.put("kind", kind);
		paramMap.put("ref_cursor_kind", null);
		ps.getKindList(paramMap);
		ArrayList<HashMap<String, Object>> kindList = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor_kind");
		model.addAttribute("productKindList", kindList);
		return "product/productKind";
	}
	
	@RequestMapping("/productDetail")
	public String productDetail(HttpServletRequest request, Model model, @RequestParam("pseq")int pseq) {
		String url = "product/productDetail";
		paramMap = new HashMap<String, Object>();
		paramMap.put("pseq", pseq);
		paramMap.put("product_cursor", null);
		ps.getProductDetail(paramMap);
		ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("product_cursor");
		HashMap<String, Object> resultMap = list.get(0);
		model.addAttribute("productVO", resultMap);
		return url;
	}
}
