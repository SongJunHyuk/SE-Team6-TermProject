<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="./connection.jsp" %>

<%
	request.setCharacterEncoding("UTF-8");
	
	int tableNum = Integer.valueOf(request.getParameter("tableNum"));
	int places = Integer.valueOf(request.getParameter("places"));
	
	PreparedStatement pstmt= null;
	
	String sql = "UPDATE `Table` SET places=? WHERE oid=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1,places);
	pstmt.setInt(2,tableNum);
	pstmt.executeUpdate();

	response.sendRedirect("./manageRestaurant.jsp");
%>