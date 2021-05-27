<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="./connection.jsp" %>

<%
	int waitingNum= Integer.valueOf(request.getParameter("waitingNum"));
	
	PreparedStatement pstmt = null;

	String sql = "DELETE FROM waitingList WHERE waiting_number = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, waitingNum);
	pstmt.executeUpdate();
	
%>
<html>
<head>
</head>
<body>
<script>
	alert('웨이팅 취소가 완료 되었습니다!');
</script>
</body>
</html>