package com.ezen.spm17.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ezen.spm17.dto.AdminVO;
import com.ezen.spm17.dto.Paging;
import com.ezen.spm17.service.adminService;
import com.ezen.spm17.service.productService;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@Controller
public class adminController {
	private HashMap<String, Object> paramMap;
	private HashMap<String, Object> adminInfo;
	private ArrayList<HashMap<String, Object>> list;
	
	@Autowired
	adminService as;
	
	@Autowired
	productService ps;
	
	@Autowired
	ServletContext context;
	
	@RequestMapping("/admin")
	public String adminLogin() {
		return "admin/adminLoginForm";
	}
	
	@RequestMapping(value="/adminLogin", method=RequestMethod.POST)
	public String adminLogin(HttpServletRequest request, Model model, 
			@ModelAttribute("dto")@Valid AdminVO adminvo, BindingResult result) {
		String url = "admin/adminLoginForm";
		String msg = "adminLogin msg";
		if(result.getFieldError("id") != null) {
			msg = result.getFieldError("id").getDefaultMessage();
		}else if(result.getFieldError("pwd") != null) {
			msg = result.getFieldError("pwd").getDefaultMessage();
		}else {
			paramMap = new HashMap<String, Object>();
			paramMap.put("id", adminvo.getId());
			paramMap.put("ref_cursor", null);
			as.checkAdminLogin(paramMap);
			list = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor");
			HashMap<String, Object> resultMap = list.get(0);
			if(list.size() == 0) {
				msg = "none id";
			}else if(!adminvo.getPwd().equals((String)resultMap.get("PWD"))) {
				msg = "wrong pwd";
			}else if(adminvo.getPwd().equals((String)resultMap.get("PWD"))) {
				request.getSession().setAttribute("loginAdmin", resultMap);
				url = "redirect:/productList";
			}else {
				msg = "i have no idea";
			}
		}
		model.addAttribute("message", msg);
		return url;
	}
	
	@RequestMapping("/productList")
	public String productList(HttpServletRequest request, Model model) {
		String url = "";
		HttpSession session = request.getSession();
		adminInfo = (HashMap<String, Object>)session.getAttribute("loginAdmin");
		if(adminInfo == null) {
			url = "admin/adminLoginForm";
		}else {
			
			int page = 1;
			String key = "";
			if(request.getParameter("first") != null) {
				session.removeAttribute("page");
				session.removeAttribute("key");
			}
			if(request.getParameter("page") != null) {
				page = Integer.parseInt(request.getParameter("page"));
				session.setAttribute("page", page);
			}else if(session.getAttribute("page") != null) {
				page = (Integer)session.getAttribute("page");
			}else {
				session.removeAttribute("page");
			}
			if(request.getParameter("key") != null) {
				key = request.getParameter("key");
				session.setAttribute("key", key);
			}else if(session.getAttribute("key") != null) {
				key = (String)session.getAttribute("key");
			}else {
				session.removeAttribute("key");
			}
			Paging paging = new Paging();
			paging.setPage(page);
			paramMap = new HashMap<String, Object>();
			paramMap.put("key", key);
			paramMap.put("cnt", 0);
			as.getAllCountProduct(paramMap);
			int cnt = Integer.parseInt(paramMap.get("cnt").toString());
			paging.setTotalCount(cnt);
			
			paramMap = new HashMap<String, Object>();
			paramMap.put("startNum", paging.getStartNum());
			paramMap.put("endNum", paging.getEndNum());
			paramMap.put("key", key);
			paramMap.put("ref_cursor", null);
			as.getProductList(paramMap);
			list = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor");
			model.addAttribute("productList", list);
			model.addAttribute("key", key);
			model.addAttribute("paging", paging);
			url = "admin/product/productList";
		}
		return url;
	}
	
	@RequestMapping("/adminLogout")
	public String adminLogout(HttpServletRequest request) {
		request.getSession().invalidate();
		return "admin/adminLoginForm";
	}
	
	@RequestMapping("/productWriteForm")
	public String productWirte(HttpServletRequest request, Model model) {
		String kindList[] = {"Heels", "Boots", "Sandals", "Shcakers", "Slipers", "Sale"};
		model.addAttribute("kindList", kindList);
		return "admin/product/productWriteForm";
	}
	
	@RequestMapping("/fileup")
	@ResponseBody
	public Map<String, Object> fileup(HttpServletRequest request, Model model){
		String savePath = context.getRealPath("/product_images");
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			MultipartRequest multi = new MultipartRequest(request, savePath, 5*1024*1024, "UTF-8", 
					new DefaultFileRenamePolicy());
			resultMap.put("STATUS", 1);
			resultMap.put("FILENAME", multi.getFilesystemName("image"));
		} catch (IOException e) {
			e.printStackTrace();
		}
		return resultMap;
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
