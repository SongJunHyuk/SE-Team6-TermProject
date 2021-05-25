<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="./connection.jsp" %>
<%
	String oid = request.getParameter("oid");//이전 페이지로부터 전달 받은 예약번호
	
	PreparedStatement pstmt = null;
	
	String sql = "delete from Reservation where oid =?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1,oid);
	pstmt.executeUpdate();
	
	if(pstmt!=null)
		pstmt.close();
	if(conn!=null)
		conn.close();
%>
<html>
	<head>
	<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<script>
	alert('예약 취소가 완료 되었습니다!');
	</script>
	</head>
	<body>
	<%@ include file="./menu.jsp" %>
	<% String greeting = "6조 레스토랑"; 
	String tagline = "돌아가기";%>
	<div class = "jumbotron">
		<div class = "container">
			<h1 class = "display-3"><%= greeting %>
			</h1>
		</div>
	</div>
	<div class = "text-center">
		<h2>
			<a href="./Main.jsp"><%= tagline %></a>
		</h2>
	</div>
	</body>
	</html>
	
	