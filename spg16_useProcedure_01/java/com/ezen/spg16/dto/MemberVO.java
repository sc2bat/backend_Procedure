package com.ezen.spg16.dto;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import lombok.Data;

@Data
public class MemberVO {
	@NotNull(message="userid null")
	@NotEmpty(message="userid 를 입력하세요")
	private String userid;
	@NotNull(message="pwd null")
	@NotEmpty(message="pwd 를 입력하세요")
	private String pwd;
	@NotNull(message="name null")
	@NotEmpty(message="name 를 입력하세요")
	private String name;
	@NotNull(message="email null")
	@NotEmpty(message="email 를 입력하세요")
	private String email;
	@NotNull(message="phone null")
	@NotEmpty(message="phone 를 입력하세요")
	private String phone;
}
