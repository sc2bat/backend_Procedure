package com.ezen.spg16.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.ezen.spg16.dto.BoardVO;
import com.ezen.spg16.dto.Paging;
import com.ezen.spg16.service.BoardService;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@Controller
public class BoardController {
	@Autowired
	BoardService bs;

	@Autowired
	ServletContext context;	
	
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
			mav.addObject("paging", paging);
			mav.setViewName("board/main");
		}
		return mav;
	}
	
	@RequestMapping("/boardView")
	public ModelAndView boardView(@RequestParam("num")int num) {
		ModelAndView mav = new ModelAndView();
		
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("num", num);
		paramMap.put("ref_cursor1", null); // 게시물내용을 담는 커서
		paramMap.put("ref_cursor2", null); // 댓글내용을 담는 커서
		
		bs.boardView(paramMap);
		
		ArrayList<HashMap<String, Object>> list1 = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor1");
		ArrayList<HashMap<String, Object>> list2 = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor2");
		
		mav.addObject("board", list1.get(0));
		mav.addObject("replyList", list2);
		mav.setViewName("board/boardView");
		return mav;
	}
	
	@RequestMapping("/boardViewWithoutCount")
	public ModelAndView boardViewWithoutCount(@RequestParam("num")int num) {
		ModelAndView mav = new ModelAndView();
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("num", num);
		paramMap.put("ref_cursor1", null); // 게시물내용을 담는 커서
		paramMap.put("ref_cursor2", null); // 댓글내용을 담는 커서
		
		bs.boardViewWithoutCount(paramMap);
		
		ArrayList<HashMap<String, Object>> list1 = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor1");
		ArrayList<HashMap<String, Object>> list2 = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor2");
		
		mav.addObject("board", list1.get(0));
		mav.addObject("replyList", list2);
		mav.setViewName("board/boardView");
		return mav;
	}
	
	@RequestMapping("/boardEditForm")
	public String boardEditForm(@RequestParam("num")int num, Model model) {
		model.addAttribute("num", num);
		return "board/boardCheckPassForm";
	}
	
	@RequestMapping("/boardEdit")
	public String boardEdit(@RequestParam("num")int num, @RequestParam("pass")String pass, Model model) {
		String url = "";
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("num", num);
		paramMap.put("ref_cursor_board", null);
		bs.getBoardOne(paramMap);
		ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor_board");
		HashMap<String, Object> bvo = list.get(0);
		model.addAttribute("num", num);
//		if(!bvo.get("PASS").equals(pass)) {
		if(!list.get(0).get("PASS").equals(pass)) {
			model.addAttribute("message", "pwd wrong");
			url = "board/boardCheckPassForm";
		}else {
			url = "board/boardCheckPass";
		}
		
		return url;
	}
	
	@RequestMapping("/boardUpdateForm")
	public String boardUpdateForm(@RequestParam("num")int num, Model model) {
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("num", num);
		paramMap.put("ref_cursor_board", null);
		bs.getBoardOne(paramMap);
		ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>)paramMap.get("ref_cursor_board");
		HashMap<String, Object> vo = list.get(0);
		
		BoardVO dto = new BoardVO();
//		dto.setNum((Integer)vo.get("NUM"));
		// java.lang.ClassCastException: java.math.BigDecimal cannot be cast to java.lang.Integer
		dto.setNum(Integer.parseInt(String.valueOf(vo.get("NUM"))));
		dto.setUserid((String)vo.get("USERID"));
		dto.setPass((String)vo.get("PASS"));
		dto.setEmail((String)vo.get("EMAIL"));
		dto.setTitle((String)vo.get("TITLE"));
		dto.setContent((String)vo.get("CONTENT"));
		dto.setImgfilename((String)vo.get("IMGFILENAME"));
		
		model.addAttribute("num", num);
		model.addAttribute("dto", dto);
		return "board/boardEditForm";
	}
	
	@RequestMapping(value="/boardUpdate", method=RequestMethod.POST)
	public ModelAndView boardUpdate(@ModelAttribute("dto")@Valid BoardVO boardvo, BindingResult result,
			@RequestParam("oldfilename")String oldfilename) {
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("board/boardEditForm");
		if(result.getFieldError("pass") != null) {
			mav.addObject("message", "pass null");
		}else if(result.getFieldError("title") != null) {
			mav.addObject("message", "title null");
		}else if(result.getFieldError("content") != null) {
			mav.addObject("message", "content null");
		}else {
			if(boardvo.getImgfilename().equals("") || boardvo.getImgfilename() == null) {
				boardvo.setImgfilename(oldfilename);
			}
			bs.updateBoard(boardvo);
			mav.setViewName("redirect:/boardViewWithOutReadCount?num=" + boardvo.getNum());
		}
		mav.setViewName("board/boardEditForm");
		return mav;
	}
		
	

	@RequestMapping("/selectImg")
	public String selectImg() {
		return "board/selectImg";
	}
	
	@RequestMapping(value="/fileUpload", method=RequestMethod.POST)
	public String fileUpload(Model md, HttpServletRequest rq) {
		
		try {
			MultipartRequest mt = new MultipartRequest(
					rq, context.getRealPath("/upload"), 5*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
			//전송된 파일은 업로드 되고, 파일 이름은 모델에 저장합니다
			md.addAttribute("uploadImage", mt.getFilesystemName("uploadImage"));
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "board/completeUpload";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
