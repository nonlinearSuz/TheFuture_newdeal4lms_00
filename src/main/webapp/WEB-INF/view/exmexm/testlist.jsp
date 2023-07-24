<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Job Korea</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">

	// 시험등록 페이징 설정
	var pageSizeTest = 5;
	var pageBlockSizeTest = 5;
	
	// 상세등록 페이징 설정
	var pageSizeQ = 5;
	var pageBlockSizeQ = 5;
	
	
	/** OnLoad event */ 
	$(function() {
		
		selectComCombo("lecbyuser","","lecbyusercombo","all",""); 
	
		// 시험 등록 조회
		fn_ListExam();
		
		// 버튼 이벤트 등록
		fRegisterButtonClickEvent();
	});
	

	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch (btnId) {
				case 'btnSaveExam' :
					SaveExam();
					break;
				case 'btnDeleteExam' :
					$("#action").val("D");	
					SaveExam();
					break;
				case 'btnSaveQ' :
					SaveTestDetail();
					break;
				case 'btnDeleteQ' :
					$("#action").val("D");	
					SaveTestDetail();
					break;
				case 'btnSearch':
					board_search();
					break;
				case 'btnCloseExam' :
				case 'btnCloseQ' :
					gfCloseModal();
					break;
			}
		});
	}
	
	
	/** 시험 등록 폼 초기화 */
	function ininExam(object) {

		if( object == "" || object == null || object == undefined) {
			
			$("#test_no").val("");
			$("#test_name").val("");

			$("#btnDeleteExam").hide();
			
			$("#action").val("I");	
			
			
		} else {
			
			$("#test_no").val(object.test_no);
			$("#test_name").val(object.test_name);

			$("#btnDeleteExam").show();	
			
			$("#action").val("U");	
			
			}
		}



	
	/**시험 상세 등록 폼 초기화 */
	function initTestDetail(object) {
		
		var testNo = $("#examtest_no").val();
		var testName = $("#examtest_name").val();
		
		if( object == "" || object == null || object == undefined) {
			
			$("#dt_test_no").val(testNo);
			$("#dt_test_name").val(testName);
			$("#que_no").val("");
			$("#que_content").val("");
			$("#opt_1").val("");
			$("#opt_2").val("");
			$("#opt_3").val("");
			$("#opt_4").val("");
			$("#answer").val("");
			$("#score").val("");

			$("#btnDeleteQ").hide();
			
			$("#dt_test_no").attr("readonly", true);
			$("#dt_test_name").attr("readonly", true);
			$("#que_no").attr("readonly", false);
			
			$("#action").val("I");	
			
		} else {

			$("#dt_test_no").val(object.test_no);
			$("#dt_test_name").val(object.test_name);
			$("#que_no").val(object.que_no);
			$("#que_content").val(object.que_content);
			$("#opt_1").val(object.opt_1);
			$("#opt_2").val(object.opt_2);
			$("#opt_3").val(object.opt_3);
			$("#opt_4").val(object.opt_4);
			$("#answer").val(object.answer);
			$("#score").val(object.score);

			$("#btnDeleteQ").show();
			
			$("#dt_test_no").attr("readonly", true);
			$("#dt_test_name").attr("readonly", true);
			$("#que_no").attr("readonly", false);

			$("#action").val("U");	
		}
	}
	
	
	/** 시험 저장 validation */
	function ValidateExam() {

		var chk = checkNotEmpty(
				[
						[ "test_name", "시험명을 입력해 주세요." ]
				]
		);

		if (!chk) {
			return;
		}

		return true;
	}
	
	
	/** 시험 문제 등록 저장 validation */
	function ValidateTestDetail() {

		var chk = checkNotEmpty(
				[
					    [ "que_content", "문제를 입력해 주세요." ]
					,	[ "opt_1", "보기1을 입력해 주세요" ]
					,	[ "opt_2", "보기2를 입력해 주세요" ]
					,	[ "opt_3", "보기3을 입력해 주세요" ]
					,	[ "opt_4", "보기4를 입력해 주세요" ]
					,	[ "answer", "정답을 입력해 주세요" ]
					,	[ "score", "배점을 입력해 주세요" ]
				]
		);

		if (!chk) {
			return;
		}

		return true;
	}
	
	
	/** 시험 등록 모달 실행 */
	function openModalExam(test_no) {
		
		// 신규 저장
		if (test_no == null || test_no=="") {
			// Tranjection type 설정
			$("#action").val("I");
			
			// 시험 등록 폼 초기화
			ininExam();
			
			// 모달 팝업
			gfModalPop("#layer1");

		// 수정 저장
		} else {
			// Tranjection type 설정
			$("#action").val("U");
			
			// 시험 등록 한건 조회
			SelectExam(test_no);
		}
	}
	
	
	/** 시험 목록 조회 */
	function fn_ListExam(currentPage) {
		
		currentPage = currentPage || 1;
		
		var sname = $('#sname');
		
		
		console.log("currentPage : " + currentPage);
		
		var param = {	
					sname : sname.val()
				,	currentPage : currentPage
				,	pageSize : pageSizeTest
				  , pageBlockSize : pageBlockSizeTest
		}
		
		var resultCallback = function(data) {
			flistGrpCodResult(data, currentPage);
		};
		//Ajax실행 방식
		//callAjax("Url",type,return,async or sync방식,넘겨준거,값,Callback함수 이름)
		callAjax("/exmexm/testlist.do", "post", "text", false, param, resultCallback);
	}
	
	
	
	
	
	/** 시험 등록 조회 콜백 함수 */
	function flistGrpCodResult(data, currentPage) {
		
		//swal(data);
		console.log(data);
		
		// 기존 목록 삭제
		$('#listExam').empty();
		
		// 신규 목록 생성
		$("#listExam").append(data);
		
		// 총 개수 추출
		
		var totalexam = $("#totalexam").val();
		

		
		// 페이지 네비게이션 생성
		
		var paginationHtml = getPaginationHtml(currentPage, totalexam, pageSizeTest, pageBlockSizeTest, 'fn_ListExam');
		console.log("paginationHtml : " + paginationHtml);
		//swal(paginationHtml);
		$("#comnGrpCodPagination").empty().append( paginationHtml );
		
		// 현재 페이지 설정
		$("#currentPageComnGrpCod").val(currentPage);
	}
	
	
	
	
	
	/** 시험 한건 조회 */
	
	function SelectExam(test_no) {
		

		
		var param = {
				test_no : test_no
		}
		
		var selectoncallback = function(returndata) {		
											
			ininExam(returndata.examsearch);
			
			gfModalPop("#layer1");
			
		}
		
		callAjax("/exmexm/examselectone.do", "post", "json", false, param, selectoncallback) ;
		
	}
	
	
	
	
	
	
	
	/** 시험 저장 */
	function SaveExam() {

		
		if ( ! ValidateExam() ) {
			return;
		}
		
		var param = {
				action : $("#action").val(),
				test_no : $("#test_no").val(),
				test_name : $("#test_name").val()
		}
		
		var savecollback = function(reval) {
			console.log( JSON.stringify(reval) );
			
			if(reval.returncval > 0) {
				alert("저장 되었습니다.");
				
				gfCloseModal();
				
				if($("#action").val() == "U") {
					fn_ListExam($("#currentPageComnGrpCod").val());
				} else {
					fn_ListExam();  //현재 목록 조회
				}
			}  else {
				alert("오류가 발생 되었습니다.");				
			}
		}
	
		callAjax("/exmexm/examsave.do", "post", "json", false, $("#myForm").serialize() , savecollback) ;
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/** 시험 문제 등록 모달 실행 */
	function openModalTestDetail(test_no, que_no) {
		
		console.log(test_no,que_no);
		
		
		// 신규 저장
		if (que_no == null || que_no=="") {
		
			if ($("#examtest_no").val() == "") {
					swal("시험명을 선택해 주세요.");
				return;
			}
			
			// Tranjection type 설정
			$("#action").val("I");
			
			// 시험 문제 등록 폼 초기화
			initTestDetail();
			
			// 모달 팝업
			gfModalPop("#layer2");

		// 수정 저장
		} else {
			
			// Tranjection type 설정
			$("#action").val("U");
			
			// 시험 문제 등록 한건 조회
			SelectTestDetail(test_no, que_no);
		}
	}
	
	

	
	
	/** 시험 문제 등록 목록 조회 */
	function fn_ListTestDetail(currentPage, test_no, test_name) {
		
		currentPage = currentPage || 1;
		
		// 시험 등록 정보 설정
		$("#examtest_no").val(test_no);
		$("#examtest_name").val(test_name);
		
		var param = {
					test_no : test_no
				,	currentPage : currentPage
				,	pageSize : pageSizeQ
				  , pageBlockSize : pageBlockSizeQ
		}
		
		var listcollabck = function(returnvalue) {
			
			$('#listTestDetail').empty().append(returnvalue);
			
			var totalque = $("#totalque").val();
			
			var paginationHtml = getPaginationHtml(currentPage, totalque, pageSizeQ, pageBlockSizeQ, 'fn_ListTestDetail', [test_no]);
			$("#comnDtlCodPagination").empty().append( paginationHtml );
			
			// 현재 페이지 설정
			$("#currentPageComnDtlCod").val(currentPage);

		};
		
		callAjax("/exmexm/examdetail.do", "post", "text", false, param, listcollabck);
	}
	


	
	/** 시험 상세 한건 조회 */
	
	function SelectTestDetail(test_no, que_no) {
		
		
		var param = {
				      test_no : test_no
					 ,que_no : que_no
		}; 
		
		var selectoncallback = function(returndata) {	
			
			console.log( JSON.stringify(returndata));
								
			initTestDetail(returndata.examdetailsearch);
			
			// 모달 팝업
			gfModalPop("#layer2");
			
		}
		
		callAjax("/exmexm/examdetailone.do", "post", "json", false, param, selectoncallback);
		
	}
	
	
	

	
	/** 시험 문항 저장 */
	function SaveTestDetail() {

	
		if ( ! ValidateTestDetail() ) {
			return;
		}
		
		var param = {
				action : $("#action").val(),
				test_no : $("#dt_test_no").val(),
				que_no : $("#que_no").val(),
				que_content : $("#que_content").val(),
				opt_1 : $("#opt_1").val(),
				opt_2 : $("#opt_2").val(),
				opt_3 : $("#opt_3").val(),
				opt_4 : $("#opt_4").val(),
				answer : $("#answer").val(),
				score : $("#score").val()
		}
		
		var savecollback = function(reval) {
			console.log( JSON.stringify(reval) );
						
						if(reval.returnvalQ > 0) {
							alert("저장 되었습니다.");
							
							gfCloseModal();
							
							if($("#action").val() == "U") {
								fn_ListTestDetail($("#currentPageComnDtlCod").val());
							} else {
								fn_ListTestDetail();  //현재 목록 조회
							
							}
						}  
						
						else {
				
				alert("오류가 발생 되었습니다.");				
			}
		}
	
		callAjax("/exmexm/quesave.do", "post", "json", false, $("#myForm").serialize(), savecollback);
		
	}
	
	
	
	
	
	
	

</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" id="currentPageComnGrpCod" value="1">
	<input type="hidden" id="currentPageComnDtlCod" value="1">
	<input type="hidden" id="examtest_no" name="examtest_no">
	<input type="hidden" id="examtest_name" name="examtest_name">
	<input type="hidden" id="test_no" name="test_no">
	<input type="hidden" id="dt_test_no" name="dt_test_no">

	<input type="hidden" name="action" id="action" value="">

	
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
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
								class="btn_nav bold">성적관리</span> <span class="btn_nav bold">시험관리</span>
								<a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>시험 목록</span> <span class="fr">
							 <select id="lecbyusercombo" name="lecbyusercombo" style="width: 150px;" >
							 </select>
							
     	                       <input type="text" style="width: 150px; height: 25px;" id="sname" name="sname">                    
	                           <a href="" class="btnType blue" id="btnSearchGrpcod" name="btn"><span>검  색</span></a>
							
							<a class="btnType blue" href="javascript:openModalExam();" name="modal"><span>시험등록</span></a>
							</span>
						</p>
						
						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="10%">
									<col width="70%">
									<col width="20%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">시험이름</th>
										<th scope="col">수정</th>
									</tr>
								</thead>
								<tbody id="listExam"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="comnGrpCodPagination"> </div>
						
						
						
						<table style="margin-top: 10px" width="100%" cellpadding="5" cellspacing="0" border="1"
                        align="left"
                        style="collapse; border: 1px #50bcdf;">
                        <tr style="border: 0px; border-color: blue">
                           <td width="80" height="25" style="font-size: 120%;">&nbsp;&nbsp;</td>
                           <td width="50" height="25" style="font-size: 100%; text-align:left; padding-right:25px;">
                           
     	                  
                           </td> 
                           
                        </tr>
                     </table> 
                     
						<p class="conTitle mt50">
							<span>시험 문제 목록</span> <span class="fr"> <a
								class="btnType blue"  href="javascript:openModalTestDetail();" name="modal"><span>문제등록</span></a>
							</span>
						</p>
	
						<div class="divComDtlCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="5%">
									<col width="17%">
									<col width="17%">
									<col width="17%">
									<col width="17%">
									<col width="17%">
									<col width="10%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">문제번호</th>
										<th scope="col">문제</th>
										<th scope="col">보기1</th>
										<th scope="col">보기2</th>
										<th scope="col">보기3</th>
										<th scope="col">보기4</th>
										<th scope="col">수정/삭제</th>
									</tr>
								</thead>
								<tbody id="listTestDetail">
									<tr>
										<td colspan="7">시험명을 선택해 주세요.</td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="paging_area"  id="comnDtlCodPagination"> </div>

					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

	<!-- 모달팝업 -->
	<div id="layer1" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>시험 등록</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">시험명</th>
							<td colspan="3"><input type="text" class="inputTxt p100" name="test_name" id="test_name" /></td>
						</tr>
				
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveExam" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDeleteExam" name="btn"><span>삭제</span></a> 
					<a href=""	class="btnType gray"  id="btnCloseExam" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	
	
	
<div id="layer2" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>문제 등록</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
					
						<tr>
							<th scope="row"><input type="hidden" id="que_no" name="que_no">시험명</th>
							
							<td colspan="3"><input type="text" class="inputTxt p100" name="dt_test_name" id="dt_test_name" /></td>
						</tr>
						<tr>
							<th scope="row">문제</th>
							<td colspan="3"><input type="text" class="inputTxt p100" name="que_content" id="que_content" /></td>
						</tr>
						<tr>
							<th scope="row">보기1</th>
							<td colspan="3"><input type="text" class="inputTxt p100" name="opt_1" id="opt_1" /></td>
						</tr>
						<tr>
							<th scope="row">보기2</th>
							<td colspan="3"><input type="text" class="inputTxt p100" name="opt_2" id="opt_2" /></td>
						</tr>
						<tr>
							<th scope="row">보기3</th>
							<td colspan="3"><input type="text" class="inputTxt p100" name="opt_3" id="opt_3" /></td>
						</tr>
						<tr>
							<th scope="row">보기4</th>
							<td colspan="3"><input type="text" class="inputTxt p100" name="opt_4" id="opt_4" /></td>
						</tr>
						<tr>
							<th scope="row">정답</th>
							<td colspan="3"><input type="text" class="inputTxt p100" name="answer" id="answer"     oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
                        placeholder = "보기 번호를 숫자로만 입력하세요." /></td>
						</tr>
						<tr>
							<th scope="row">배점</th>
							<td colspan="3"><input type="text" class="inputTxt p100" name="score" id="score"     oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
                        placeholder = "숫자로 입력하세요." /></td>
						</tr>
						
					
						
				
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveQ" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDeleteQ" name="btn"><span>삭제</span></a> 
					<a href=""	class="btnType gray"  id="btnCloseQ" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	
	<!--// 모달팝업 -->
</form>
</body>
</html>