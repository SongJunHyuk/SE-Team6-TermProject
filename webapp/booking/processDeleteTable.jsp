<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="./connection.jsp" %>

<%
	Statement stmt = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int tableNum = 0;
	String sql = "SELECT oid FROM `Table` order by desc limit 1";
	
	stmt=conn.createStatement();
	rs = stmt.executeQuery(sql);
	while(rs.next()){
		tableNum = rs.getInt("oid");
	}
	if(tableNum==0){
		response.sendRedirect("./manageTable.jsp");
	}
	sql = "DELETE FROM `Table` WHERE oid=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, tableNum);
	pstmt.executeUpdate();
	
	response.sendRedirect("./manageTable.jsp");
%>