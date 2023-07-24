<%--  <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

							<c:if test="${totalcnt eq 0 }">
								<tr>
									<td colspan="5">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${totalcnt > 0 }">
								<c:forEach items="${profLecPlanList}" var="list">
									<tr>
										<td><a href="javascript:fn_listlecclick('${list.lec_no}'); ">${list.lec_name}</a></td>
										<td><a href="javascript:fn_lecDtInfo();">${list.lec_prof}</a><a href="javascript:fn_selectonefile('${list.lec_no}')">${list.name}</a></td>
										<td>${list.lec_start } ~ ${list.lec_end}</td>
										<td>${list.lec_signcnt} / ${list.max_no}</td>
										<c:if test="${list.lecOpen_yn == 'Y'}">
											<td scope="col">승인</a></td>
										</c:if>
										<c:if test="${list.lecOpen_yn == 'P'}">
											<td scope="col">승인 대기</a></td>
										</c:if>
										<c:if test="${list.lecOpen_yn == 'N'}">
											<td scope="col">반려</a></td>
										</c:if>
										
										
										
										<td style="display:flex">
											<a style="margin-right:3px;"class="btnType3 color2" href="javascript:fn_selectOne('${list.lec_no}'); "><span>수정</span></a>
											<a class="btnType3 color1" href=""><span>삭제</span></a>
										</td> 
										
										<!-- <td style='display:flex'>
											<a style="display: /* inline-block */; width:50%" href=""	class="btnType blue"  id="" name="btn"><span style="display: inline-block;"> 수정</span></a>
											<a href=""	class="btnType blue"  id="" name="btn"><span>삭제</span></a>	
										</td> -->
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="totalcnt" name="totalcnt" value ="${totalcnt}"/>  --%>