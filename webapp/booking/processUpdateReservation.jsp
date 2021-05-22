<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*"%>
<%@ include file="/connection.jsp" %>
<%

	request.setCharacterEncoding("UTF-8");	

	int oid = Integer.valueOf(request.getParameter("oid"));
	String name = request.getParameter("name");
	String phoneNumber = request.getParameter("phoneNumber");
	int covers = Integer.valueOf(request.getParameter("covers"));
	String sDate = request.getParameter("date");
	String sTime = request.getParameter("time");
	int tableNum = Integer.valueOf(request.getParameter("tableNum"));
	String event = request.getParameter("event");
	
	Date date = Date.valueOf(sDate); // 문자열로 받은 날짜를 Date 형식으로 바꿔준다
	Time time = Time.valueOf(sTime); // 문자열로 받은 시간을 Time 형식으로 바꿔준다
	
	int cus_id;
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs2 = null;
	
	String sql = "SELECT * FROM Reservation WHERE oid =?"; //먼저 주문번호(oid)에 해당하는 예약을 불러온다
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, oid);
	rs = pstmt.executeQuery();
	
	String sql2 = "SELECT * FROM Customer WHERE oid =?"; //예약에 저장되어 있는 customer_id를 얻어오기 위한 쿼리문
	
	if(rs.next()){
		sql = "UPDATE Reservation SET covers=?, date=?, time=?, table_id=?, event=?  WHERE oid=?";
		pstmt= conn.prepareStatement(sql);
		pstmt.setInt(1,covers);
		pstmt.setDate(2,date);
		pstmt.setTime(3,time);
		pstmt.setInt(4,tableNum);
		pstmt.setString(5,event);
		pstmt.setInt(6,oid);
		pstmt.executeUpdate(); //UPDATE 쿼리문 실행
		
		cus_id=Integer.valueOf(rs.getString("customer_id"));//예약에 저장되어 있는 customer_id를 cus_id에 불러온다.
		
		pstmt2 = conn.prepareStatement(sql2);
		pstmt2.setInt(1,cus_id);
		rs2 = pstmt.executeQuery();
		
		if(rs2.next()){
			sql2 = "UPDATE Customer SET name=?, phoneNumber=? WHERE oid=?";
			pstmt2.setString(1,name);
			pstmt2.setString(2,phoneNumber);
			pstmt2.setInt(3,cus_id);
			pstmt2.executeUpdate(); // cus_id와 일치하는 고객의 정보에 대해 UPDATE 쿼리문 실행
		}
	}
	
	if(rs!=null)
		rs.close();
	if(pstmt!=null)
		pstmt.close();
	if(rs2!=null)
		rs2.close();
	if(pstmt2!=null)
		pstmt2.close();
	if(conn!=null)
		conn.close();
	
	response.sendRedirect("./mainScreen.jsp");
	%>
	
	
	