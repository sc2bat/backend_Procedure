function idCheck(){
	if(document.frm.userid.value==''){
		alert('아이디를 입력하여 주십시오.');
		document.frm.userid.focus();
		return;
	}
	
	var userid = document.frm.userid.value;
	var opt = "toolbar = no, menubar=no, resizable=no, width=450, height=200";
	window.open("idcheck?userid=" + userid, "userid check", opt);

}

function idok(userid){
	opener.frm.userid.value = userid;
	opener.frm.re_id.value = userid;
	self.close();
}

function selectImg(){
	var opt = "toolbar = no, menubar=no, resizable=no, width=450, height=200";
	window.open("selectImg", "selectImg", opt);
}

function selectedImage(){
	document.frm.submit();
}


function reply_check(){
	var f = document.frm2;
	if(f.content.value.length==0){
		alert('댓글을 작성하세요');
		f.content.focus();
		return false;
	}else {
		return true;
	}
}


function open_win(url, name){
	window.open(url, name, "toolbar=no, menubar=no, scrollbars=no, resizable=no, width=500, height=230");
}
