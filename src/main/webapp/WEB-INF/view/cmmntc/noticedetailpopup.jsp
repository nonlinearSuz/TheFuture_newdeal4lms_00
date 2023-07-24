<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- 2023-07-11 commit!! 주석 -->
<!-- 	<div class="hidden"> -->
			<dl>
				<dt>
				<strong>공지사항</strong>
				</dt>
				<dd class="content">
				<!-- s : 여기에 내용입력 -->
	 <div class="sidescroll" style="height: 400px; overflow: auto !important">
			<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="300px">
						<col width="*">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">글제목</th>
							<td colspan="3">
								 <input type="text"  class="inputTxt p100 noti_title"  id="noti_title"  value="${noticesearch.nt_title }" ></input>
							</td>
						</tr>
						<tr>
							<th scope="row">작성자</th>
							<td colspan="3"><span  class="inputTxt p100" id="noti_writer" >${noticesearch.enr_user}</span></td>
						</tr>
						<tr>	
							<th scope="row">등록일</th>
							<td colspan="3">
								<span  class="inputTxt p100" id="noti_date" >${noticesearch.enr_date }</span>
							</td>
						</tr>

						<tr>
								<th colspan="4">글 내용</th>
						</tr>

						 <tr>
							<td colspan="4">
									<textarea class="inputTxt p100 noti_contents" id="noti_contents" style="border:#e5e5e5;">${noticesearch.nt_contents }</textarea>
							</td>
						</tr>
						<!-- 글 작성자 일때 버튼 생성 -->
						<tr align=right>
							<c:if test="${noticesearch.enr_user eq sessionScope.loginId }">
								<td colspan="4" align=right>
									<a  href="javascript:fn_save();" class="btnType4 color2" id="btnUpdate" name="btn"><span>수정</span></a>
									<a href="javascript:fn_saved();" class="btnType4 grey" id="btnDelete" name="btn"><span>삭제</span></a>
								</td>	
							</c:if>
						</tr>
			<!-- 댓글 -->			
						<tr>
								<th colspan="4">댓글</th>
						</tr>
						<tr>
							<th scope="row">댓글작성자</th>
							<th scope="row">댓글 내용</th>
							<th scope="row">댓글 작성일</th>
						<tr>
						<c:if test="${empty noticeRvList}">
		                     	<tr>
			                   		 <td colspan="4" align="center">댓글이 없습니다.</td>
		                     	</tr>
	                    </c:if>
	                    
	                    	<c:if test="${not empty noticeRvList }">
		                           <c:forEach items="${noticeRvList}" var="reply">
		                           	<c:if test="${reply.enr_user eq sessionScope.loginId }">
			                           <tr>
			                           		<td> ${reply.enr_user }</td>
			                             	<td>
			                             		<input style="height:28px; width:100%;"type="text" name="rpy_contents"${reply.rpy_no }  id="rpy_contents${reply.rpy_no }" value="${reply.rpy_contents }"/>
			                             	</td>
				                            <td>
				                            	<span style="line-height:2.2">${reply.enr_date}</span>
				                          	  <span>
       											<a class="btnType4 grey" href="javascript:fn_replyed(${reply.rpy_no});"  id="btnReplyDelete"  name="btn"><span>삭제</span></a>
								      			<a style="margin-right: 3px;" class="btnType4 color2 " 
										      		href="javascript:fn_replyes(${reply.rpy_no});" id="btnReplyUpdate" name="btn" ><span>수정</span></a>
       											</span>
				                            </td>
				
			                         	</tr>
			                          </c:if>
   		                           	<c:if test="${reply.enr_user ne sessionScope.loginId }">
			                           <tr>
			                           		<td> ${reply.enr_user }</td>
			                             	<td>
			                             		<input style="border:0; width:100%" type="text" name="rpy_contents"${reply.rpy_no }  id="rpy_contents${reply.rpy_no }" value="${reply.rpy_contents }" readonly/>
			                             	</td>
				                            <td>${reply.enr_date}</td>
				                        	</tr>
			                          </c:if>
		                          </c:forEach>
	                    	 </c:if>
					</tbody>
				</table>
						</div>

						<c:if test= "${sessionScope.userType eq 'T' || sessionScope.userType eq 'S' }">
							<div style="margin-top:30px; text-align:center;">
								<input type="text"  id="rpy_content" style="height: 28px; width: 500px; ">
								<a href="javascript:fn_reply();" class="btnType blue" id="btnReply" name="btn" ><span>댓글 작성</span></a>
							</div>
						</c:if>

			</dd>
		</dl>
		<a href="" class="closePop" id="closeRePop"><span class="hidden">닫기</span></a>
	<!--  </div> --> 
<!-- <input type="hidden" id="myForm" name="myForm"/> -->
<input type="hidden" id="totalcnt" name="totalcnt" value="${totalcnt }"/>
<input type="hidden" id="action"  name="action"  />
<input type="hidden" id="rpy_no"  name="rpy_no"  value="${reply.rpy_no}"/> 
<input type="hidden" id="pageno"  name="pageno"  />
<%-- <input type="hidden" id="nt_no" name="nt_no" value="${nt_no }"/> --%>


