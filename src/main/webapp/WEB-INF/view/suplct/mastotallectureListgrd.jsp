<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- 20230710 17h 08m 커밋용 주석 -->
<c:if test="${totalcnt eq 0 }">
  <tr>
    <td colspan="7">데이터가 존재하지 않습니다.</td>
  </tr>
</c:if>

<c:if test="${totalcnt > 0 }">
  <c:forEach items="${maslecturesearchlist}" var="list">
    <tr>
      <td>
        <a href="javascript:fn_listlecclick('${list.lec_no}'); ">${list.lec_name}</a>
      </td>
      <td>${list.lec_prof}</td>
      <td>${list.lec_start }</td>
      <td>${list.lec_end}</td>
      <td>${list.lec_signcnt}</td>
      <td>${list.max_no}</td>
      <td style="display: flex">
        <a style="margin-right: 3px" class="btnType3 color2" href="javascript:fn_selectOne('${list.lec_no}');"><span>수정</span></a
        >
        <a class="btnType3 color1" id="lecListDelete" href="javascript:fn_lecDel('${list.lec_no}','Y');" name="btn" ><span>삭제</span></a>
      </td>

    </tr>
  </c:forEach>
</c:if>

<input type="hidden" id="totalcnt" name="totalcnt" value="${totalcnt}" />
<!-- 주석 -->