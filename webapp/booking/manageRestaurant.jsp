<%@ page contentType="text/html; charset=utf-8" %>

<html>
<head>
	<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<title>레스토랑 관리 페이지</title>
</head>
<body>
	<%@ include file="./menu.jsp" %>
	<% String greeting = "6조 레스토랑"; 
	String tagline = "관리 페이지";%>
	<div class = "jumbotron">
		<div class = "container">
			<h1 class = "display-3"><%= greeting %>
			</h1>
		</div>
	</div>
		<div class = "text-center">
			<h2>
				<%= tagline %>
			</h2>
		</div>
		
		<div class = "text-center">
			<a href="./changeOperatingHour.jsp"><h3>
				운영시간 변경
			</h3></a>
		</div>
		<div class = "text-center">
			<a href="./manageTable.jsp"><h3>
				테이블 추가 및 수용 인원 변경
			</h3></a>
		</div>
		<div class = "text-center">
			<a href="./statistics.jsp"><h3>
				고객 별 이용 통계
			</h3></a>
		</div>
</body>
</html>