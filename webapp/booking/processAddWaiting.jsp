<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="./connection.jsp" %>

<% 
	request.setCharacterEncoding("UTF-8"); 
	
	String name = request.getParameter("name");
	String phoneNumber = request.getParameter("phoneNumber");
	
	int last_wNum = 0;
	
	Statement stmt = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs = null;
	
	String sql = "SELECT last_waiting_number FROM wNumber";
	stmt = conn.createStatement();
	rs = stmt.executeQuery(sql);
	
	while(rs.next()){
		last_wNum = rs.getInt("last_waiting_number");
		last_wNum++;
	}
	
	if(last_wNum != 0){
		sql = "UPDATE wNumber SET last_waiting_number=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1,last_wNum);
		pstmt.executeUpdate();
		
		sql = "INSERT INTO waitingList (waiting_number, name, phoneNumber) VALUES (?, ?, ?)";
		pstmt2 = conn.prepareStatement(sql);
		pstmt2.setInt(1,last_wNum);
		pstmt2.setString(2, name);
		pstmt2.setString(3,phoneNumber);
		pstmt2.executeUpdate();
	}
	if(rs!=null)
		rs.close();
	if(stmt!=null)
		stmt.close();
	if(pstmt!=null)
		stmt.close();
	if(pstmt2!=null)
		stmt.close();
	response.sendRedirect("./WaitingList.jsp");
%>