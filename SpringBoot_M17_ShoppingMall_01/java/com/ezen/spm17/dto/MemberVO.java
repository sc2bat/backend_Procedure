package com.ezen.spm17.dto;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import lombok.Data;

@Data
public class MemberVO {
	@NotNull(message="userid none")
	@NotEmpty(message="userid none")
	private String userid;
	@NotNull(message="pwd none")
	@NotEmpty(message="pwd none")
	private String pwd;
	@NotNull(message="name none")
	@NotEmpty(message="name none")
	private String name;
	@NotNull(message="email none")
	@NotEmpty(message="email none")
	private String email;
	@NotNull(message="phone none")
	@NotEmpty(message="phone none")
	private String phone;
	private String admin;
	private String zip_num;
	private String address;
	private String address2;
	private String useyn;
	private String indate;
}
