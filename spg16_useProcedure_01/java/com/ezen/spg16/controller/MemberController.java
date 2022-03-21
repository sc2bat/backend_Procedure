package com.ezen.spg16.controller;

import java.util.ArrayList;
import java.util.HashMap;

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
import org.springframework.web.servlet.ModelAndView;

import com.ezen.spg16.dto.MemberVO;
import com.ezen.spg16.service.MemberService;

@Controller
public class MemberController {
	@Autowired
	MemberService ms;
	
	@RequestMapping("/")
	public String index(HttpServletRequest request) {
		HttpSession session = request.getSession();
		if(session.getAttribute("loginUser") == null) {
			return "member/loginForm";
		}else {
//			return "redirect:/main";
			return "main";
		}
	}

	@RequestMapping(value="/login", method=RequestMethod.POST)
	public String login(@ModelAttribute("dto")@Valid MemberVO membervo, BindingResult result, 
			HttpServletRequest request, Model model) {
		if(result.getFieldError("userid") != null) {
			model.addAttribute("message", result.getFieldError("userid").getDefaultMessage());
			return "member/loginForm";
		}else if(result.getFieldError("pwd") != null) {
			model.addAttribute("message", result.getFieldError("pwd").getDefaultMessage());
			return "member/loginForm";
		}
		//
//		MemberVO mvo = ms.getMember(membervo.getUserid());
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("userid", membervo.getUserid());
		paramMap.put("ref_cursor", null); // ������ �������� �𸣱⿡ �ϴ� null
		ms.getMember(paramMap); // ����Ŭ ���ν������� Ŀ���� ��ܿ��� �ڷ����� �Ѱ��̻��� ���ڵ���Դϴ�
		// �� getMember �� ����� ���̵�� �˻��� �Ѹ��� ������������, ����� ����Ʈ���·� ��ܿɴϴ�
		// �� �� ù��°�� MemberVO �� ������ ��Ƽ� ����մϴ�
		
		// 1. ����Ʈ���� �����ϴ�
		ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor");
		// ���ν����� ����� ���ڵ��� ����Ʈ���ε� �� ���ڵ�� <�ʵ��, �ʵ尪> ������ �ؽ����Դϴ�.
		// �ؽ��� �ϳ��� �ϳ��� ���ڵ带 �̷�� �� �ȿ��� �� �ʵ��� ������ ����ֽ��ϴ�.
		// �� ���ڵ���� ������ ref_cursor ��� Ű�� ����Ǿ� ���ƿ� �ִ� �����Դϴ�.
		
		// * ����Ʈ�� ����� �������� ���� �˻��մϴ�
		if(list.size() == 0) {
			model.addAttribute("message", "id �� ����");
			return "member/loginForm";
		}
		
		// 2. ����Ʈ�� ù��° �׸��� mvo �� ����ϴ�
		HashMap<String, Object> mvo = (HashMap<String, Object>)list.get(0);
		// �ʵ�� �빮��
		/*
		System.out.println(mvo.get("USERID"));
		System.out.println(mvo.get("NAME"));
		System.out.println(mvo.get("PWD"));
		System.out.println(mvo.get("PHONE"));
		System.out.println(mvo.get("EMAIL"));*/
		
		if(mvo.get("PWD") == null) {
			model.addAttribute("message", "pwd �� ����");
			return "member/loginForm";
		}else if(!mvo.get("PWD").equals(membervo.getPwd())) {
			model.addAttribute("message", "pwd �� �ٸ�");
			return "member/loginForm";
		}else if(mvo.get("PWD").equals(membervo.getPwd())) {
			request.getSession().setAttribute("loginUser", mvo);
			return "redirect:/main";
//			return "member/main";
		}else {
			model.addAttribute("message", "�� �� ���� ������ �α��� �Ұ�");
			return "member/loginForm";
		}
	}
	
	
	
	
	
	
	
	
}
