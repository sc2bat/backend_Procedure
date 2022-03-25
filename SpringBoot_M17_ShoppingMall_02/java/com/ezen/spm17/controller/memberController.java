package com.ezen.spm17.controller;

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

import com.ezen.spm17.dto.MemberVO;
import com.ezen.spm17.service.memberService;

@Controller
public class memberController {
	private ModelAndView mav;
	private HashMap<String, Object> paramMap;
	
	@Autowired
	memberService ms;
	
	@RequestMapping("/loginForm")
	public String loginForm(HttpServletRequest request) {
		return "member/login";
	}
	
	@RequestMapping(value="/login", method=RequestMethod.POST)
	public String login(@ModelAttribute("dto")@Valid MemberVO membervo, BindingResult result,
			HttpServletRequest request, Model model) {
		String url = "member/login";
		String msg = "";
		if(result.getFieldError("userid") != null) {
			msg = "ID 입력하세여";
		}else if(result.getFieldError("pwd") != null) {
			msg = "pwd 입력하세여";
		}else {
			paramMap = new HashMap<String, Object>();
			paramMap.put("userid", membervo.getUserid());
			paramMap.put("ref_cursor_loginCheck", null);
			ms.getMember(paramMap);
			ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor_loginCheck");
			if(list.size() == 0) {
				msg = "없는 id";
			}else {
				HashMap<String, Object> mvo = list.get(0);
				if(mvo == null) {
					msg = "ID가 없습니다";
				}else if(membervo.getPwd() == null) {
					msg = "관리자에게 문의";
				}else if(!membervo.getPwd().equals((String)mvo.get("PWD"))) {
					msg = "비밀번호 다름";
				}else if(membervo.getPwd().equals((String)mvo.get("PWD"))) {
					HttpSession session = request.getSession();
					session.setAttribute("loginUser", mvo);
					url = "redirect:/";
				}else {
					msg = "알수없는 이유로 로그인 불가";
				}
			}
			
		}
		model.addAttribute("message", msg);
		return url;
	}
	
	@RequestMapping("/logout")
	public String logout(HttpServletRequest request) {
		request.getSession().invalidate();
		return "redirect:/";
	}
	
	@RequestMapping("/contract")
	public String contract() {
		return "member/contract";
	}
	
	@RequestMapping("/joinForm")
	public String joinForm() {
		return "member/joinForm";
	}
	
	@RequestMapping("/idCheckForm")
	public String idCheckForm(@RequestParam("userid")String userid, Model model
			, HttpServletRequest request) {
		paramMap = new HashMap<String, Object>();
		paramMap.put("userid", userid);
		paramMap.put("ref_cursor", null);
		ms.getMember(paramMap);
		ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor_loginCheck");
		if(list.size() == 0) {
			model.addAttribute("result", -1);
		}else {
			model.addAttribute("result", 1);
		}
		model.addAttribute("userid", userid);
		return "member/idcheck";
	}
	
	@RequestMapping("/findZipNum")
	public String findZipNum(HttpServletRequest request, Model model) {
		String dong = request.getParameter("dong");
		if(dong!= null && dong.trim().equals("") == false) {
			paramMap = new HashMap<String, Object>();
			paramMap.put("dong", dong);
			paramMap.put("cursor_dong", null);
			ms.selectAddressByDong(paramMap);
			ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("cursor_dong");
			model.addAttribute("addressList", list);
		}
		return "member/findZipNum";
	}
	
