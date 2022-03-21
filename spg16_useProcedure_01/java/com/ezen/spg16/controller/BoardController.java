package com.ezen.spg16.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.ezen.spg16.dto.Paging;
import com.ezen.spg16.service.BoardService;

@Controller
public class BoardController {
	@Autowired
	BoardService bs;
	
	@RequestMapping("/main")
	public ModelAndView goMain(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		if(session.getAttribute("loginUser") == null) {
			mav.setViewName("member/loginForm");
		}else {
			int page = 1;
			String PageParam = request.getParameter("page");
			if(PageParam != null) {
				page = Integer.parseInt(PageParam);
				session.setAttribute("page", page);
			}else if(session.getAttribute("page") != null) {
				page = (int)session.getAttribute("page");
			}else {
				session.removeAttribute("page");
			}
			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			
			Paging paging = new Paging();
			paging.setPage(page);
//			int count = bs.getAllCount();
			paramMap.put("cnt", 0);
			bs.getAllCount(paramMap);
			int count = (Integer)paramMap.get("cnt");
			paging.setTotalCount(count);
			paging.paging();
			
			paramMap.put("ref_cursor", null);
			//paramMap.put("paging", paging);
			paramMap.put("startNum", paging.getStartNum());
			paramMap.put("endNum", paging.getEndNum());
			
			bs.selectBoard(paramMap);
			ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor");
			mav.addObject("boardList", list);
			mav.setViewName("board/main");
		}
		return mav;
	}
}
