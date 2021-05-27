<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<html>
<head>
	<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<script>
function checkUpdatePlaces() {//유효성 검사, 잘못된 입력 방지
		
		
		var regExpNum = /^[0-9]*$/;
		
		var places = document.updatePlaces.places.value;
		var form = document.updatePlaces;
		
		if(!regExpNum.test(places)){
			alert("수용 인원은 숫자만 입력해주세요!");
			form.places.focus();
			return;
		}
		alert('테이블 정보 수정이 완료 되었습니다!');
		form.submit();
	}
	</script>

<title>테이블 수용 인원 변경</title>
</head>
<body>
	<%@ include file="./menu.jsp" %>
	<div class = "jumbotron">
		<div class = "container">
			<h1 class = "display-3">테이블 수용 인원 변경</h1>
		</div>
	</div>
	<%@ include file="./connection.jsp" %>
	<%
		int tableNum = 0; //table 개수
		
		Statement stmt = conn.createStatement();
		String sqlTable = "SELECT * FROM `Table` order by number desc limit 1";//테이블의 개수를 테이블의 가장 마지막 데이터를 추출하여 알아낸다
		ResultSet rsTable = stmt.executeQuery(sqlTable);
		while (rsTable.next()){
			tableNum = Integer.valueOf(rsTable.getString("number")); //테이블 개수 설정
		}
		rsTable.close();
		stmt.close();
		
		
		
	%>
	<div class="container">
		<br>
		<div class="row" align="center">
			<div class="col-md-7">
				<form name="updatePlaces" action="./processUpdatePlaces.jsp"
					class="form-horizontal" method="post">
					<div class="form-group row">
						<label class="col-sm-2">테이블 번호</label>
						<div class="col-sm-3">
							<select name="tableNum">
								<%for(int i=1; i<=tableNum; i++){ //테이블 개수만큼 반복문 실행%>
								<option value="<%=i%>"><%=i %></option>
								<% } %>
							</select>
								
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2">수용 인원</label>
						<div class="col-sm-3">
							<input type="text" id="places"
							name="places" class="form-control">
						</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-offset-2 col-sm-10 ">
							<input type="button" class="btn btn-primary" value="등록" onclick="checkUpdatePlaces()">
						</div>
					</div>
				</form>
			</div>
		
		</div>
	</div>
</body>
</html>