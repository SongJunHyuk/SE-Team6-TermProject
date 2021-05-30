<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.StringTokenizer" %>
<html>
<head>
<meta name="viewport" content="width=device-width; initial-scale=1.0">
<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<style>
	
	@media screen and (min-width:761px){
	.container p{
		font-size:calc(1.525rem + 3.3vw);
		font-weight:300;
		line-height:1.2
	}
	.text-center p{
			font-size:calc(1.2rem + 2.2vw);
			font-weight:150;
			line-height:1.2;
		}
		
	.visibleInMobile *{
		display:none;
	}
	
	.tableNum{
		background:black;
		color: white;
		text-align:center;
		width:100%;
	}
	.containerTable{
		margin:0 auto;
		width:90%;
		overflow:hidden
	}
	
	.title{
		background:black;
		text-align:center;
		margin: 0 auto;
		width:100%;
		color:white;
		position: relative;
		overflow: hidden;
		margin: 5px;
	}
	
	.reservation {
		border-radius:10%;
		float: left;
		background: skyblue;
		width: 125px;
		height: 80px;
		color: white;
		text-align:center;
		margin: 5px;
	}
	.cannotReservation {
		border-radius:10%;
		float: left;
		background:orange;
		width: 125px;
		height: 80px;
		color: white;
		text-align:center;
		margin: 5px;
	}
	.visibleAlways a{
	
		text-decoration:none;
		color:white;
	}
	.hiddenInMobile a{
		text-decoration:none;
		color:black;
	}
	}
	@media screen and (max-width: 760px){
		body{
			font-size:11px;
		}
		.container p{
			font-size:calc(1.525rem + 3.3vw);
			font-weight:150;
			line-height:1.2;
		}
		.text-center p{
			font-size:calc(1.2rem + 2.2vw);
			font-weight:120;
			line-height:1.2;
		}
		.tableNum{
		background:ivory;
		color: black;
		text-align:center;
		width:100%;
	}
	.containerTable{
		margin:0 auto;
		width:100%;
		
	}
	
	.title{
		background:black;
		text-align:center;
		margin: 0 auto;
		width:100%;
		color:white;
		position: relative;
		overflow: hidden;
		margin: 5px;
	}
	
	
	.reservation {
		border-radius:10%;
		float:left;
		border: 1px solid black;
		background: white;
		width: 18%;
		height: 4%;
		text-align:center;
		margin: 2px;
	}
	.hiddenInMobile a{
		display:none;
	}
	.cannotReservation {
		border-radius:10%;
		float:left;
		border: 1px solid black;
		width: 18%;
		height: 4%;
		background:gray;
		text-align:center;
		margin: 2px;
	}
	
	
	.visibleAlways a{
		text-decoration:none;
		color:black;
	}
	
	.hiddenInMobile a{
		display:none;
	}
	
	.visibleAlways p{
		color:black;
	}
	
	.hiddenInMobile p{
		display:none;
	}
	.visibleInMobile {
		margin-left:5%;
	}
	
	.visibleInMobile *{
		display:inline-block;
	}
	
	.cannotColor{
		width:8px;
		height:8px;
		background:gray;
		border: 1px solid black;
	}
	
	
	}
	</style>
	
	<title>예약 조회</title>
</head>
<body>
<%@ include file="../menu.jsp" %>
	<% String greeting = "테이블 별 예약 가능 시간";
	
	String tagline;
	if(request.getParameter("date")==null){
		tagline = "오늘";
	}
	else{
	tagline = request.getParameter("date");
	}%>
	<div class = "jumbotron">
		<div class = "container">
			<p><%= greeting %></p>
			
		</div>
	</div>
	<div class = "text-center">
			<p>
				<%= tagline %> 예약 목록
			</p>
	</div>
	<div class="visibleInMobile">
		<div class="cannotColor"></div><div>예약불가</div>
	</div>
