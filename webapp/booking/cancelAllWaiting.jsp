<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="./connection.jsp" %>

<%
	Statement stmt = null;

	String sql = "DELETE FROM waitingList";
	stmt = conn.createStatement();
	stmt.executeUpdate(sql);
	
	sql = "DELETE FROM wNumber";
	stmt = conn.createStatement();
	stmt.executeUpdate(sql);
	
	sql = "INSERT INTO wNumber VALUES(0)";
	stmt = conn.createStatement();
	stmt.executeUpdate(sql);
	
	response.sendRedirect("./WaitingList.jsp");
%>
