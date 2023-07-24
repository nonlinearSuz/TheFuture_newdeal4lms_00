<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>학생관리</title>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">
	// 페이징 설정
	var pageSize = 10; // 화면에 뿌릴 데이터 수 
	var pageBlockSize = 5; // 블럭으로 잡히는 페이징처리 수
	var filter = null;
	
	/** OnLoad event */
	$(function() {
		// 버튼 이벤트 등록
		fRegisterButtonClickEvent();

		fn_studentlist();

		// 날짜 조회 잘못입력했을 때
		$("#endDate").change(function() {
			if ($("#endDate").val() < $("#startDate").val()) {
				alert("날짜를 잘못 입력하셨습니다.");
				$("#endDate").val(''); // endDate 초기화
			}
		});
		// 수정하기
		$("#startDate").change(
				function() {
					if ($("#startDate").val() > $("#endDate").val()
							&& $("#endDate").val() != "") {
						alert("날짜를 잘못 입력하셨습니다.");
						$("#startDate").val(''); // startDate 초기화
					}
				});

	});

	/** 버튼 이벤트 등록 */

	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');
			console.log("btnId : " + btnId);
			switch (btnId) {
			case 'btnSearch':
				filter=null;
				fn_studentlist();
				break;
			case 'btnSave':
				fn_save();
				break;
			case 'btnDelete':
				$("#action").val("D");
				fn_save();
				break;
			case 'btnDeleteFile':
				$("#action").val("D");
				fn_savefile();
				break;
			case 'btnSaveFile':
				fn_savefile();
				break;
			case 'btnpopClose' :
			case 'btnClose':
			case 'btnCloseFile':
				gfCloseModal();
				break;
			case 'btnApprovalSearch':
				filter = "approval";
				fn_studentlist();
				break;
			case 'btnUnapprovalSearch':
				filter = "unapproval";
				fn_studentlist();
				break;
			case 'btnView':
				var startDate = $('#startDate').val().split("-").join("");
			    var endDate = $('#endDate').val().split("-").join("");
			    
				filter=null;
				console.log("Start value:", startDate);
				console.log("End value:", endDate);
				
				var dateRange = {
						  startDate: startDate,
						  endDate: endDate
						};
				
				fn_studentlist("", dateRange);

				//fn_studentlist();
				break;
			case 'btnQuit':
			}
		});
	}

	// 회원정보(비고) 수정
	function fn_userEtc(loginID, userEtc) {
		console.log("loginID : " + loginID);
		console.log("userEtc : " + userEtc);
		 if (confirm("저장하시겠습니까?") == true) {
				var param = {
						loginID : loginID
						,userEtc : userEtc
	            } ;
	             var listcollabck = function(returnvalue) {
	                  /* fn_teacherlist(); */
	                  alert("저장되었습니다.");
	            };
	             callAjax("/admstd/userEtc.do", "post", "text", false, param, listcollabck) ;
	        } else {
	            return false;
	        }	
	}
	
	// 승인 버튼
	function fn_approval(loginID) {
		 if (confirm("승인여부를 변경하시겠습니까?") == true) {
				var param = {
						loginID : loginID
	            } ;
	             var listcollabck = function(returnvalue) {
	                  fn_teacherlist();
	                  alert("변경되었습니다.");
	            };
	             callAjax("/admstd/approval.do", "post", "text", false, param, listcollabck) ;
	        } else {
	            return false;
	        }	
	}
	
    // 탈퇴 버튼
	function fn_studentWithdrawal(loginID) {
		 if (confirm("정말 탈퇴처리 하시겠습니까?") == true) {
			var param = {
				loginID : loginID
            } ;
             var listcollabck = function(returnvalue) {
                  fn_studentlist();
                  alert("탈퇴가 완료되었습니다.");
            };
             callAjax("/admstd/studentWithdrawal.do", "post", "text", false, param, listcollabck) ;
        } else {
            return false;
        }
   }
    
	function fn_studentlist(pagenum, obj) {
		// 기본값 설정
		pagenum = pagenum || 1;
		
		//var array = [value];
		var param = {
	       searchKey : $("#searchKey").val()
		  , 	sname : $("#sname").val() 
		  , pageSize : pageSize
		  , pageBlockSize : pageBlockSize
		  , pagenum : pagenum
		  , value : filter
		} 
		
		// obj 가 null 이면 "" 공백으로 전환, 그렇지 않은 경우 obj의 속성을 param에 추가
		if(obj == null) { 
			obj = "";
		} else {
			var keys = Object.keys(obj);
			for(i = 0; i < keys.length; i++) {
				param[keys[i]] = obj[keys[i]];
			};
		}
		
		// 결과 처리 콜백 함수
			var listcollabck = function(returnvalue) {
			console.log("확인 : " + returnvalue);
 			$("#liststudent").empty().append(returnvalue);
			
 			var  totalcnt = $("#totalcnt").val();
			console.log("totalcnt : " + totalcnt);
			
			var paginationHtml = getPaginationHtml(pagenum, totalcnt, pageSize, pageBlockSize, 'fn_studentlist');
			console.log("paginationHtml : " + paginationHtml);
			
			$("#studentPagination").empty().append( paginationHtml );
			$("#pageno").val(pagenum); 
		}
		callAjax("/admstd/studentlist.do", "post", "text", false, param, listcollabck) ;
	}
	
	function fn_openpopup() {
		
		popupinit();
		
		//모달 팝업
		gfModalPop("layer1");
	}
	
	function popupinit(object) {
		console.log("확인 : " + object);
		console.log("확인 : " + object.keys(object));
		
		if(object == "" || object == null || object == undefined) {
			
		} else {
			$('#student_id').text(object.loginID);
			$("#student_name").text(object.name);
			$("#student_hp").text(object.user_hp);
			$("#student_email").text(object.user_email);
			$("#student_birth").text(object.user_birth);
			$("#student_gender").text(object.user_gender);
			$("#student_address").text(object.user_addr);
			$("#address_detail").text(object.addr_detail);
			
	         $("#lec_no").text(object.lec_no);   
	         $("#lec_name").text(object.lec_name);   
	         
	         var lec_start = new Date(object.lec_start);
	         lec_start.setHours(0, 0, 0, 0);       // 시간을 00:00:00으로 설정

	         var lec_end = new Date(object.lec_end);
	         lec_end.setHours(0, 0, 0, 0);       // 시간을 00:00:00으로 설정
	         
	         var lec_period = object.lec_start + "~" + object.lec_end;
	         $("#lec_period").text(lec_period);   
	         
	         var currentDate = new Date();
	         currentDate.setHours(0, 0, 0, 0);    // 시간을 00:00:00으로 설정   
	         var status = "";      // 진행상태

	         if (lec_start <= currentDate &&  lec_end >= currentDate) {
	            status = "진행중";
	         } else if(lec_start > currentDate)    {
	            status = "예정";
	         } else {
	            status = "종료"; 
	         }
	         console.log("status:", status);
	         $("#status").text(status);
		
		} 

	}
	
	
	function fn_selectone(loginID) {
					//fn_selectone 함수가 loginID라는 매개변수를 받는다
		 $("#student_id").val(loginID)
			//HTML 문서에서 student_id라는 ID를 가진 요소의 값을 loginID로 설정 
		var param = {
			 loginID: loginID
			 //'param' 객체는 'loginID'를 프로퍼티로 가지고 있다
		}
		
			//seleconcallback은 콜백함수로 returndata라는 매개변수를 받는다
		var selectoncallback = function(returndata) {			
			console.log(returndata);
			//콘솔에 출력
			
			$("#layer1").empty().append(returndata);
			//layer1 이라는 ID를 가진 요소의 내용을 비우고 'returndata'를 해당 요소에 추가
			
			// 모달 팝업
			gfModalPop("#layer1");
			//layer1을 모달 팝업으로 띄우는 함수
			
		}
		callAjax("/admstd/studentselectone.do", "post", "text", false, param, selectoncallback) ;
	}
	
	
