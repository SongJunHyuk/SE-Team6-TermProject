<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="./connection.jsp" %>

<%

	request.setCharacterEncoding("UTF-8");	

	int openTime = Integer.valueOf(request.getParameter("openTime"));
	
	int overTime = Integer.valueOf(request.getParameter("overTime"));
	
	
	PreparedStatement pstmt = null;
	
	String sql = "UPDATE operatingHour SET open_time=?, over_time=?"; //먼저 예약번호(oid)에 해당하는 예약을 불러온다
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, openTime);
	pstmt.setInt(2, overTime);
	pstmt.executeUpdate();
	
	
	if(pstmt!=null)
		pstmt.close();
	if(conn!=null)
		conn.close();

	response.sendRedirect("./mainScreen.jsp");
	%>
