<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Date" %>
<%@ include file="./connection.jsp" %>

<%
	String name = request.getParameter("name");
	String phoneNumber = request.getParameter("phoneNumber");
	int cus_id=0;
	int mileage = 0;
	
	Statement stmt = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT oid from Customer WHERE phoneNumber=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1,phoneNumber);
	rs = pstmt.executeQuery();
	
	while(rs.next()){//고객 정보가 존재하지 않으면 실행되지 않음
		cus_id = rs.getInt("oid");
	}
	
	if(cus_id==0){
		sql = "SELECT oid from Customer order by oid desc limit 1";
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);
		while(rs.next()){
			cus_id = rs.getInt("oid");
		}
		cus_id++;
		mileage += 1000;
		sql = "INSERT INTO Customer (oid, name, phoneNumber, mileage) VALUES (?, ?, ?, ?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, cus_id);
		pstmt.setString(2, name);
		pstmt.setString(3, phoneNumber);
		pstmt.setInt(4, mileage);
		pstmt.executeUpdate();
	}
	else{
		sql = "SELECT mileage from Customer WHERE oid=?";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while(rs.next()){
			mileage = rs.getInt("mileage");
		}
		mileage += 1000;
		sql = "UPDATE Customer SET mileage=? WHERE oid=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, mileage);
		pstmt.setInt(2, cus_id);
		pstmt.executeUpdate();
	}
	if(stmt!=null)
		stmt.close();
	if(pstmt!=null)
		pstmt.close();
	if(conn!=null)
		conn.close();


	response.sendRedirect("./mainScreen.jsp");
%>
