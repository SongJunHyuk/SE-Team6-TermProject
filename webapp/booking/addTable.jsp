<%@ page contentType="text/html; charset=utf-8" %>

<html>
<head>
	<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<title>테이블 추가</title>
	<script>
		function checkConfirm(){
			
			var regExpNum = /^[0-9]*$/;
			var places = document.addTable.places.value;
			var form = document.addTable;
			if(!regExpNum.test(places)){
				alert("숫자만 입력해주세요");
				return;
			}
			
			if(places<=0){
				alert("인원 수는 0보다 커야합니다")
			}
			
			if(confirm("테이블을 추가하시겠습니까?") == true){
				alert('테이블 추가가 완료 되었습니다!');
				form.submit();
			}
			else
				return;

			
		}
	</script>
</head>
<body>
	<%@ include file="./menu.jsp" %>
	<% String greeting = "6조 레스토랑"; 
	String tagline = "테이블 수용인원을 입력하세요";%>
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
		<form name="addTable" action="./processAddTable.jsp"
					class="form-horizontal" method="post">			
			<div class="form-group row">
				<label class="col-sm-2">테이블 수용 인원</label>
				<div class="col-sm-3">
					<input type="text" id="places" name="places" class="form-control">
				</div>
			</div>
			<div class="form-group row">
				<div class="col-sm-offset-2 col-sm-10 ">
					<input type="button" class="btn btn-primary" value="등록" onclick="checkConfirm()">
				</div>
			</div>
		</form>
		</div>
	</div>
</body>
</html>