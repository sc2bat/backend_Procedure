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
	
	
	@RequestMapping("/myPage")
	public String myPage(HttpServletRequest request, Model model) {
		String url = "";
		loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			ArrayList<HashMap<String, Object>> finalList = new ArrayList<HashMap<String, Object>>();
			paramMap = new HashMap<String, Object>();
			paramMap.put("id", loginUser.get("USERID"));
			paramMap.put("ref_cursor", null);
			os.getOrderListById(paramMap);
			ArrayList<HashMap<String, Object>> oseqList = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor");
			// 주문번호별 주문내역을 조회
			for(HashMap<String, Object> result : oseqList) {
				int oseq = Integer.parseInt(result.get("OSEQ").toString());
				HashMap<String, Object> paramMap2 = new HashMap<String, Object>();
				paramMap2.put("oseq", oseq);
				paramMap2.put("orderList_cursor", null);
				os.getOrderList(paramMap2);
				ArrayList<HashMap<String, Object>> orderListByOseq = 
						(ArrayList<HashMap<String, Object>>)paramMap2.get("orderList_cursor");
				HashMap<String, Object> orderFirst = orderListByOseq.get(0);
				orderFirst.put("PNAME", (String)orderFirst.get("PNAME") + " 포함 " + orderListByOseq.size() + " 건");
				
				int totalPrice = 0;
				for(HashMap<String, Object> order : orderListByOseq) {
					totalPrice += Integer.parseInt(order.get("QUANTITY").toString())
									* Integer.parseInt(order.get("PRICE2").toString());
				}
				orderFirst.put("PRICE2", totalPrice);
				finalList.add(orderFirst);
			}
			model.addAttribute("orderList", finalList);
			
			url = "mypage/mypage";
		}
		model.addAttribute("title", "진행중인 주문내역");
		return url;
	}
//    --oracle.jdbc.OracleDatabaseException: ORA-01791: not a SELECTed expression
//    -- distinct ORDER BY 같이쓰면 나옴
	
	
	@RequestMapping("/orderAll")
	public String orderAll(HttpServletRequest request, Model model) {
		String url = "";
		loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			ArrayList<HashMap<String, Object>> finalList = new ArrayList<HashMap<String, Object>>();
			paramMap = new HashMap<String, Object>();
			paramMap.put("id", loginUser.get("USERID"));
			paramMap.put("ref_cursor", null);
			os.getOrderListByIdAll(paramMap);
			ArrayList<HashMap<String, Object>> oseqList = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor");
			// 주문번호별 주문내역을 조회
			for(HashMap<String, Object> result : oseqList) {
				int oseq = Integer.parseInt(result.get("OSEQ").toString());
				HashMap<String, Object> paramMap2 = new HashMap<String, Object>();
				paramMap2.put("oseq", oseq);
				paramMap2.put("orderList_cursor", null);
				os.getOrderList(paramMap2);
				ArrayList<HashMap<String, Object>> orderListByOseq = 
						(ArrayList<HashMap<String, Object>>)paramMap2.get("orderList_cursor");
				HashMap<String, Object> orderFirst = orderListByOseq.get(0);
				orderFirst.put("PNAME", (String)orderFirst.get("PNAME") + " 포함 " + orderListByOseq.size() + " 건");
				
				int totalPrice = 0;
				for(HashMap<String, Object> order : orderListByOseq) {
					totalPrice += Integer.parseInt(order.get("QUANTITY").toString())
									* Integer.parseInt(order.get("PRICE2").toString());
				}
				orderFirst.put("PRICE2", totalPrice);
				finalList.add(orderFirst);
			}
			model.addAttribute("orderList", finalList);
			
			url = "mypage/mypage";
		}
		model.addAttribute("title", "총 주문내역");
		return url;
	}
	
	@RequestMapping("/orderDetail")
	public String orderDetail(HttpServletRequest request, Model model, @RequestParam("oseq")int oseq) {
		String url = "";
		loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			paramMap = new HashMap<String, Object>();
			paramMap.put("oseq", oseq);
			paramMap.put("orderList_cursor", null);
			os.getOrderList(paramMap);
			ArrayList<HashMap<String, Object>> orderListByOseq = 
					(ArrayList<HashMap<String, Object>>)paramMap.get("orderList_cursor");
			int totalPrice = 0;
			for(HashMap<String, Object> order : orderListByOseq) {
				totalPrice += Integer.parseInt(order.get("QUANTITY").toString())
								* Integer.parseInt(order.get("PRICE2").toString());
			}
			model.addAttribute("totalPrice", totalPrice);
			model.addAttribute("orderList", orderListByOseq);
			model.addAttribute("orderDetail", orderListByOseq.get(0));
			url = "mypage/orderDetail";
		}
		return url;
	}
	
	@RequestMapping("/orderOne")
	public String orderOne(HttpServletRequest request, Model model,
			@RequestParam("pseq")int pseq, @RequestParam("quantity")int quantity) {
		String url = "";
		loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			int oseq = 0;
			paramMap = new HashMap<String, Object>();
			paramMap.put("id", loginUser.get("USERID"));
			paramMap.put("pseq", pseq);
			paramMap.put("quantity", quantity);
			paramMap.put("oseq", oseq);
			
			os.insertOrderOne(paramMap);
			oseq = Integer.parseInt(paramMap.get("oseq").toString());
			url = "redirect:/orderList?oseq=" + oseq;
		}
		return url;
	}
	
	
}
