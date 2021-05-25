<%@ page contentType="text/html; charset=utf-8" %>

<html>
<head>
	<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<title>6조 레스토랑 홈페이지</title>
</head>
<body>
	<%@ include file="./menu.jsp" %>
	<%! String greeting = "6조 레스토랑"; 
	String tagline = "반갑습니다. 6조 레스토랑입니다.";%>
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
			<a href="./ChoiceDate.jsp"><h3>
				예약 등록
			</h3></a>
		</div>
		<div class = "text-center">
			<a href="./CheckSelfReservation.jsp"><h3>
				예약 확인
			</h3></a>
		</div>
</body>
</html>