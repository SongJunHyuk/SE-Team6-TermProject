<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="/connection.jsp" %>
<%
	String oid = request.getParameter("oid");
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "select * from Reservation";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	
	if(rs.next()){
		sql = "delete from Reservation where oid =?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1,oid);
		pstmt.executeUpdate();
		
	} else
		out.println("일치하는 상품이 없습니다");
	
	if(rs!=null)
		rs.close();
	if(pstmt!=null)
		pstmt.close();
	if(conn!=null)
		conn.close();
	
	response.sendRedirect("./mainScreen.jsp");
	
%>
	
	