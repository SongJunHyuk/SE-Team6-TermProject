<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.sql.Time" %>
<%@ include file="./connection.jsp" %>

<%
	request.setCharacterEncoding("UTF-8");
	
	if(request.getParameter("oid") == null){
		response.sendRedirect("./mainScreen.jsp");
	}

	int oid = Integer.valueOf(request.getParameter("oid"));
	int cus_id = 0;
	int mileage = 0;
	
	Time time = Time.valueOf(LocalTime.now());
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "UPDATE Reservation SET arrivalTime=? WHERE oid =?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setTime(1,time);
	pstmt.setInt(2,oid);
	pstmt.executeUpdate();
	
	sql = "SELECT customer_id FROM Reservation WHERE oid =?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, oid);
	rs = pstmt.executeQuery();
	
	while(rs.next()){
		cus_id = Integer.valueOf(rs.getInt("customer_id"));
	}
	if(cus_id == 0){
		response.sendRedirect("./mainScreen.jsp");
	}
	
	sql = "SELECT mileage FROM Customer WHERE oid =?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1,cus_id);
	rs = pstmt.executeQuery();
	
	while(rs.next()){
		mileage = rs.getInt("mileage");
	}
	
	mileage += 1000;
	
	sql= "UPDATE Customer SET mileage=? WHERE oid =?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1,mileage);
	pstmt.setInt(2,cus_id);
	pstmt.executeUpdate();
	
%>
<html>
<head>
</head>
<body>
	<script>
		function updateComplete(){
			alert('도착시간이 기록 되었습니다!');
		}
		updateComplete();
	</script>
	<%
		response.sendRedirect("./mainScreen.jsp");
	%>
</body>
</html>
