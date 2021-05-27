<%@ page contentType="text/html; charset=utf-8" %>

<html>
<head>
	<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<title>운영시간 관리 페이지</title>
	<script>
		function checkTime(){
			var openTime = document.updateOperatingHour.openTime.value;
			var overTime = document.updateOperatingHour.overTime.value;
			var form = document.updateOperatingHour;
			
			if(openTime > overTime){
				alert("오픈 시간은 마감 시간보다 빨라야 합니다!");
				return;
			}
			alert('운영시간 수정이 완료 되었습니다!');
			form.submit();
			
		}
	</script>
</head>
<body>
	<%@ include file="./menu.jsp" %>
	<% String greeting = "6조 레스토랑"; 
	String tagline = "운영시간을 입력 해주세요";%>
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
	<div class="row" align="center">
		<div class="col-md-7">
		<form name="updateOperatingHour" action="./processChangeOperatingHour.jsp"
					class="form-horizontal" method="post">			
			<div class="form-group row">
				<label class="col-sm-2">운영시간</label>
				<div class="col-sm-3">
					<select name="openTime">
						<%for(int i=0; i<=24; i++){%>
								<option value="<%=i%>"><%=i %></option>
								<% } %>
					</select>~
					<select name="overTime">
						<%for(int i=1; i<=24; i++){%>
								<option value="<%=i%>"><%=i %></option>
								<% } %>
					</select>
				</div>
			</div>
			<div class="form-group row">
				<div class="col-sm-offset-2 col-sm-10 ">
					<input type="button" class="btn btn-primary" value="등록" onclick="checkTime()">
				</div>
			</div>
		</form>
		</div>
	</div>
</body>
</html>