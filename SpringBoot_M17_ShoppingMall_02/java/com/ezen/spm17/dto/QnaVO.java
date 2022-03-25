package com.ezen.spm17.dto;

import java.sql.Timestamp;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import lombok.Data;

@Data
public class QnaVO {
	private int qseq;
	@NotNull(message="subject none")
	@NotEmpty(message="subject none")
	private String subject;
	@NotNull(message="content none")
	@NotEmpty(message="content none")
	private String content;
	private String id;
	private Timestamp indate;
	private String reply;
	private String rep;
}