</script>

</head>
<body>
	<!-- ///////////////////// html 페이지  ///////////////////////////// -->
	<form id="myForm" action="" method="">
		<input type="hidden" id="action" name="action" /> <input
			type="hidden" id="notice_no" name="notice_no" /> <input
			type="hidden" id="pageno" name="pageno" /> <input type="hidden"
			id="student_user" name="loginID" value="">

		<!-- 모달 배경 -->
		<div id="mask"></div>

		<div id="wrap_area">

			<h2 class="hidden">header 영역</h2>
			<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

			<h2 class="hidden">컨텐츠 영역</h2>
			<div id="container">
				<ul>
					<li class="lnb">
						<!-- lnb 영역 --> <jsp:include
							page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
					</li>
					<li class="contents">
						<!-- contents -->
						<h3 class="hidden">contents 영역</h3> <!-- content -->
						<div class="content">

							<p class="Location">
								<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
								<span class="btn_nav bold">행정관리</span> 
								<span class="btn_nav bold">학생 관리</span> 
								<a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
							</p>

							<p class="conTitle">
								<span>학생 목록</span> <span class="fr">
								 <select  id="searchKey" name="searchKey" style="width: 150px;">
									<option value="">전체</option>
									<option value="name">학생명</option>
									<option value="loginID">ID</option>
								</select> 
								<input type="text" style="width: 300px; height: 25px;"
									id="sname" name="sname"> <a href=""
									class="btnType blue" id="btnSearch" name="btn">
									<span>검 색</span></a>
								</span>
							</p>



							<a href="" class="btnType blue" id="btnApprovalSearch" name="btn"><span> 수강</span></a> <a href="" class="btnType blue" id="btnUnapprovalSearch"
								name="btn"><span>미수강</span></a> <span
								style="margin-left: 275px;"></span> 가입일 조회 <input type="date"
								id="startDate" th:field="*{start}"
								style="height: 30px; width: 150px;"> ~ <input
								type="date" id="endDate" th:field="*{end}"
								style="height: 30px; width: 150px;"> <span
								style="margin-left: 10px;"></span> <a href=""
								class="btnType blue" id="btnView" name="btn"
								style="margin-bottom: 10px;"><span>조회</span></a>
							<div class="divtStudentList">
								<table class="col">
									<caption>caption</caption>
									<colgroup>
										<col width="30%">
										<col width="20%">
										<col width="20%">
										<col width="20%">
										<col width="10%">
									</colgroup>

									<thead>
										<tr>
											<th scope="col">학생명(ID)</th>
											<th scope="col">휴대전화</th>
											<th scope="col">가입일자</th>
											<th scope="col">수강여부</th>
											<th scope="col">탈퇴</th>
										</tr>
									</thead>
									<tbody id="liststudent"></tbody>
								</table>
							</div>
							<div class="paging_area" id="studentPagination"></div>

						</div> <!--// content -->

						<h3 class="hidden">풋터 영역</h3> <jsp:include
							page="/WEB-INF/view/common/footer.jsp"></jsp:include>
					</li>
				</ul>
			</div>
		</div>
		<div id="layer1" class="layerPop layerType2" style="width: 600px;">
		</div>
	</form>
</body>
</html>