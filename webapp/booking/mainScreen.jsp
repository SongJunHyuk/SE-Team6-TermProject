<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
	
	body {
		margin: 0 auto;
		width: 90%;
	}
	
	.tableNum{
		background:black;
		width:100%;
		color: white;
		text-align: center;
		overflow: hidden;
	}
	
	.title{
		background:black;
		text-align:center;
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
		background: black;
		width: 250px;
		height: 250px;
		color: white;
		text-align:center;
		margin: 5px;
	}
	.customerName {
		color=orange;
	}
</style>
<title>Welcome</title>
<script type="text/javascript">
	function deleteConfirm(id) {
		if(confirm("해당 예약을 삭제합니다!") == true)
			location.href = "./deleteReservation.jsp?oid=" +id;
		else
			return;
	}
</script>
</head>
<body>
	
	<%@ include file="../menu.jsp" %>
	<%! String greeting = "6조 예약 관리 시스템"; 
	String tagline = "Booking Management";%>
	<div class = "jumbotron">
		<div class = "container">
			<h1 class = "display-3"><%= greeting %>
			</h1>
		</div>
	</div>
		<div class = "text-center">
			<h3>
				<%= tagline %>
			</h3>
		</div>
			<%@ include file="/connection.jsp" %>
			<%
				int tableNum = 1;
				ResultSet rs = null;
				Statement stmt = null;
				ResultSet rs2 = null;
				PreparedStatement stmt2 = null;
				ResultSet rs3 = null;
				PreparedStatement stmt3 = null;
				try{
					String sql = "select * from `Table`";
					stmt = conn.createStatement();
					rs = stmt.executeQuery(sql);
					while(rs.next()){
						tableNum++;
					}
				}catch (SQLException ex) {
					out.println("Table 테이블 호출이 실패했습니다.<br>");
				} finally {
					if(rs != null)
						rs.close();
					if(stmt != null)
						stmt.close();
				}
				%>
					
					<%
						try{
						SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd");
						Date now = new Date();
						String sql2 = "SELECT * FROM Reservation WHERE date =? order by time"; //시간 순으로 예약정보 불러 옴
						stmt2 = conn.prepareStatement(sql2);
						stmt2.setString(1,transFormat.format(now));//첫번째 ?를 현재 날짜로 설정, 즉 오늘의 예약만 불러온다.
						rs2 = stmt2.executeQuery();
						%>
						<div class="title">예약 목록</div>
						<div class="reservationContainer">
						<%
						while(rs2.next()){
							String sTime = rs2.getString("time");// 해당 예약의 예약 시간 불러옴
							String cus_id = rs2.getString("customer_id");//해당 예약의 고객 정보 불러옴
							StringTokenizer st = new StringTokenizer(sTime,":"); // 문자열로 저장 된 시간을 토큰 단위로 분리
							int iHour = Integer.parseInt(st.nextToken());//정수로 변환
							int iMinute = Integer.parseInt(st.nextToken());
						%>
							<div class="reservation">
							<b><%=iHour%>시 <%=iMinute%>분 예약<br></b>
							고객 id:<b><%=cus_id %></b> 
							<%
								
								try{
									String sql3 = "SELECT * FROM Customer WHERE oid =?";//고객 id로 고객 정보를 불러온다
									stmt3 = conn.prepareStatement(sql3);
									stmt3.setString(1,cus_id);
									rs3 = stmt3.executeQuery();
									while(rs3.next()){
							%>
								고객 이름: <b><%=rs3.getString("name")%></b><br>
								전화번호: <b><%=rs3.getString("phoneNumber")%></b><br>
								
							<% 
								} 
							} catch (SQLException ex){
									out.println(ex);
									out.println("고객 정보를 가져오는 데 실패했습니다.");
								} finally{
									if(rs3 != null)
										rs3.close();
									if(stmt3 != null)
										stmt3.close();
								}
								%>
							인원: <%=rs2.getString("covers") %><br>
							테이블 번호: <%=rs2.getString("table_id") %><br>
							이벤트: <%=rs2.getString("event")%><br>
							<a href="./updateReservation.jsp?id=<%=rs2.getString("oid") %>" class="btn btn-secondory" role="button">
							수정 &raquo;></a>
							<a href="#" onclick="deleteConfirm('<%=rs2.getString("oid")%>')" class="btn btn-secondory" role="button">
							삭제 &raquo;></a>
							</div>
						</div>
						<br>
						<% }
						}catch (SQLException ex){
							out.println(ex);
							out.println("reservation 테이블 호출이 실패했습니다.<br>");	
						}
					%> 
				
					
					<% if(conn != null);
					conn.close();
					if(rs2 != null)
						rs2.close();
					if(stmt2 != null)
						stmt2.close();
					
					%>
			
			
			
			
			<%
				Date day = new java.util.Date();
				String am_pm;
				int hour = day.getHours();
				int minute = day.getMinutes();
				int second = day.getSeconds();
				if(hour / 12 == 0){
					am_pm = "AM";
				} else{
					am_pm = "PM";
					hour = hour - 12;
				}
				String CT = hour + ":" + minute + ":" + second + " " + am_pm;
				out.println("현재 접속 시각: " + CT + "\n");
			%>
	<%@ include file="/footer.jsp" %>
</body>
</html>