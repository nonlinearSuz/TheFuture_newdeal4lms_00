<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>강의 목록</title>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">

	
	/*페이징 관련 변수*/
	 var pageSize = 10;
	 var pageBlockSize= 5 ;
	
	
	/*onload시 실행 함수*/
	$(function(){
		
		fRegisterButtonClickEvent();
		fn_lecPlanList(1,"ing");
	});
	
	/*콘솔*/
	function fn_console(event) {
		console.log('btn clicked!');
	}
	
	
	
	/*버튼 이벤트 등록*/
	function fRegisterButtonClickEvent(){
		$('a[name=btn]').click(function(e){
			e.preventDefault();
			
			var btnId = $(this).attr('id');
			
			 switch(btnId){
			 case 'btnUpdate' :
				 	$("#action").val("U");	
					fn_save();
				/* 	alert("update!"); */
					break;
				case 'btnDelete' :
					$("#action").val("D");	
					alert("delete!");
					fn_save();
					break;	
				case 'btnClose' :
					gfCloseModal();
					break;	
				case 'btnSearch' :
					fn_lecPlanList();
					break;		
					
			} 
			
		});
	}
	
	
	
	
function fn_lecPlanListclick(lecStatus)	{
		
	if(lecStatus == "ing" ){ //ing 진행중 강의 
		$("#lecStatus").val("ing");
	}else if(lecStatus == "expected" ){ //expected - 진행 예정 강의 
		$("#lecStatus").val("expected");
	}else{ // end - 종료 강의
		$("#lecStatus").val("end");
	}	
		
	fn_lecPlanList();	
}
	
	/*[관리자]하나 선택*/
	function fn_selectOne(lec_no){
		
		var param = {
				 lec_no : lec_no
				
		}
		
		var selectOneCallBack = function(returndata){
			console.log(JSON.stringify(returndata));
			
		 	 popupinit(returndata.lectureDtInfor);  
		
		// 모달 팝업
		gfModalPop("#lecDtModal");
		
		
		}
		callAjax("/suplcd/lectureSelectOne.do","post","json",false,param,selectOneCallBack);	
		
	}
	
	
	/*[관리자]팝업창 (Insert & Update)*/
	 function popupinit(object) {
			console.log("hi!")	;
		
		
			if(object == "" || object == null || object == undefined) {
				$("#lec_name").val("");	
				$("#test_start").val("");
				$("#test_no").val("");
				$("#lec_start").val("");
				$("#lec_end").val("");
				$("#lec_starttime").val("");
				$("#lec_endtime").val("");
				$("#name").val("");
				$("#rm_name").val("");
				$("#user_email").val("");
				$("#user_hp").val("");
				$("#lec_goal").val("");
				$("#lec_contents").val("");
				$("#max_no").val("");
				
				
				$("#previewdiv").empty();
				
				
				$("#btnDelete").hide();
				 
				$("#action").val("I");	
				
			} else {
				/* console.log("값이 있음."); */
				$("#lec_name").val(object.lec_name);	
				$("#test_start").val(object.test_start);
				$("#test_no").val(object.test_no);
				$("#lec_start").val(object.lec_start);
				$("#lec_end").val(object.lec_end);
				$("#lec_starttime").val(object.lec_starttime);
				$("#lec_endtime").val(object.lec_endtime);
				$("#name").val(object.name);
				$("#rm_name").val(object.rm_name);
				$("#user_email").val(object.user_email);
				$("#user_hp").val(object.user_hp);
				$("#lec_goal").val(object.lec_goal);
				$("#lec_contents").val(object.lec_contents);
				$("#max_no").val(object.max_no);
				$("#lec_no").val(object.lec_no);  //선택한 번호 히든 태그에서 받아와서 백업 받는것![★]
				
		
				$("#upfile").val("");
				
				
				var inserthtml = "<a href='javascript:fn_filedownload()'>";
				
				if(object.file_name == "" || object.file_name == null || object.file_name == undefined) {
					inserthtml += "";
				} else {
					var selfile = object.file_name;
				    var selfilearr = selfile.split(".");
				    var lastindex = selfilearr.length - 1;
				    if(selfilearr[lastindex].toLowerCase() == "jpg" || selfilearr[lastindex].toLowerCase() == "gif" || selfilearr[lastindex].toLowerCase() == "jpge" || selfilearr[lastindex].toLowerCase() == "png") {
				    	  inserthtml += "<img src='" + object.file_logic_path + "' style='width:100px; height:80px' />";
				    } else {
				    	  inserthtml += object.file_name;
				    }				
				} 
				

				inserthtml += "</a>"
				
				$("#previewdiv").empty().append(inserthtml);
				
				
				$("#btnDelete").show();
				
				$("#action").val("U");	
			}
		}
	
	 /*강의 상세계획서 저장*/
	 function fn_save() {
			
			if ( ! fn_Validate() ) {
				return;
			}
			
			var frm = document.getElementById("lecPlanForm");
			frm.enctype = 'multipart/form-data';
			var fileData = new FormData(frm);
			console.log(fileData);
			
			
		/* 	console.log("hellllooooooooooooooo!"); */
			var savecallback = function(reval) {
				console.log( JSON.stringify(reval) );
				
				if(reval.returnCheckVal > 0) {
					alert("저장 되었습니다.");
					gfCloseModal();
					
					if($("#action").val() == "U") {
					/* 	console.log("hi! update!"); */
						fn_lecPlanList($("#pageno").val());
					} else {
						console.log("hi! else delete");
						fn_lecPlanList();
					}
				}  else {
					alert("오류가 발생 되었습니다.");				
				}
			}
			

			 callAjaxFileUploadSetFormData("/suplcd/lectureDtSave.do", "post", "json", true, fileData , savecallback) ; 
		}
	
	
	 /*저장 파일 미리보기*/
	 	function preview(event){
		
			var image = event.target;
			console.log("------ image------ ",image);
			 
			if(image.files[0]){
				//alert(window.URL.createObjectURL(image.files[0]));
				
				var selfile = image.files[0].name;
				/* console.log(selfile); */
		 		var selfilearr = selfile.split(".");
				insertHTML = "";
				var lastindex = selfilearr.length - 1;


				if(selfilearr[lastindex].toLowerCase() =="jpg" || selfilearr[lastindex].toLowerCase() =="png" || selfilearr[lastindex].toLowerCase() =="jpeg" || selfilearr[lastindex].toLowerCase()=="gif"){
					insertHTML =  "<img src='" + window.URL.createObjectURL(image.files[0]) + "' style='width:80px; height:80px' />";
					console.log(insertHTML);
				} else {
					insertHTML = selfile;
					console.log(insertHTML);
				}
				  alert(window.URL.createObjectURL(image.files[0]));
				$("#previewdiv").empty().append(insertHTML);
			
			}
		} 
	 
	 	function fn_filedownload() {
	 		
			alert("다운로드");
			
			var params = "";
			params += "<input type='hidden' name='lec_no' id='lec_no' value='"+ $("#lec_no").val() +"' />";
			
			jQuery("<form action='/suplcd/downloadLectureFile.do' method='post'>"+params+"</form>").appendTo('body').submit().remove();
	 	}
	 
	 
	 /*강의 계획서 유효성 체크(빈값 확인)*/
		function fn_Validate() {

			var chk = checkNotEmpty(
					[
							[ "lec_goal", "수업 목표를 입력해주세요." ]
						,	[ "lec_contents", "강의 내용을 입력해 주세요" ]

					]
			);

			if (!chk) {
				return;
			}

			return true;
		} 
		
	 
	 
	/** 강의 목록 조회 */	
	function fn_lecPlanList(pagenum){
		/* console.log("hi2!") */
		
		var pagenum = pagenum || 1; 
		lecStatus=$("#lecStatus").val();
		
		/* console.log("pagenum : "+pagenum);
		console.log("현재 클릭된 버튼 : "+lecStatus);
		 */
		var param = {
			
			searchKey : $("#searchKey").val()
			,sname : $("#sname").val()	
			, pageSize:pageSize
			,pageBlockSize : pageBlockSize
		    ,pagenum : pagenum 
		    ,lecStatus :$("#lecStatus").val()
		}
		
		var planListCallback = function(returnvalue){
			fn_lecPlan_rs(returnvalue,pagenum);
			console.log();
		}
		
		callAjax("/suplcd/lecturePlanList.do","post","text",false,param,planListCallback);
		
	}
	
	/** 강의 목록 조회 콜백 함수 */		
	function fn_lecPlan_rs(data,pagenum){
	/* 	console.log(data); */
	
		//기존 목록 삭제
		$("#lectureTuples").empty();
		
		//신규 목록 생성
		$("#lectureTuples").append(data);
		
		//총 갯수
		var totalcnt =  $("#totalcnt").val();
		console.log("totalcnt: "+totalcnt);
		console.log("pagenum: "+pagenum);
		console.log("pageSize: "+pageSize);
		console.log("pageBlockSize: "+pageBlockSize);
		
		
		var paginationHtml = getPaginationHtml( pagenum, totalcnt, pageSize, pageBlockSize, 'fn_lecPlanList');
	 	console.log("paginationHtml: "+paginationHtml); 
		
		$("#lecPlanPagination").empty().append( paginationHtml );
		
	 	$("#pageno").val(pagenum); 

	}
	
	/*[관리자]강의 승인 */
	 function fn_lecAprov(lec_no,lecOpen_yn){
		console.log("승인 하고자 하는 강의 번호 : "+"");
		
		var param = {
				lec_no : lec_no
				, lecOpen_yn: lecOpen_yn
		}
		console.log(JSON.stringify(param),param);
		
		var rsCallBack = function(data){
			
			fn_lecPlanList($("#pageno").val());
			alert("승인상태 변경 완료.");
		};
	
		callAjax("/suplcd/lecApprove.do","post","json","true",param, rsCallBack); 
	  }
	
	/*승인 상태 변경 조건 확인 함수 */
	 function fn_approveCondition(lec_no,lecOpen_yn){
		var lec_no = lec_no;
		var lecOpen_yn = lecOpen_yn;
		
		 var param = {
					lec_no : lec_no,
					lecOpen_yn : lecOpen_yn
			}
		 var apprveCondCallback = function(data){
				
				console.log(data.returnvalue)
				console.log(data)
				if(data.returnvalue == -2){
					alert("시작기간이 지나서 상태변경 불가합니다");
				
					
				}else if(data.returnvalue >=1){
					//fn_lecAprov(lec_no,lecOpen_yn);
					fn_lecPlanList($("#pageno").val());
					alert("승인상태 변경 완료.");
					
					
				}else{
					console
					alert("오류가 발생했습니다.");
				
				}
			};
		
			callAjax("/suplcd/approveCondition.do","post","json","true",param, apprveCondCallback); 
	 }
	
