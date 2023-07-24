<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="java.util.List" %>
<%@ page import="kr.happyjob.study.supsvy.model.SurveyModel" %>

<dl>
   <dt>
      <strong>설문조사 통계</strong>
   </dt>
   <dd class="content">

      <!-- s : 여기에 내용입력 -->
      <div style="max-height: 700px; overflow-y: auto; overflow-x: hidden;">
         <table class="row" style="margin-top: 30px;">
            <caption>caption</caption>
            <colgroup>
               <col width="120px">
               <col width="*">
               <col width="120px">
               <col width="*">

            </colgroup>

            <tbody id="surveyTotalForm">
               <tr>
                  <th scope="row">강의명</th>
                  <td>${surveyChartModel[0].lec_name}</td>
                  <th scope="row">강사명</th>
                  <td>${surveyChartModel[0].name}</td>
               </tr>
               <tr>
                  <th scope="row">강의 기간</th>
                  <td colspan="4">${surveyChartModel[0].lec_start}~
                     ${surveyChartModel[0].lec_end}</td>
               </tr>
               <tr>
                  <th colspan="4">강의 설문 결과</th>
               </tr>

                <!-- 설문조사 for문 돌릴영역 -->
         <%
             List<SurveyModel> surveyChartModel = (List<SurveyModel>) request.getAttribute("surveyChartModel");
         
                 int rowCount = 8; // 생성할 행의 개수
         
                 for (int i = 0; i < rowCount; i++) {
                     String chartId = "myChart" + (i + 1); // id 값 동적 생성
                     SurveyModel model = surveyChartModel.get(i+1);
         %>
                     <tr>
                         <th scope="row">Q<%= i+2 %>. <br>
                         <%= model.getQst_content() %></th>
                         <td colspan="3"><canvas id="<%=chartId%>" width="600" height="200"></canvas></td>
                     </tr>
         <%
                 }
         %>
            </tbody>
         </table>


         <div class=""
            style="padding: 30px 0px 5px 0px; display: flex; justify-content: center;">
            <a href="javascript:gfCloseModal()" class="btnType blue"
               id="btnClose" name="btn"><span>닫기</span></a>
         </div>
   </dd>
</dl>
<a href="javascript:gfCloseModal()" class="closePop"><span
   class="hidden">닫기</span></a>

<script>

   var label1 = [];
   var label2 = [];
   var label3 = [];
   var label4 = [];
   var label5 = [];
   var labels = [label1, label2, label3, label4, label5];
   var labelsA = [label1, label2, label3, label4, label5];
   
   <c:forEach items="${exContentList}" var="item">
         <c:if test="${item.ex_num == 1 }">
            label1.push("${item.ex_content}");
      </c:if>
      <c:if test="${item.ex_num == 2}">
            label2.push("${item.ex_content}");
      </c:if>
      <c:if test="${item.ex_num == 3}">
         label3.push("${item.ex_content}");
      </c:if>
      <c:if test="${item.ex_num == 4}">
         label4.push("${item.ex_content}");
      </c:if>
      <c:if test="${item.ex_num == 5}">
         label5.push("${item.ex_content}");
      </c:if>
   </c:forEach>
   
   label1 = label1.toString().split(",");
   label2 = label2.toString().split(",");
   label3 = label3.toString().split(",");
   label4 = label4.toString().split(",");
   label5 = label5.toString().split(",");
   
   
   
   for(var i = 0; i < 5; i++)
   {
      labelsA[i] = labels[i].toString().split(",").slice(0,5);
      labels[i] = labels[i].toString().split(",").slice(5);
      
      var arrText = [];
      
      for(var j = 0; j < labels[i].length; j++)
      {
         var text = labels[i][j];
         arrText = [];
         
         arrText.push(text.slice(0, Math.ceil(text.length / 3)))
         arrText.push(text.slice(Math.ceil(text.length / 3), Math.ceil(text.length * 2 / 3)))
         arrText.push(text.slice(Math.ceil(text.length * 2 / 3)))
         
         labelsA[i].push(arrText)
      }
   };

   labelsA[3].splice(5, 0, "");
   labelsA[4].splice(5, 0, "");
   labelsA[4].splice(6, 0, "");
   
   var count1 = [];
   var count2 = [];
   var count3 = [];
   var count4 = [];
   var count5 = [];
   
   <c:forEach items="${surveyChartModel}" var="item">
   count1.push("${item.count1}");
   count2.push("${item.count2}");
   count3.push("${item.count3}");
   count4.push("${item.count4}");
   count5.push("${item.count5}");
   </c:forEach>
   
   count1 = count1.toString().split(",").slice(1, -2);
   count2 = count2.toString().split(",").slice(1, -2);
   count3 = count3.toString().split(",").slice(1, -2);
   count4 = count4.toString().split(",").slice(1, -2);
   count5 = count5.toString().split(",").slice(1, -2);
   
   

   var nCnt = 8; // 총 문항 11개중 서술형 답변 1,10,11 제외하여 8번
   var surveyChartModel = "${surveyChartModel[0]}";
   //model.addAttribute("surveyChartModel", surveyChartModel);

   var onesCount = 0;
   count1.forEach(function(value) {
      if (value === "1") {
         onesCount++;
      }
   });

   for (var i = 1; i <= nCnt; i++) {
      var ctx = document.getElementById('myChart' + i);
      new Chart(ctx, {
         type: 'bar',
         data: {
            labels: [labelsA[0][i-1],labelsA[1][i-1],labelsA[2][i-1],labelsA[3][i-1],labelsA[4][i-1]],
            datasets: [{
               data: [count1[i - 1], count2[i - 1], count3[i - 1], count4[i - 1], count5[i - 1]],
               
               backgroundColor: [  
                                 'rgba(255, 95, 95, 1)',    // 매우 불만족 - 연한 빨강
                                 'rgba(255, 180, 95, 1)',   // 불만족 - 연한 주황
                                 'rgba(255, 228, 95, 1)',   // 보통 - 연한 노랑
                                 'rgba(142, 219, 120, 1)',  // 만족 - 연한 초록
                                 'rgba(120, 160, 255, 1)'   // 매우 만족 - 연한 파랑
            ]                                  
                                               

                                               
            }]
         },
         options: {
            responsive: false, // 크기 자동조정
            legend: {
               display: false // 범례 제거
            },
            scales: {
               yAxes: [{
                  ticks: {
                     beginAtZero: true,
                     min: 0,
                     max: onesCount,
                     stepSize: 1
                  }
               }],
               xAxes : [{
                  ticks: {
                     fontSize : 8
                  }
               }]
            }
         }
      });
   }
</script>