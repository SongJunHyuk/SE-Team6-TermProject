<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Date" %>

<%@ include file="./connection.jsp" %>

<html>
<head>
<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<title>에약 확인</title>
</head>
<body>
<%@ include file="./menu.jsp" %>
	<% String greeting = "예약 확인"; 
	String tagline = "고객님의 예약 목록";%>
	<div class = "jumbotron">
		<div class = "container">
			<h1 class = "display-3"><%= greeting %>
			</h1>
		</div>
	</div>
		<div class = "text-center">
			<h5>
				<%= tagline %>
			</h5>
		</div>
<%
	request.setCharacterEncoding("UTF-8");
	

	
	String phoneNumber = request.getParameter("phoneNumber");
	int cus_id=0;
	int mileage=0;
	boolean existanceReservation = false;
	
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM Customer WHERE phoneNumber=?"; //전화번호로 고객id 가져온다
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, phoneNumber);
	rs = pstmt.executeQuery();
	
	while(rs.next()){
		cus_id = rs.getInt("oid");
		mileage = rs.getInt("mileage");
	}
	if(cus_id!=0){
		sql = "SELECT * FROM Reservation WHERE customer_id=? order by oid";//고객id로 예약내역을 불러온다.
		pstmt2 = conn.prepareStatement(sql);
		pstmt2.setInt(1, cus_id);
		rs = pstmt2.executeQuery();
	%>
	
	<%while(rs.next()){//예약이 존재한다면 출력
		existanceReservation = true;%>
		<script>
		function checkDelete() {
			if(confirm("예약을 취소하시겠습니까?") == true)
				location.href = "./deleteReservation.jsp?oid=<%=rs.getString("oid")%>
			else
				return;
		}
	</script>
		<div class="text-center">
			예약번호: <%=rs.getString("oid") %><br>
			예약날짜: <%=rs.getString("date") %><br>
			예약인원: <%=rs.getString("covers") %><br>
			예약시간: <%=rs.getString("time") %><br>
			예약 테이블: <%=rs.getString("table_id") %><br>
			이벤트: <%=rs.getString("event") %><br>
			마일리지: <%=mileage %><br>
			<input type="button" value="예약 취소"onclick="checkDelete()">
		</div>
		
	<%}
	if(!existanceReservation){%>
		<div class="text-center">예약 내역이 존재하지 않습니다.</div>
		<div class="text-center"><a href="./ChoiceDate.jsp">예약하러 가기</a></div>	
	<%}
	}
	else{%>
		<div class="text-center">예약 내역이 존재하지 않습니다.</div>
		<div class="text-center"><a href="./ChoiceDate.jsp">예약하러 가기</a></div>
	<%}
	if(rs!=null)
		rs.close();
	if(pstmt!=null)
		pstmt.close();
	if(pstmt2!=null)
		pstmt2.close();
	
%>
</body>
</html>