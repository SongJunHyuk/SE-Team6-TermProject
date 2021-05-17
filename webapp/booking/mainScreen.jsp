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
		width: 80%;
	}
	
	.tableNum{
		background:black;
		width:100%;
		color: white;
		text-align: center;
		overflow: hidden;
	}
	
	.table{
		background:black;
		width:100%;
		height: 200px;
		text-align:center;
		color:white;
		position: relative;
		overflow: hidden;
		margin: 5px;
	}
	.reservation {
		float: left;
		background: white;
		width: 200px;
		height: 140px;
		color: black;
		margin: 5px;
	}
</style>
<title>Welcome</title>
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
					String sql = "select * from `Table` ORDER BY number";
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
				
				<% for(int i=1; i< tableNum; i++){//테이블 별로 예약 내역 출력 %>
				<div class="tableNum"><%=i %>번 테이블
					<div class="table">
					<%
						try{
						SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd");
						Date now = new Date();
						String sql2 = "SELECT * FROM Reservation WHERE table_id =? AND date =?"; //해당 테이블의 예약정보 불러 옴
						stmt2 = conn.prepareStatement(sql2);
						stmt2.setString(1,Integer.toString(i));// 첫번째 ?를 테이블 번호로 설정
						stmt2.setString(2,transFormat.format(now));//두번째 ?를 현재 날짜로 설정, 즉 오늘의 예약만 불러온다.
						rs2 = stmt2.executeQuery();
						while(rs2.next()){
							String sTime = rs2.getString("time");// 해당 예약의 예약 시간 불러옴
							String cus_id = rs2.getString("customer_id"); 
							StringTokenizer st = new StringTokenizer(sTime,":"); // 문자열로 저장 된 시간을 토큰 단위로 분리
							int iHour = Integer.parseInt(st.nextToken());//정수로 변환
							int iMinute = Integer.parseInt(st.nextToken());
						%>
							<div class="reservation">
							<%=iHour%>시 <%=iMinute%>분 예약<br>
							고객 id:<%=cus_id %><br>
							<%
								
								try{
									String sql3 = "SELECT * FROM Customer WHERE oid =?";
									stmt3 = conn.prepareStatement(sql3);
									stmt3.setString(1,cus_id);
									rs3 = stmt3.executeQuery();
									while(rs3.next()){
							%>
								고객 이름: <%=rs3.getString("name")%><br>
								전화번호: <%=rs3.getString("phoneNumber")%><br>
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
							<a href="./updateReservation.jsp?id=<%=cus_id %>" class="btn btn-secondory" role="button">
							수정 &raquo;></a>
							
							</div>
						
						<% }
						}catch (SQLException ex){
							out.println(ex);
							out.println("reservation 테이블 호출이 실패했습니다.<br>");	
						}
					%> </div>
					</div>
				<%	}
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