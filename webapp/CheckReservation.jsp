<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.StringTokenizer" %>
<html>
<head>
<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<style>
		*{
		margin:0;
		padding:0;
	}
	
	.tableNum{
		background:black;
		float:left;
		color: white;
		text-align:center;
		height:100%;
	}
	.containerTable{
		margin: 0 auto;
		width:90%;
		height: 350px;
		
	}
	
	.title{
		background:black;
		text-align:center;
		width:90%;
		color:white;
		position: relative;
		overflow: hidden;
		margin: 5px;
	}
	
	.reservationContainer{
		background:olivegreen;
		width:100%;
		position: relative;
	}
	
	.reservation {
		float: left;
		background: skyblue;
		width: 150px;
		height: 120px;
		color: white;
		text-align:center;
		margin: 5px;
	}
	.cannotReservation {
		float: left;
		background:orange;
		width: 150px;
		height: 120px;
		color: white;
		text-align:center;
		margin: 5px;
	}
	.customerName {
		color=orange;
	}	
	</style>
	<title>예약 조회</title>
</head>
<body>
<%@ include file="../menu.jsp" %>
	<% String greeting = "테이블 별 예약 가능 시간"; 
	String tagline = request.getParameter("date");%>
	<div class = "jumbotron">
		<div class = "container">
			<h1 class = "display-3"><%= greeting %>
			</h1>
		</div>
	</div>
	<div class = "text-center">
			<h3>
				<%= tagline %> 예약 목록
			</h3>
		</div>
<%@ include file="./connection.jsp" %>
	<%
	int reservationNum = 0;
	int tableNum = 0;
	int operatingHour = 10;
	Statement stmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	ResultSet rs2 = null;
	
	stmt= conn.createStatement();
	String sql = "select * from `Table` order by number desc limit 1";
	rs = stmt.executeQuery(sql);
	while(rs.next()){
		tableNum = Integer.valueOf(rs.getString("number"));
	}
	
	java.sql.Date date = java.sql.Date.valueOf(request.getParameter("date"));
	
	
	String sql2 = "select * from Reservation where date=? and table_id = ?";//해당 날짜, 테이블 번호의 예약내역
	
	boolean flag[][] = new boolean[tableNum][operatingHour];//예약 가능 여부를 판단하는 flag
	for(int i = 0; i < tableNum; i++){
		for(int j = 0; j < operatingHour ; j++){
			flag[i][j] = true;//먼저 true로 설정해준다.
		}
	}
	
	
	for(int i = 1; i <= tableNum; i++){
		pstmt = conn.prepareStatement(sql2);
		pstmt.setDate(1,date);
		pstmt.setInt(2,i);
		rs2 = pstmt.executeQuery();
		int j = 0;
		if(rs2.next()){
			
			String time = rs2.getString("time");
			StringTokenizer st = new StringTokenizer(time,":");
			time = st.nextToken();//시간을 받아온다
			int intTime = Integer.valueOf(time) - 11; //11시가 오픈타임으로 가정
			
			if(st.nextToken()=="00"){//해당 시간 정각에 예약이 있다면
				if (intTime==0){
				flag[i-1][intTime] = false; //오픈 시간 예약이라면
				}
				else{
					flag[i-1][intTime] = false;
					flag[i-1][intTime-1] = false;//30분 전의 예약 비활성화
					flag[i-1][intTime+1] = false;//30분 후의 예약 비활성화
				}
			}
			else{//30분에 예약이 있다면
				flag[i-1][intTime] = false;
				flag[i-1][intTime-1] = false;//30분 전의 예약 비활성화
				flag[i-1][intTime+1] = false;//30분 후의 예약 비활성화
			}
		}
	}
	%>
	<div class="containerTable">
	<%for(int i = 1; i <= tableNum; i++){%>
	<div class="title">
		<div class="tableNum"><%=i %>번 테이블</div>
		<%for(int j = 0; j < operatingHour; j++){ %>
		<%if(flag[i-1][j]==true){%>
			<div class="reservation">
			<%if(j%2==0){%>
				<%=j+11 %>:00<br>
				예약가능<br>
				<a href="./CustomerReservation.jsp?date=<%=date %>&tableNum=<%=i %>&time=<%=j+11 %>:00:00" class="btn btn-secondory" role="button">
							예약하기 &raquo;></a>
			<%}
			else{%>
				<%=j+11 %>:30<br>
				예약가능<br>
				<a href="./CustomerReservation.jsp?date=<%=date %>&tableNum=<%=i %>&time=<%=j+11 %>:30:00" class="btn btn-secondory" role="button">
							예약하기 &raquo;></a>
				
			<% }%>
			</div>
		<%}
		else{%>
		<div class="cannotReservation">
			<%if(j%2==0){%>
				<%=j+11 %>:00<br>
				예약 불가능<br>
			<%
			}
			else{%>
				<%=j+11 %>:30<br>
				예약 불가능<br>
			<%}%>
			</div>
		<%}
		
		}%>
		</div>
	<%}
		%>
	</div>
	<%
	if(conn != null);
	conn.close();
	if(rs != null)
		rs.close();
	if(stmt != null)
		stmt.close();
	if(rs2 != null)
		rs2.close();
	if(pstmt != null)
		stmt.close();
	%>

</body>
</html>