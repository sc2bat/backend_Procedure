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
		paramMap.put("ref_cursor", null); // 결과값을 담아올 커서
//		MemberVO mvo = ms.getMember(userid);
		ms.getMember(paramMap);
		// object 형태이기 때문에 형변환해줄것
		ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor");
		
//		HashMap<String, Object> mvo = list.get(0); // 결과값이 있냐 없냐가 중요한것
//		if(mvo == null) { // 결과값이 없다면 에러가 발생할 여지가 있기에
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
			paramMap.put("userid", membervo.getUserid()); // 이렇게 해도됨
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
		// HashMap 담겨져오는것은 대문자 
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
			// HashMap 으로 xml 파일까지 넘겨줄때 대소문자 구분 및 철자가 다르면 null 값이 넘어감
			mvo.put("USERID", membervo.getUserid());
			mvo.put("PWD", membervo.getPwd());
			mvo.put("NAME", membervo.getName());
			mvo.put("EMAIL", membervo.getEmail());
			mvo.put("PHONE", membervo.getPhone());
			ms.updateMember(mvo);
			
//			ms.updateMember(membervo);
			
			request.getSession().setAttribute("loginUser", mvo);
			// update에서 HashMap에 put 을 할때 대문자로 넣어야함
			// jsp 파일에서 대문자 형태로 loginUser 를 출력하기때문에 소문자로
			// mvo.put("userid", membervo.getUserid()); 하면 인식을 못함
			url = "redirect:/main";
		}
		return url;
	}
	
	
}
