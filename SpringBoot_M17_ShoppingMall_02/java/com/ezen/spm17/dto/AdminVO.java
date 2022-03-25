package com.ezen.spm17.dto;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import lombok.Data;

@Data
public class AdminVO {
	@NotNull(message="subject none")
	@NotEmpty(message="subject none")
	private String id;
	@NotNull(message="subject none")
	@NotEmpty(message="subject none")
	private String pwd;
	private String name;
	private String phone;
	
}
