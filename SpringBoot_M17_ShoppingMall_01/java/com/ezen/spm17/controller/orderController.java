package com.ezen.spm17.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ezen.spm17.service.orderService;

@Controller
public class orderController {
	private HashMap<String, Object> loginUser;
	private HashMap<String, Object> paramMap;
	
	@Autowired
	orderService os;
	
	@RequestMapping("/orderInsert")
	public String orderInsert(HttpServletRequest request, Model model) {
		int oseq = 0;
		String url = "";
		HashMap<String, Object> loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			paramMap = new HashMap<String, Object>();
			paramMap.put("userid", loginUser.get("USERID"));
			paramMap.put("oseq", oseq);
			
			os.insertOrder(paramMap);
			// 아이디로 카트검색
			// 검색내용으로 orders 와 order_detail 테이블에 레코드 추가
			// oseq 에 주문번호를 넣어 리턴
			
			oseq = Integer.parseInt(paramMap.get("oseq").toString());
			
			url = "redirect:/orderList?oseq=" + oseq;
		}
		return url;
	}
	
	@RequestMapping("/orderList")
	public String orderList(HttpServletRequest request, Model model, @RequestParam("oseq")int oseq) {
		String url = "";
		loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			paramMap = new HashMap<String, Object>();
			paramMap.put("oseq", oseq);
			paramMap.put("orderList_cursor", null);
			os.getOrderList(paramMap);
			ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("orderList_cursor");
			
			int totalPrice = 0;
			for(HashMap<String, Object> ovo : list) {
				totalPrice += Integer.parseInt(ovo.get("PRICE2").toString()) * 
						Integer.parseInt(ovo.get("QUANTITY").toString());
			}
			model.addAttribute("orderList", list);
			model.addAttribute("totalPrice", totalPrice);
			url = "mypage/orderList";
		}
		
		return url;
	}
}
