package com.ezen.spg16.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ezen.spg16.dao.IBoardDao;

@Service
public class BoardService {
	@Autowired
	IBoardDao bdao;

	public void selectBoard(HashMap<String, Object> paramMap) {
		bdao.selectBoard(paramMap);
	}

	public void getAllCount(HashMap<String, Object> paramMap) {
		bdao.getAllCount(paramMap);
	}

	public void boardView(HashMap<String, Object> paramMap) {
		bdao.plusReadCount(paramMap);
		
//		bdao.getBoard(paramMap);
//		bdao.getReply(paramMap);
		
		bdao.boardView(paramMap);
	}

	public void boardViewWithoutCount(HashMap<String, Object> paramMap) {
		bdao.boardView(paramMap);
	}

	public void getBoardOne(HashMap<String, Object> paramMap) {
		bdao.getBoardOne(paramMap);
	}

	
	
}
