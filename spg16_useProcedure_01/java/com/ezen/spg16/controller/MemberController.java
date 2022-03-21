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
		paramMap.put("ref_cursor", null); // 형식이 무엇인지 모르기에 일단 null
		ms.getMember(paramMap); // 오라클 프로시저에서 커서에 담겨오는 자료형은 한개이상의 레코드들입니다
		// 위 getMember 의 결과는 아이디로 검색한 한명의 데이터이지만, 결과는 리스트형태로 담겨옵니다
		// 그 중 첫번째를 MemberVO 에 꺼내어 담아서 사용합니다
		
		// 1. 리스트부터 꺼냅니다
		ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor");
		// 프로시저의 결과는 레코드의 리스트들인데 각 레코드는 <필드명, 필드값> 형태의 해쉬맵입니다.
		// 해쉬맵 하나가 하나의 레코드를 이루고 그 안에는 각 필드명과 값들이 들어있습니다.
		// 그 레코드들의 집합이 ref_cursor 라는 키에 저장되어 돌아와 있는 형태입니다.
		
		// * 리스트에 결과가 없는지를 먼저 검색합니다
		if(list.size() == 0) {
			model.addAttribute("message", "id 가 없음");
			return "member/loginForm";
		}
		
		// 2. 리스트의 첫번째 항목을 mvo 에 담습니다
		HashMap<String, Object> mvo = (HashMap<String, Object>)list.get(0);
		// 필드명 대문자
		/*
		System.out.println(mvo.get("USERID"));
		System.out.println(mvo.get("NAME"));
		System.out.println(mvo.get("PWD"));
		System.out.println(mvo.get("PHONE"));
		System.out.println(mvo.get("EMAIL"));*/
		
		if(mvo.get("PWD") == null) {
			model.addAttribute("message", "pwd 가 없음");
			return "member/loginForm";
		}else if(!mvo.get("PWD").equals(membervo.getPwd())) {
			model.addAttribute("message", "pwd 가 다름");
			return "member/loginForm";
		}else if(mvo.get("PWD").equals(membervo.getPwd())) {
			request.getSession().setAttribute("loginUser", mvo);
			return "redirect:/main";
//			return "member/main";
		}else {
			model.addAttribute("message", "알 수 없는 이유로 로그인 불가");
			return "member/loginForm";
		}
	}
	
	
	
	
	
	
	
	
}
