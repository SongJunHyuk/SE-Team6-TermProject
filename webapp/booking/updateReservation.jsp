<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<html>
<head>
	<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	

<title>예약 수정</title>
</head>
<body>
	<%@ include file="../menu.jsp" %>
	<div class = "jumbotron">
		<div class = "container">
			<h1 class = "display-3">예약 수정</h1>
		</div>
	</div>
	<%@ include file="/connection.jsp" %>
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
			rs2.next();
	%>
	<div class="container">
		<br>
		<div class="row" align="center">
			<div class="col-md-7">
				<form name="updateReservation" action="./processUpdateReservation.jsp?oid=<%=oid %>"<%//mainScreen에서 전달 받은 oid를 processUpdateReservation 페이지에 전달 %>
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
							<input type="button" class="btn btn-primary" value="등록" onclick="checkUpdateReservation()">
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