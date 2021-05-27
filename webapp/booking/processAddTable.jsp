<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<%@ include file="./connection.jsp" %>

<%
	request.setCharacterEncoding("UTF-8");
	
	int oid = 0;
	int places = Integer.valueOf(request.getParameter("places"));
	
	Statement stmt = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT oid FROM `Table` order by oid desc limit 1";
	stmt = conn.createStatement();
	rs = stmt.executeQuery(sql);
	while(rs.next()){
		oid = rs.getInt("oid");
	}
	
	if(oid==0){
		response.sendRedirect("./addTable.jsp");
	}
	oid++;
	sql = "INSERT INTO `Table` (oid, number, places) VALUES (?, ?, ?)";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, oid);
	pstmt.setInt(2, oid);
	pstmt.setInt(3, places);
	pstmt.executeUpdate();
	
	if(pstmt!=null)
		pstmt.close();
	if(conn!=null)
		conn.close();
 
	response.sendRedirect("./mainScreen.jsp");
%>