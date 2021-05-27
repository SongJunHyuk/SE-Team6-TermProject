<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="./connection.jsp" %>
<%
int coversForTable = 0;
String table_id = request.getParameter("table_id");//테이블번호를 받아온다, 테이블마다 수용인원이 다르기 때문에 수용인원 초과하는 입력 방지 해야함
if(table_id==null){
	response.sendRedirect("./mainScreen.jsp");
}
String sql3 = "SELECT places from `Table` WHERE oid=?";
PreparedStatement pstmt4 = null;
ResultSet rs4 = null;
pstmt4 = conn.prepareStatement(sql3);
pstmt4.setString(1,table_id);
rs4 = pstmt4.executeQuery();
while(rs4.next()){
	coversForTable = rs4.getInt("places");//테이블의 수용 인원 받아온다.
}
if(coversForTable == 0){
	response.sendRedirect("./mainScreen.jsp");
}

%>
<html>
<head>
	<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<script>
function checkUpdateReservation(covers) {//유효성 검사, 잘못된 입력 방지
		
		var regExpName = /^[a-zA-Z가-힣]*$/;
		var regExpNum = /^[0-9]*$/;
		var regExpPhoneNum = /^\d{11}$/;
		var regExpDate = /^\d{4}-\d{2}-\d{2}$/;
		var regExpTime = /^\d{2}:\d{2}:\d{2}$/;
		var form = document.updateThisReservation;
		
		var name = document.updateThisReservation.name.value;
		var phoneNumber = document.updateThisReservation.phoneNumber.value;
		var date = document.updateThisReservation.date.value;
		var time = document.updateThisReservation.time.value;
		var covers = document.updateThisReservation.covers.value;
		
		if(!regExpName.test(name)){
			alert("이름은 알파벳, 한글만 입력해주세요!");
			form.name.select();
			return;
		}
		if(!regExpPhoneNum.test(phoneNumber)||!regExpNum.test(phoneNumber)){
			alert("전화번호는 11자리 숫자만 입력해주세요!")
			form.phoneNumber.select();
			return;
		}
		if(!regExpDate.test(date)){
			alert("날짜는 YYYY-MM-DD 형식으로 입력해주세요!");
			form.date.select();
			return;
		}
		if(!regExpTime.test(time)){
			alert("시간은 HH:MM:SS 형식으로 입력해주세요!");
			form.time.select();
			return;
		}
		if(!regExpNum.test(covers)){
			alert("인원은 숫자만 입력해주세요!");
			form.covers.select();
			return;
		}
		if(covers > Number(<%=coversForTable %>)){
			alert("해당 테이블의 수용 인원을 초과합니다!");
			form.covers.select();
			return;
		}
		alert('예약 정보 수정이 완료 되었습니다!');
		form.submit();
	}
	</script>

<title>예약 수정</title>
</head>
<body>
	<%@ include file="./menu.jsp" %>
	<div class = "jumbotron">
		<div class = "container">
			<h1 class = "display-3">예약 수정</h1>
		</div>
	</div>
	<%
		String oid = request.getParameter("id");//mainScreen에서 전달받은 oid값이다
		String cus_id=""; //고객의 정보를 불러오기 위한 고객의 id
		int tableNum = 0; //table 개수
		
		Statement stmt = conn.createStatement();
		String sqlTable = "SELECT * FROM `Table` order by number desc limit 1";//테이블의 개수를 테이블의 가장 마지막 데이터를 추출하여 알아낸다
		ResultSet rsTable = stmt.executeQuery(sqlTable);
		while (rsTable.next()){
			tableNum = Integer.valueOf(rsTable.getString("number")); //테이블 개수 설정
		}
		rsTable.close();
		stmt.close();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs3 = null;
		
		String sql = "select * from Reservation where oid = ?";//예약 정보를 가져오기 위한 쿼리문
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, oid);
		rs = pstmt.executeQuery();
		
		String sql2 = "select * from Customer where oid = ?";//고객의 정보를 가져오기 위한 쿼리문
		
		
		if (rs.next()) {
			cus_id = rs.getString("customer_id"); //예약 정보에 저장되어있는 고객 id를 cus_id에 저장
			pstmt2 = conn.prepareStatement(sql2);
			pstmt2.setString(1,cus_id);
			rs2 = pstmt2.executeQuery();
			rs2.next();//고객 정보를 가져온다.
	%>
	<div class="container">
		<br>
		<div class="row" align="center">
			<div class="col-md-7">
				<form name="updateThisReservation" action="./processUpdateReservation.jsp?oid=<%=oid %>"<%//mainScreen에서 전달 받은 oid를 processUpdateReservation 페이지에 전달 %>
					class="form-horizontal" method="post">
					
					<div class="form-group row">
						<label class="col-sm-2">이름</label>
						<div class="col-sm-3">
							<input type="text" id="name"
							name="name" class="form-control" value='<%=rs2.getString("name") %>'>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2">전화번호</label>
						<div class="col-sm-3">
							<input type="text" id="phoneNumber"
							name="phoneNumber" class="form-control" value='<%=rs2.getString("phoneNumber") %>'>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2">인원</label>
						<div class="col-sm-3">
							<input type="text" id="covers"
							name="covers" class="form-control" value='<%=rs.getString("covers") %>'>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2">예약 날짜</label>
						<div class="col-sm-3">
							<input type="text" id="date"
							name="date" class="form-control" value='<%=rs.getString("date") %>'>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2">예약 시간</label>
						<div class="col-sm-3">
							<input type="text" id="time"
							name="time" class="form-control" value='<%=rs.getString("time") %>'>
						</div>
					</div>
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
						<label class="col-sm-2">이벤트 준비</label>
						<div class="col-sm-3">
							<textarea name="event" cols="30" rows="3"></textarea>
						</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-offset-2 col-sm-10 ">
							<input type="button" class="btn btn-primary" value="등록" onclick="checkUpdateReservation(<%=coversForTable %>)">
						</div>
					</div>
				</form>
			</div>
		
		</div>
	</div>
	<%
		}
		if(rs != null)
			rs.close();
		if(rs2 != null)
			rs2.close();
		if(pstmt != null)
			pstmt.close();
		if(pstmt2 !=null)
			pstmt2.close();
		if(conn != null)
			conn.close();
	%>
	
</body>
</html>