	@RequestMapping(value="/join", method=RequestMethod.POST)
	public ModelAndView join(@ModelAttribute("dto")@Valid MemberVO membervo, BindingResult result,
			@RequestParam(value="reid", required=false)String reid, @RequestParam(value="pwdCheck", required=false)String pwdCheck,
			HttpServletRequest request) {
		mav = new ModelAndView();
		String msg = "";
		mav.setViewName("member/joinForm");
		if(result.getFieldError("userid") != null) {
			msg = "userid null";
			msg = result.getFieldError("userid").getDefaultMessage();
		}else if(!membervo.getUserid().equals(reid) || reid == null) {
			msg = "check id dupli";
		}else if(result.getFieldError("pwd") != null) {
			msg = "pwd null";
		}else if(!membervo.getPwd().equals(pwdCheck) || pwdCheck == null) {
			msg = "pwd != pwd check";
		}else if(result.getFieldError("name") != null) {
			msg = "name null";
		}else if(result.getFieldError("email") != null) {
			msg = "email null";
		}else if(result.getFieldError("phone") != null) {
			msg = "phone null";
		}else {
			paramMap = new HashMap<String, Object>();
			paramMap.put("userid", membervo.getUserid());
			paramMap.put("pwd", membervo.getPwd());
			paramMap.put("name", membervo.getName());
			paramMap.put("email", membervo.getEmail());
			paramMap.put("phone", membervo.getPhone());
			paramMap.put("zip_num", membervo.getZip_num());
			paramMap.put("address", membervo.getAddress());
			paramMap.put("address2", membervo.getAddress2());
			
			ms.insertMember(paramMap);
			
			msg = "sign up complete";
			mav.setViewName("member/login");
		}
		mav.addObject("reid", reid);
		mav.addObject("message", msg);
		return mav;
	}
	
	@RequestMapping("/memberEditForm")
	public String memberEditForm(HttpServletRequest request, Model model) {
		HashMap<String, Object> loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		String url = "member/memberUpdateForm";
		if(loginUser == null) {
			url = "member/login";
		}
		MemberVO membervo = new MemberVO();
		membervo.setUserid((String)loginUser.get("USERID"));
		membervo.setPwd((String)loginUser.get("PWD"));
		membervo.setName((String)loginUser.get("NAME"));
		membervo.setEmail((String)loginUser.get("EMAIL"));
		membervo.setPhone((String)loginUser.get("PHONE"));
		membervo.setZip_num((String)loginUser.get("ZIP_NUM"));
		membervo.setAddress((String)loginUser.get("ADDRESS"));
		membervo.setAddress2((String)loginUser.get("ADDRESS2"));
		model.addAttribute("dto", membervo);
		return url;
	}
	/**/
	@RequestMapping("/memberEditFormHashMap")
	public String memberEditFormHashMap(HttpServletRequest request, Model model) {
		HashMap<String, Object> loginUser = (HashMap<String, Object>)request.getSession().getAttribute("loginUser");
		String url = "";
		if(loginUser == null) {
			url = "member/login";
		}else {
			url = "member/memberUpdateFormHashMaps";
		}
		return url;
	}
	
	
	@RequestMapping(value="/memberUpdate", method=RequestMethod.POST)
	public ModelAndView memberUpdate(@ModelAttribute("dto")@Valid MemberVO membervo, BindingResult result,
			HttpServletRequest request, Model model, @RequestParam("pwdCheck")String pwdCheck) {
		mav = new ModelAndView();
		String msg = "";
		mav.setViewName("member/memberUpdateForm");
		if(result.getFieldError("pwd") != null) {
			msg = "pwd null";
		}else if(!membervo.getPwd().equals(pwdCheck) || pwdCheck == null) {
			msg = "pwd != pwd check";
		}else if(result.getFieldError("name") != null) {
			msg = "name null";
		}else if(result.getFieldError("email") != null) {
			msg = "email null";
		}else if(result.getFieldError("phone") != null) {
			msg = "phone null";
		}else {
			paramMap = new HashMap<String, Object>();
			paramMap.put("USERID", membervo.getUserid()); 
			paramMap.put("PWD", membervo.getPwd());
			paramMap.put("NAME", membervo.getName());
			paramMap.put("EMAIL", membervo.getEmail());
			paramMap.put("PHONE", membervo.getPhone());
			paramMap.put("ZIP_NUM", membervo.getZip_num());
			paramMap.put("ADDRESS", membervo.getAddress());
			paramMap.put("ADDRESS2", membervo.getAddress2());
			
			ms.updateMember(paramMap);
			
			request.getSession().setAttribute("loginUser", paramMap);
			
			msg = "update complete";
			mav.setViewName("redirect:/");
		}
		mav.addObject("message", msg);
		return mav;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
