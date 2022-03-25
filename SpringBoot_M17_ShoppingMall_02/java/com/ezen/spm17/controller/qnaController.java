package com.ezen.spm17.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.ezen.spm17.dto.QnaVO;
import com.ezen.spm17.service.qnaService;

@Controller
public class qnaController {
	@Autowired
	qnaService qs;
	
	private HashMap<String, Object> paramMap;
	private HashMap<String, Object> loginUser;
	private ArrayList<HashMap<String, Object>> list;
	
	/* sample
	@RequestMapping("/qnaList")
	public String qnaList(HttpServletRequest request, Model model) {
		String url = "";
		loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			
			
			url = "";
		}
		return url;
	}
	*/	
	
	
	@RequestMapping("/qnaList")
	public String qnaList(HttpServletRequest request, Model model) {
		String url = "";
		loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			paramMap = new HashMap<String, Object>();
			paramMap.put("id", loginUser.get("USERID"));
			paramMap.put("ref_cursor", null);
			qs.getQnaList(paramMap);
			list = (ArrayList<HashMap<String, Object>> )paramMap.get("ref_cursor");
			model.addAttribute("qnaList", list);
			url = "qna/qnaList";
		}
		
		return url;
	}
	
	@RequestMapping("/qnaView")
	public String qnaView(HttpServletRequest request, Model model, @RequestParam("qseq")int qseq) {
		String url = "";
		loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			paramMap = new HashMap<String, Object>();
			paramMap.put("qseq", qseq);
			paramMap.put("ref_cursor", null);
			qs.getQnaView(paramMap);
			list = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor");
			model.addAttribute("qnaVO", list.get(0));
			url = "qna/qnaView";
		}
		return url;
	}
	
	@RequestMapping("/qnaWriteForm")
	public String qnaWriteForm(HttpServletRequest request, Model model) {
		String url = "";
		loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			url = "qna/qnaWrite";
		}
		return url;
	}
	
	@RequestMapping(value="/qnaWrite", method=RequestMethod.POST)
	public String qnaWrite(HttpServletRequest request, Model model, @ModelAttribute("dto")@Valid QnaVO qnavo
			, BindingResult result) {
		String url = "qna/qnaWrite";
		loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		if(loginUser == null) {
			url = "member/login";
		}else {
			if(result.getFieldError("subject") != null) {
				model.addAttribute("message", result.getFieldError("subject").getDefaultMessage());
			}else if(result.getFieldError("content") != null) {
				model.addAttribute("message", result.getFieldError("content").getDefaultMessage());
			}else {
				paramMap = new HashMap<String, Object>();
				paramMap.put("id", loginUser.get("USERID"));
				paramMap.put("subject", qnavo.getSubject());
				paramMap.put("content", qnavo.getContent());
				qs.insertQna(paramMap);
				
				url = "redirect:/qnaList";
			}
		}
		return url;
	}
	
	
}
