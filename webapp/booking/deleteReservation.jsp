<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="./connection.jsp" %>
<%
	String oid = request.getParameter("oid");
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "delete from Reservation where oid =?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1,oid);
	pstmt.executeUpdate();
		
	
	if(rs!=null)
		rs.close();
	if(pstmt!=null)
		pstmt.close();
	if(conn!=null)
		conn.close();
	
	response.sendRedirect("./mainScreen.jsp");
	
%>
	
	