</script>
</head>
<body>
	<!-- 관리자일때 -->
	<c:choose>
		<c:when test="${sessionScope.userType =='M'}">
			<form id="lecPlanForm" action="" method="">
				<input type="hidden" id="action" name="action" />
				<input type="hidden" id="lec_no" name="lec_no"/>
				<input type="hidden" id="pageno"  name="pageno"  /> 
				<input type="hidden" id="lecStatus"  name="lecStatus"  /> 
				
				<div id="mask"></div>
				
				<div id="wrap_area">
				
					<h2 class="hidden">header 영역</h2>
					<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>
	
					<h2 class="hidden">컨텐츠 영역</h2>
					<div id="container">
						<ul>
							<li class="lnb">
								<!-- lnb 영역 --> 
								<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> 
								<!--// lnb 영역 -->
							</li>
							<li class="contents">
								<!-- contents -->
								<h3 class="hidden">contents 영역</h3> <!-- content -->
								<div class="content">
			
									<p class="Location">
										<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
											class="btn_nav bold">학습관리</span> <span class="btn_nav bold">강의 상세 계획서
											</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">강의 상세 계획 관리</a>
									</p>
			
									<p class="conTitle">
										<span>강의 계획서 관리</span> <span class="fr"> 
										 <select id="searchKey" name="searchKey" style="width: 150px;" >
										        <option value="">전체</option>
										        <option value="subject" >과목</option>
												<option value="prof_nm" >강사명</option>
										</select> 
										<input type="text" style="width: 300px; height: 25px;" id="sname" name="sname">
										<a href="" class="btnType blue" id="btnSearch" name="btn"><span>검  색</span></a>
										</span>
									</p>
									
									
									<div class="" id="" style="margin-bottom:10px">
										<a onclick="javascript:fn_lecPlanListclick('ing');" class="btnType blue" id="ing" name="btn" style="cursor:pointer"><span>진행중 강의</span></a>
										<a onclick="javascript:fn_lecPlanListclick('expected');"  class="btnType blue" id="expected" name="btn" style="cursor:pointer"><span>진행 예정 강의</span></a>
										<a onclick="javascript:fn_lecPlanListclick('end');" class="btnType blue" id="end" name="btn" style="cursor:pointer"><span>종료 강의</span></a>
									</div>
									
									<div class="lectureList">
										<table class="col">
											<caption>caption</caption>
											<colgroup>
												<col width="30%">
												<col width="15%">
												<col width="25%">
												<col width="10%">
												<col width="10%">
												<col width="10%">
											</colgroup>
				
											<thead>
												<tr>
													<th scope="col">강의명</th> 
													<th scope="col">강사명</th> 
													<th scope="col">강의기간</th> 
													<th scope="col">수강 인원</th> 
													<th scope="col">승인여부</th>
													<th scope="col" >승인</th> 
												</tr>
											</thead>
											<tbody id="lectureTuples"></tbody>
										</table>
									</div>
				
									<div class="paging_area"  id="lecPlanPagination"> </div>
								 </div> <!-- //content -->	
								 
								<h3 class="hidden">풋터 영역</h3>
          						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
							</li>
						</ul>	
					</div>	
				</div>
				
			<!--  강의 상세계획서 모달 팝업 -->
			 <div id="lecDtModal" class="layerPop layerType2" style="width:800px;">
				<dl>
					<dt>
						<strong>강의 계획서 </strong>
					</dt>
					<dd class="content">
		
						<!-- s : 여기에 내용입력 -->
		
						<table class="row"  style="margin-top:30px;">
							<caption>caption</caption>
							<colgroup>
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">강의명 <span class="font_red">*</span></th>
									<td colspan="14"><input type="text" class="inputTxt p100" name="lec_name" id="lec_name" placeholder="강의명을 입력하세요."/></td>
								</tr>
								<tr>
									<th scope="row">시험 일자<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="test_start" id="test_start"/>
									</td>
									<th scope="row">시험 번호<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="test_no" id="test_no" />
									</td>
								</tr>
								<tr>
									<th scope="row">시작 일자<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="lec_start" id="lec_start"/>
									</td>
									<th scope="row">종료 일자<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="lec_end" id="lec_end"/>
									</td>
								</tr>
								<tr>
									<th scope="row">시작 시간<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="lec_start" id="lec_starttime"/>
									</td>
									<th scope="row">종료 시간<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="lec_end" id="lec_endtime"/>
									</td>
								</tr>
								 <tr>
									<th scope="row">강사명<span class="font_red">*</span></th>
									<td colspan="5">
										<input type="text" class="inputTxt p100"  name="name" id="name" placeholder=""/>
									</td>
									<th scope="row">강의실<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="rm_name" id="rm_name" placeholder=""/>
									</td>
								</tr>
								<tr>
									<th scope="row">이메일<span class="font_red">*</span></th>
									<td colspan="5">
										<input type="text" class="inputTxt p100"  name="user_email" id="user_email" placeholder="이메일을 입력하세요. "/>
									</td>
									<th scope="row">연락처<span class="font_red">*</span></th>
									<td colspan="8">
										<input type="text" class="inputTxt p100"  name="user_hp" id="user_hp" placeholder="전화번호를 입력하세요. "/>
									</td>
								</tr>
								<tr>
									<th scope="row">수업목표<span class="font_red">*</span></th>
									<td colspan="14">
									   <textarea id="lec_goal" name="lec_goal" cols="15" rows="3">
									   </textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">강의 내용 <span class="font_red">*</span></th>
									<td colspan="14" style="overflow:auto">
									 	<textarea id="lec_contents" name="lec_contents" cols="15" rows="3">
									   	</textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">첨부파일 <span class="font_red"></span></th>
									<td colspan="6">
									    <input  type="file" id="upfile"  name="upfile"  onchange="javascript:preview(event)" onclick="javascript:fn_console();"/>
									</td>
									 <td colspan="8">
									      <div id="previewdiv" >미리보기</div>
									</td> 
								</tr>
							</tbody>
						</table>
						<div class="" style="padding:30px 0px 5px 0px; display:flex; justify-content:center;">
							<a onclick="" style="margin-right:10px;  href="" class="btnType blue" id="btnUpdate" name="btn"><span>수정</span></a>
							<a onclick="" href="" class="btnType blue" id="btnClose" name="btn"><span>닫기</span></a>  
						</div>
					</dd>
				</dl>
				<a href="" class="closePop"><span class="hidden">닫기</span></a>
			</div> 
		<!--  강의 상세계획서 모달 팝업 --> 
				
				
				
			</form>
		</c:when>
	</c:choose>
	
	
	<!-- 강사 일때 -->
	<c:choose>
		<c:when test="${sessionScope.userType =='T'}">
			<form id="lecPlanForm"" action="" method="">
				<input type="hidden" id="action" name="action" />
				<input type="hidden" id="lec_no" name="lec_no"/>
				<input type="hidden" id="pageno"  name="pageno"  /> 
				<input type="hidden" id="lecStatus"  name="lecStatus"  /> 
				
				<div id="mask"></div>
				
				<div id="wrap_area">
				
					<h2 class="hidden">header 영역</h2>
					<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>
	
					<h2 class="hidden">컨텐츠 영역</h2>
					<div id="container">
						<ul>
							<li class="lnb">
								<!-- lnb 영역 --> 
								<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> 
								<!--// lnb 영역 -->
							</li>
							<li class="contents">
								<!-- contents -->
								<h3 class="hidden">contents 영역</h3> <!-- content -->
								<div class="content">
			
									<p class="Location">
										<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
											class="btn_nav bold">운영</span> <span class="btn_nav bold">학습관리
											관리</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">강의 상세 계획 관리</a>
									</p>
			
									<p class="conTitle">
										<span>강의 계획서 관리</span> <span class="fr"> 
										 <select id="searchKey" name="searchKey" style="width: 150px;" >
										 		 <option value="subject" >과목명</option>
										</select> 
										<input type="text" style="width: 300px; height: 25px;" id="sname" name="sname">
										<a href="" class="btnType blue" id="btnSearch" name="btn"><span>검  색</span></a>
										</span>
									</p>
									
									
									<div class="" id="" style="margin-bottom:10px">
										<a onclick="javascript:fn_lecPlanListclick('ing');" class="btnType blue" id="ing" name="btn"><span>진행중 강의</span></a>
										<a onclick="javascript:fn_lecPlanListclick('expected');"  class="btnType blue" id="expected" name="btn"><span>진행 예정 강의</span></a>
										<a onclick="javascript:fn_lecPlanListclick('end');" class="btnType blue" id="end" name="btn"><span>종료 강의</span></a>
									</div>
									
									<div class="lectureList">
										<table class="col">
											<caption>caption</caption>
											<colgroup>
												<col width="25%">
												<col width="10%">
												<col width="25%">
												<col width="10%">
												<col width="20%">
												
											</colgroup>
				
											<thead>
												<tr>
													<th scope="col">강의명</th> 
													<th scope="col">강사명</th> 
													<th scope="col">강의기간</th> 
													<th scope="col">수강 인원</th> 
													<th scope="col">승인여부</th> 
												</tr>
											</thead>
											<tbody id="lectureTuples"></tbody>
										</table>
									</div>
				
									<div class="paging_area"  id="lecPlanPagination"> </div>
								 </div> <!-- //content -->	
								 
								<h3 class="hidden">풋터 영역</h3>
          						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
							</li>
						</ul>	
					</div>	
				</div>
				
				<!--  강의 상세계획서 모달 팝업 -->
			 <div id="lecDtModal" class="layerPop layerType2" style="width:800px;">
				<dl>
					<dt>
						<strong>강의 계획서 </strong>
					</dt>
					<dd class="content">
		
						<!-- s : 여기에 내용입력 -->
		
						<table class="row"  style="margin-top:30px;">
							<caption>caption</caption>
							<colgroup>
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">강의명 <span class="font_red">*</span></th>
									<td colspan="14"><input type="text" class="inputTxt p100" name="lec_name" id="lec_name" placeholder="강의명을 입력하세요."/></td>
								</tr>
								<tr>
									<th scope="row">시험 일자<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="test_start" id="test_start"/>
									</td>
									<th scope="row">시험 번호<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="test_no" id="test_no" />
									</td>
								</tr>
								<tr>
									<th scope="row">시작 일자<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="lec_start" id="lec_start"/>
									</td>
									<th scope="row">종료 일자<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="lec_end" id="lec_end"/>
									</td>
								</tr>
								<tr>
									<th scope="row">시작 시간<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="lec_start" id="lec_starttime"/>
									</td>
									<th scope="row">종료 시간<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="lec_end" id="lec_endtime"/>
									</td>
								</tr>
								 <tr>
									<th scope="row">강사명<span class="font_red">*</span></th>
									<td colspan="5">
									   <!--  <input type="text" class="inputTxt p100"  name="lec_prof" id="lec_prof" placeholder="숫자만 입력하세요."/> -->
										<input type="text" class="inputTxt p100"  name="name" id="name" placeholder=""/>
									</td>
									<th scope="row">강의실<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="rm_name" id="rm_name" placeholder=""/>
									</td>
								</tr>
								<tr>
									<th scope="row">이메일<span class="font_red">*</span></th>
									<td colspan="5">
										<input type="text" class="inputTxt p100"  name="user_email" id="user_email" placeholder="이메일을 입력하세요. "/>
									</td>
									<th scope="row">연락처<span class="font_red">*</span></th>
									<td colspan="8">
										<input type="text" class="inputTxt p100"  name="user_hp" id="user_hp" placeholder="전화번호를 입력하세요. "/>
									</td>
								</tr>
								<tr>
									<th scope="row">수업목표<span class="font_red">*</span></th>
									<td colspan="14">
									   <textarea id="lec_goal" name="lec_goal" cols="15" rows="3">
									   </textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">강의 내용 <span class="font_red">*</span></th>
									<td colspan="14" style="overflow:auto">
									 	<textarea id="lec_contents" name="lec_contents" cols="15" rows="3">
									   	</textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">첨부파일 <span class="font_red"></span></th>
									<td colspan="6">
									    <input  type="file" id="upfile"  name="upfile"  onchange="javascript:preview(event)" />
									</td>
									<td colspan="8">
									      <div id="previewdiv" >미리보기</div>
									</td> 
								</tr>
							</tbody>
						</table>
						<div class="" style="padding:30px 0px 5px 0px; display:flex; justify-content:center;">
							<a onclick="javascript:fn_console();" style="margin-right:10px;  href="" class="btnType blue" id="btnUpdate" name="btn"><span>수정</span></a>
							<a href="" class="btnType blue" id="btnClose" name="btn"><span>닫기</span></a>  
						</div>
					</dd>
				</dl>
				<a href="" class="closePop"><span class="hidden">닫기</span></a>
			</div> 
		<!--  강의 상세계획서 모달 팝업 --> 
				
				
			</form>
		</c:when>
	</c:choose>
	

</body> 