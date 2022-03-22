package com.ezen.spg16.dto;

import java.sql.Timestamp;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import lombok.Data;

@Data
public class BoardVO {

	private int num;
	private String userid;
	@NotNull(message="pass null")
	@NotEmpty(message="pass 를 입력하세요")
	private String pass;
	private String email;
	@NotNull(message="title null")
	@NotEmpty(message="title 를 입력하세요")
	private String title;
	@NotNull(message="board content null")
	@NotEmpty(message="board content 를 입력하세요")
	private String content;
	private int readcount;
	private Timestamp writedate;
	private int replycnt;
	private String imgfilename;
}