<%@ include file="./connection.jsp" %>
	<%
	int reservationNum = 0;
	int tableNum = 0;
	int operatingHour = 20;//30분 단위로 출력할 것이므로 시간 * 2 를 해준 값이다.
	int openTime = 11;
	int overTime = 21;
	Statement stmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	ResultSet rs2 = null;
	
	
	String sql = "SELECT * FROM operatingHour";
	stmt=conn.createStatement();
	rs = stmt.executeQuery(sql);
	while(rs.next()){
		openTime = rs.getInt("open_time");
		overTime = rs.getInt("over_Time");
	}
	
	operatingHour = (overTime - openTime) * 2;
	
	stmt= conn.createStatement();
	sql = "select * from `Table` order by number desc limit 1";
	rs = stmt.executeQuery(sql);
	while(rs.next()){
		tableNum = Integer.valueOf(rs.getString("number"));
	}
	
	Date date;
	LocalDate todaysDate = LocalDate.now();
	
	if(request.getParameter("date")==null){
		date = Date.valueOf(todaysDate);
	}
	else{
		date = java.sql.Date.valueOf(request.getParameter("date"));
	}
	
	String sql2 = "select * from Reservation where date=? and table_id = ? order by time";//해당 날짜, 테이블 번호의 예약내역
	
	boolean flag[][] = new boolean[tableNum][operatingHour];//예약 가능 여부를 판단하는 flag
	for(int i = 0; i < tableNum; i++){
		for(int j = 0; j < operatingHour ; j++){
			flag[i][j] = true;//먼저 true로 설정해준다.
		}
	}
		
	
	for(int i = 1; i <= tableNum; i++){
		pstmt = null;
		pstmt = conn.prepareStatement(sql2);
		pstmt.setDate(1,date);
		pstmt.setInt(2,i);
		rs2 = pstmt.executeQuery();
		int j = 0;
		int x = 0;
		while(rs2.next()){
			String time = rs2.getString("time");
			String[] timeSet = time.split(":");
			StringTokenizer st = new StringTokenizer(time,":");
			time = st.nextToken();//hh:mm:ss에서 hh, 시간을 받아온다
			String minute = st.nextToken();
			int intTime = Integer.valueOf(timeSet[0]) - openTime; //11시가 오픈타임으로 가정
			
			if(timeSet[1].equals("00")){//해당 시간 정각에 예약이 있다면
				if (intTime==0){
				flag[i-1][intTime] = false; //오픈 시간 예약이라면
				flag[i-1][intTime+1] = false;//30분 후의 예약 비활성화
				}
				else{
					flag[i-1][2*intTime] = false;
					flag[i-1][2*intTime-1] = false;//30분 전의 예약 비활성화
					flag[i-1][2*intTime+1] = false;//30분 후의 예약 비활성화
				}
			}
			else if(timeSet[1].equals("30")){//30분에 예약이 있다면
				
				//intTime은 똑같지만 30분 예약이므로 intTime(intTime:00:00)과 자기자신(intTime:30:00), 30분 후의 예약 비활성화	
				flag[i-1][2*intTime] = false;//30분 전의 예약 비활성화
				flag[i-1][2*intTime+1] = false;
				flag[i-1][2*intTime+2] = false;//30분 후의 예약 비활성화
			
			}
			x+=2;
		}
		
		if(pstmt!=null)
			pstmt.close();
	}
	%>
	<div class="containerTable">
	<%for(int i = 1; i <= tableNum; i++){
		int x=0;
	%>
	<div class="title">
		<div class="tableNum"><%=i %>번 테이블</div>
		<%for(int j = 0; j < operatingHour; j++){
			%>
		<%if(flag[i-1][j]==true){%>
			<div class="reservation">
			<%if(j%2==0){%>
				<div class="visibleAlways"><a href="./CustomerReservation.jsp?date=<%=date %>&tableNum=<%=i %>&time=<%=j+openTime-x %>:00:00"><%=j+openTime-x %>:00</a></div>
				<div class="hiddenInMobile">
				<a href="./CustomerReservation.jsp?date=<%=date %>&tableNum=<%=i %>&time=<%=j+openTime-x %>:00:00" class="btn btn-secondory" role="button">
							예약하기 &raquo;></a></div>
			<%
			x++;//j가 정각을 나타낼 때 2씩 증가하므로 그에 맞춰 x를 1씩 증가시킨다.
			}
			else{%>
				<div class="visibleAlways"><a href="./CustomerReservation.jsp?date=<%=date %>&tableNum=<%=i %>&time=<%=j+openTime-x %>:30:00"><%=j+openTime-x %>:30</a></div>
				<div class="hiddenInMobile">
				<a href="./CustomerReservation.jsp?date=<%=date %>&tableNum=<%=i %>&time=<%=j+openTime-x %>:30:00" class="btn btn-secondory" role="button">
							예약하기 &raquo;></a></div>
				
			<% }%>
			</div>
		<%	
		}
		else{%>
		<div class="cannotReservation">
			<%if(j%2==0){%>
				<div class="visibleAlways"><%=j+openTime-x %>:00</div>
				<div class="hiddenInMobile"><p>예약 불가능<br></p></div>
			<%
			x++;//j가 정각을 나타낼 때 2씩 증가하므로 그에 맞춰 x를 1씩 증가시킨다.
			}
			else{%>
				<div class="visibleAlways"><%=j+openTime-x %>:30<br></div>
				<div class="hiddenInMobile"><p>예약 불가능<br></p></div>
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
	if(conn!=null)
		conn.close();
	%>

</body>
</html>