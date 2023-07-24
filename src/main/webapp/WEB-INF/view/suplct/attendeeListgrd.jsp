<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- 20230710 17h 08m 커밋용 주석!! -->
							<c:if test="${totalcnt eq 0 }">
								<c:choose>
									<c:when test="${sessionScope.userType =='M'}">
											<tr>
												<td colspan="5">데이터가 존재하지 않습니다.</td>
											</tr>
									</c:when>
									 <c:when test="${sessionScope.userType =='T'}">
										<tr>
												<td colspan="8">데이터가 존재하지 않습니다.</td>
											</tr>
									</c:when>
								</c:choose>			
							</c:if>
							
							<c:if test="${totalcnt > 0 }">
								<c:forEach items="${attendeesearchlist}" var="list">
									<tr>
										<c:choose>
											<c:when test="${sessionScope.userType =='M'}">
												<td scope="col"><a>${list.loginID}</a></td>
												<td scope="col"><a>${list.name}</a></td>
												<td scope="col"><a>${list.lec_name}</a></td>
												<c:if test="${list.acc_yn == 'Y'}">
														<td scope="col">승인</a></td>
													</c:if>
													<c:if test="${list.acc_yn == 'P'}">
														<td scope="col">승인 대기</a></td>
													</c:if>
													<c:if test="${list.acc_yn == 'N'}">
														<td scope="col">반려</a></td>
													</c:if>
												<td scope="col">
												 <c:if test="${list.acc_yn == 'P'}">
													<a style="" class="btnType3 color2" href=" javascript:fn_mastoStuLecSingInApprov('${list.loginID}','${list.lec_no}','Y');">
														<span>승인</span>
													</a>
													<a style="" class="btnType3 color2" href=" javascript:fn_mastoStuLecSingInApprov('${list.loginID}','${list.lec_no}','N');">
														<span>반려</span>
													</a>
												 </c:if>	
												 <c:if test="${list.acc_yn == 'Y'}">
													<a style="margin-right:3px" class="btnType3 color2" href=" javascript:fn_mastoStuLecSingInApprov('${list.loginID}','${list.lec_no}','N');">
														<span>반려</span>
													</a>
												 </c:if>	
												 <c:if test="${list.acc_yn == 'N'}">
													<a style="margin-right: 3px" class="btnType3 color2" href=" javascript:fn_mastoStuLecSingInApprov('${list.loginID}','${list.lec_no}','Y');">
														<span>승인</span>
													</a>
												 </c:if>	
												</td>
											</c:when>
											
											 <c:when test="${sessionScope.userType =='T'}">
											 	<td scope="col"><a>${list.lec_name}</a></td>
												<td scope="col"><a>${list.loginID}</a></td>
												<td scope="col"><a>${list.name}</a></td>
												<td scope="col"><a>${list.user_birth}</a></td>
												<td scope="col"><a>${list.user_hp}</a></td>
												<!-- <td scope="col"><a></a></td>  -->
												<td scope="col"><a>${list.tot_score}</a></td>
												<c:if test="${list.acc_yn == 'Y'}">
													<td scope="col">승인</a></td>
												</c:if>
												<c:if test="${list.acc_yn == 'P'}">
													<td scope="col">승인 대기</a></td>
												</c:if>
												<c:if test="${list.acc_yn == 'N'}">
													<td scope="col">반려</a></td>
												</c:if>
												
											</c:when>
										</c:choose>		
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="stutotalcnt" name="stutotalcnt" value ="${totalcnt}"/>
							
						