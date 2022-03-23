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
import org.springframework.web.bind.annotation.RequestParam;
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
	
	@RequestMapping(value="/logout", method=RequestMethod.GET)
	public String logout(HttpServletRequest request) {
		request.getSession().invalidate();
		return "redirect:/";
	}
	
	@RequestMapping("/memberJoinForm")
	public String memberJoinForm() {
		return "member/memberJoinForm";
	}
	
	@RequestMapping("/idcheck")
	public ModelAndView idcheck(@RequestParam("userid")String userid) {
		ModelAndView mav = new ModelAndView();
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("userid", userid);
		paramMap.put("ref_cursor", null); // ������� ��ƿ� Ŀ��
//		MemberVO mvo = ms.getMember(userid);
		ms.getMember(paramMap);
		// object �����̱� ������ ����ȯ���ٰ�
		ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor");
		
//		HashMap<String, Object> mvo = list.get(0); // ������� �ֳ� ���İ� �߿��Ѱ�
//		if(mvo == null) { // ������� ���ٸ� ������ �߻��� ������ �ֱ⿡
		if(list.size() == 0) {
			mav.addObject("result", -1);
		}else {
			mav.addObject("result", 1);
		}
		mav.addObject("userid", userid);
		mav.setViewName("member/idcheck");
		return mav;
	}
	
	@RequestMapping(value="/memberJoin", method=RequestMethod.POST)
	public ModelAndView memberJoin(@ModelAttribute("dto")@Valid MemberVO membervo, BindingResult result,
			@RequestParam("re_id")String re_id, @RequestParam("pwd_check")String pwd_check) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("member/memberJoinForm");
		
		if(re_id != null && !re_id.equals("")) {
			mav.addObject("re_id", re_id);
		}
		
		if(result.getFieldError("userid") != null) {
			mav.addObject("message", result.getFieldError("userid").getDefaultMessage());
		}else if(!membervo.getUserid().equals(re_id)) {
			mav.addObject("message", "re_id null / id check");
		}else if(result.getFieldError("pwd") != null) {
			mav.addObject("message", result.getFieldError("pwd").getDefaultMessage());
		}else if(!membervo.getPwd().equals(pwd_check)) {
			mav.addObject("message", "pwd != pwd_check");
		}else if(result.getFieldError("name") != null) {
			mav.addObject("message", result.getFieldError("name").getDefaultMessage());
		}else if(result.getFieldError("phone") != null) {
			mav.addObject("message", result.getFieldError("phone").getDefaultMessage());
		}else if(result.getFieldError("email") != null) {
			mav.addObject("message", result.getFieldError("email").getDefaultMessage());
		}else {
//			ms.insertMember(membervo);
			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("userid", membervo.getUserid()); // �̷��� �ص���
			paramMap.put("pwd", membervo.getPwd());
			paramMap.put("name", membervo.getName());
			paramMap.put("email", membervo.getEmail());
			paramMap.put("phone", membervo.getPhone());
			ms.insertMember(paramMap);
			
			mav.addObject("message", "sign up complete");
			mav.setViewName("member/loginForm");
		}
		return mav;
	}
	
	@RequestMapping("/memberEditForm")
	public ModelAndView memberEditForm(HttpServletRequest rq) {
		ModelAndView mav = new ModelAndView();
		HashMap<String, Object> loginUser = (HashMap<String, Object>)rq.getSession().getAttribute("loginUser");
		MemberVO dto = new MemberVO();
		// HashMap ��������°��� �빮�� 
		dto.setUserid((String)loginUser.get("USERID"));
		dto.setPwd((String)loginUser.get("PWD"));
		dto.setName((String)loginUser.get("NAME"));
		dto.setEmail((String)loginUser.get("EMAIL"));
		dto.setPhone((String)loginUser.get("PHONE"));
		if(dto == null) {
			mav.setViewName("member/loginForm");
		}else {
			mav.addObject("dto", dto);
			mav.setViewName("member/memberEditForm");
		}
		return mav;
	}
	
	@RequestMapping(value="/memberEdit", method=RequestMethod.POST)
	public String memberEdit(@ModelAttribute("dto")@Valid MemberVO membervo, BindingResult result,
			@RequestParam("pwd_check")String pwd_check, Model model, HttpServletRequest request) {
		String url = "member/memberEditForm";
		if(result.getFieldError("pwd") != null) {
			model.addAttribute("message", "pwd null");
		}else if(result.getFieldError("name") != null) {
			model.addAttribute("message", "name null");
		}else if(!membervo.getPwd().equals(pwd_check)) {
			model.addAttribute("message", "pwd != pwd_check");
		}else {
			HashMap<String, Object> mvo = new HashMap<String, Object>();
			// HashMap ���� xml ���ϱ��� �Ѱ��ٶ� ��ҹ��� ���� �� ö�ڰ� �ٸ��� null ���� �Ѿ
			mvo.put("USERID", membervo.getUserid());
			mvo.put("PWD", membervo.getPwd());
			mvo.put("NAME", membervo.getName());
			mvo.put("EMAIL", membervo.getEmail());
			mvo.put("PHONE", membervo.getPhone());
			ms.updateMember(mvo);
			
//			ms.updateMember(membervo);
			
			request.getSession().setAttribute("loginUser", mvo);
			// update���� HashMap�� put �� �Ҷ� �빮�ڷ� �־����
			// jsp ���Ͽ��� �빮�� ���·� loginUser �� ����ϱ⶧���� �ҹ��ڷ�
			// mvo.put("userid", membervo.getUserid()); �ϸ� �ν��� ����
			url = "redirect:/main";
		}
		return url;
	}
	
	
}
