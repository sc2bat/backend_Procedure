package com.ezen.spm17.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ezen.spm17.service.cartService;

@Controller
public class cartController {
	private HashMap<String, Object> paramMap;
	
	@Autowired
	cartService cs;
	
	@RequestMapping("/cartInsert")
	public String cartInsert(@RequestParam("pseq")int pseq, @RequestParam("quantity")int quantity,
			HttpServletRequest request, Model model) {
		String url = "";
		HashMap<String, Object> loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			paramMap = new HashMap<String, Object>();
			paramMap.put("userid", loginUser.get("USERID"));
			paramMap.put("pseq", pseq);
			paramMap.put("quantity", quantity);
			cs.insertCart(paramMap);
			url = "redirect:/cartList";
		}
		return url;
	}
	
	@RequestMapping("/cartList")
	public String cartList(HttpServletRequest request, Model model) {
		String url = "";
		HashMap<String, Object> loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			paramMap = new HashMap<String, Object>();
			paramMap.put("id", loginUser.get("USERID"));
			paramMap.put("cartList_cursor", null);
			cs.selectCartList(paramMap);
			ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("cartList_cursor");
			int totalPrice = 0;
			for(HashMap<String, Object> cvo : list) {
				totalPrice += Integer.parseInt(cvo.get("PRICE2").toString()) * 
						Integer.parseInt(cvo.get("QUANTITY").toString());
			}
			model.addAttribute("cartList", list);
			model.addAttribute("totalPrice", totalPrice);
			url = "mypage/cartList";
		}
		return url;
	}
	
	@RequestMapping("/cartDelete")
	public String deleteCart(HttpServletRequest request) {
		String url = "";
		if(request.getSession().getAttribute("loginUser") == null) {
			url = "member/login";
		}else {
			String[] cseqArr = request.getParameterValues("cseq");
			
			paramMap = new HashMap<String, Object>();
			for(String cseq : cseqArr) {
				paramMap.put("cseq", cseq);
				cs.deleteCart(paramMap);
			}
			url = "redirect:/cartList";
		}
		return url;
	}
	
}
