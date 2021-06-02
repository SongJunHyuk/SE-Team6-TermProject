package booksys.application.persistency;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.StringTokenizer;

public class Statistics {
	
	  public void reservationTotalCount() // 전체이용횟수 출력 메소드
	  {
		  request.setCharacterEncoding("UTF-8");
		  
		  PreparedStatement pstmt = null;
		  ResultSet rs = null;
		  
		  int totalCount = 0;
		  
		  String sql = "select * from reservation";
		  pstmt = conn.createStatement();
		  rs = pstmt.executeQuery(sql);
		  
		  while(rs.next()){
				 totalCount++;// totalCount로 총 이용횟수 기록
		  }
		  
		  rs.close();
		  pstmt.close();
		  
		  out.println(totalCount); // 출력할 변수 = totalCount (return 할 값)
		  
		  
	  }
	  
	  public void reservationMonthCount()
	  {
		  request.setCharacterEncoding("UTF-8");
		  
		  PreparedStatement pstmt = null;
		  ResultSet rs = null;
		  String data;
		  String token;
		  
		  int N = 12; // Month 설정
		  int[] monthArray = new int[N+1]; // 매달 마다의 사용횟수를 기록하는 자료구조
		  
		  for(int i = 0; i<=N; i++) // 자료구조 초기화
			  monthArray[i] = 0;
		  
		  String sql = "select date from reservation";
		  pstmt = conn.createStatement();
		  rs = pstmt.executeQuery(sql);
		  
		  
		  while(rs.next()){
			  data = rs.getString("date");
			  StringTokenizer st = new StringTokenizer(data, "-");
			  token = st.nextToken();
			  
			  if(token != "10") // 10월을 제외하고 01, 02, ... 등에대한 앞글자 0 을 제거한다.
				  token = token.replace("0","");
			  
			  int monthData = Integer.parseInt(token); // 월 에 대한 string을 최종적으로 monthData라는 변수에 int형으로 저장
			  
			  monthArray[monthData]++;
		  }

		  for(int i = 1; i <= N; i++) {
			  out.println(monthArray[i]);  // return 할 값 = monthArray[1...12]
		  }
		  
		  rs.close();
		  pstmt.close();
	  }
	
	  public void tableRank() // 테이블 선호도
	  {
		  request.setCharacterEncoding("UTF-8");
		  
		  int tableNum = 0;
		  int N = 10; // table 개수 설정
		  int[] arr = new int[N]; // table이 얼마나 호출되었는지에 대한 자료구조
		  
		  for(int i = 0; i<N; i++) // 자료구조 초기화
			  arr[i] = 0;
		  
		  PreparedStatement pstmt = null;
		  ResultSet rs = null;
		  
		  String sql = "select table_id from reservation";
		  pstmt = conn.createStatement();
		  rs = pstmt.executeQuery(sql);
		  
		  while(rs.next()){
			  tableNum = rs.getInt("table_id"); // totalCount로 총 이용횟수 기록
			  for(int i = 1; i <=10; i++) {
				  if(tableNum == i) {
					  arr[i-1]++;
				  }
			  }
		  }
		  
		  for(int i=0; i < N; i++) { // 선택정렬로 table 순서 오름차순으로 설정
				for(int j=i+1; j< N; j++) {
					if(arr[i] > arr[j]) {
						int tmp = arr[i];
						arr[i] = arr[j];
						arr[j] = tmp;
					}
				}
		  }
		  
		  int first = arr[0]; // return 값
		  int second = arr[1]; // return 값
		  int third = arr[2]; // return 값
		  
		  rs.close();
		  pstmt.close();
	  }
	
	public void customerInfo() // 고객정보 출력 메소드
	{
		  request.setCharacterEncoding("UTF-8");
		  
		  PreparedStatement pstmt = null;
		  Statement stmt = null;
		  Statement stmt2 = null;
		  ResultSet rs = null;
		  ResultSet rs2 = null;
		  
		  boolean existanceReservation = false;
		  
		  int oid = 0;
		  String name;
		  String phoneNumber;
		  int mileage;
		  int listCount = 0;
		  
		  String sqlLast = "select oid from customer";
		  stmt = conn.createStatement();
		  rs =  stmt.executeQuery(sqlLast);
		  
		  while(rs.next()) { // 자료의 개수
			  listCount = rs.getInt("oid");
		  }
		  
		  int[] countArray = new int[listCount+1]; // 고객의 이용횟수를 저장하는 자료구조
		  
		  for(int i = 0; i<=listCount; i++) // 자료구조 초기화
			  countArray[i] = 0;
		  
		  String sql = "select * from reservation";
		  String sql2 = "select * from reservation where customer_id=?";
		  pstmt = conn.createStatement();
		  rs = stmt2.executeQuery(sql);
		  rs2 = pstmt.executeQuery(sql2);
		  
		  for(oid = 1; oid <= listCount; oid++ ) {
			  pstmt.setInt(1,oid);

			  int cusCount = 0;
			  
			  while(rs2.next()) {
				  cusCount++;
			  }
			  countArray[oid] = cusCount; // countArray[oid]에 사용횟수 저장
		  }
		  
		  while(rs.next()) { // 정보출력
			  oid = rs.getInt("oid");
			  name = rs.getString("name");
			  phoneNumber = rs.getString("phoneNumber");
			  mileage = rs.getInt("mileage");
			  
			  out.println(oid + " " + name + " " + phoneNumber + " " + mileage + " " + countArray[oid] ); // return 할 값 oid, 이름, 전화번호, 마일리지, 이용횟수
			  existanceReservation = true;
		  }
		  
		  if(existanceReservation==false) // 정보가 없음
			  out.println("등록된 정보가 없습니다.");
		  
		  rs.close();
		  rs2.close();
		  pstmt.close();
		  stmt.close();
		  
	}
}
