package com.ezen.spg16.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ezen.spg16.service.ReplyService;

@Controller
public class ReplyController {
	@Autowired
	ReplyService rs;
	
	@RequestMapping("/addReply")
	public String addReply(@RequestParam("boardnum")int boardnum, 
			@RequestParam("userid")String userid, @RequestParam("content")String content) {
		// ´ñ±Û Ãß°¡
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("boardnum", boardnum);
		paramMap.put("userid", userid);
		paramMap.put("content", content);
		
		rs.insertReply(paramMap);
		
		return "redirect:/boardViewWithoutCount?num=" + boardnum;
	}
	
	@RequestMapping("/deleteReply")
	public String deleteReply(@RequestParam("num")int num, @RequestParam("boardnum")int boardnum,
			HttpServletRequest request) {
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("num", num);
		rs.deleteReply(paramMap);
		
		return "redirect:/boardViewWithoutCount?num=" + boardnum;
	}
	
	
}
