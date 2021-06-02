package booksys.application.persistency;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.StringTokenizer;

public class Statistics {
	
	  public void reservationTotalCount() // ��ü�̿�Ƚ�� ��� �޼ҵ�
	  {
		  request.setCharacterEncoding("UTF-8");
		  
		  PreparedStatement pstmt = null;
		  ResultSet rs = null;
		  
		  int totalCount = 0;
		  
		  String sql = "select * from reservation";
		  pstmt = conn.createStatement();
		  rs = pstmt.executeQuery(sql);
		  
		  while(rs.next()){
				 totalCount++;// totalCount�� �� �̿�Ƚ�� ���
		  }
		  
		  rs.close();
		  pstmt.close();
		  
		  out.println(totalCount); // ����� ���� = totalCount (return �� ��)
		  
		  
	  }
	  
	  public void reservationMonthCount()
	  {
		  request.setCharacterEncoding("UTF-8");
		  
		  PreparedStatement pstmt = null;
		  ResultSet rs = null;
		  String data;
		  String token;
		  
		  int N = 12; // Month ����
		  int[] monthArray = new int[N+1]; // �Ŵ� ������ ���Ƚ���� ����ϴ� �ڷᱸ��
		  
		  for(int i = 0; i<=N; i++) // �ڷᱸ�� �ʱ�ȭ
			  monthArray[i] = 0;
		  
		  String sql = "select date from reservation";
		  pstmt = conn.createStatement();
		  rs = pstmt.executeQuery(sql);
		  
		  
		  while(rs.next()){
			  data = rs.getString("date");
			  StringTokenizer st = new StringTokenizer(data, "-");
			  token = st.nextToken();
			  
			  if(token != "10") // 10���� �����ϰ� 01, 02, ... ����� �ձ��� 0 �� �����Ѵ�.
				  token = token.replace("0","");
			  
			  int monthData = Integer.parseInt(token); // �� �� ���� string�� ���������� monthData��� ������ int������ ����
			  
			  monthArray[monthData]++;
		  }

		  for(int i = 1; i <= N; i++) {
			  out.println(monthArray[i]);  // return �� �� = monthArray[1...12]
		  }
		  
		  rs.close();
		  pstmt.close();
	  }
	
	  public void tableRank() // ���̺� ��ȣ��
	  {
		  request.setCharacterEncoding("UTF-8");
		  
		  int tableNum = 0;
		  int N = 10; // table ���� ����
		  int[] arr = new int[N]; // table�� �󸶳� ȣ��Ǿ������� ���� �ڷᱸ��
		  
		  for(int i = 0; i<N; i++) // �ڷᱸ�� �ʱ�ȭ
			  arr[i] = 0;
		  
		  PreparedStatement pstmt = null;
		  ResultSet rs = null;
		  
		  String sql = "select table_id from reservation";
		  pstmt = conn.createStatement();
		  rs = pstmt.executeQuery(sql);
		  
		  while(rs.next()){
			  tableNum = rs.getInt("table_id"); // totalCount�� �� �̿�Ƚ�� ���
			  for(int i = 1; i <=10; i++) {
				  if(tableNum == i) {
					  arr[i-1]++;
				  }
			  }
		  }
		  
		  for(int i=0; i < N; i++) { // �������ķ� table ���� ������������ ����
				for(int j=i+1; j< N; j++) {
					if(arr[i] > arr[j]) {
						int tmp = arr[i];
						arr[i] = arr[j];
						arr[j] = tmp;
					}
				}
		  }
		  
		  int first = arr[0]; // return ��
		  int second = arr[1]; // return ��
		  int third = arr[2]; // return ��
		  
		  rs.close();
		  pstmt.close();
	  }
	
	public void customerInfo() // ������ ��� �޼ҵ�
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
		  
		  while(rs.next()) { // �ڷ��� ����
			  listCount = rs.getInt("oid");
		  }
		  
		  int[] countArray = new int[listCount+1]; // ���� �̿�Ƚ���� �����ϴ� �ڷᱸ��
		  
		  for(int i = 0; i<=listCount; i++) // �ڷᱸ�� �ʱ�ȭ
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
			  countArray[oid] = cusCount; // countArray[oid]�� ���Ƚ�� ����
		  }
		  
		  while(rs.next()) { // �������
			  oid = rs.getInt("oid");
			  name = rs.getString("name");
			  phoneNumber = rs.getString("phoneNumber");
			  mileage = rs.getInt("mileage");
			  
			  out.println(oid + " " + name + " " + phoneNumber + " " + mileage + " " + countArray[oid] ); // return �� �� oid, �̸�, ��ȭ��ȣ, ���ϸ���, �̿�Ƚ��
			  existanceReservation = true;
		  }
		  
		  if(existanceReservation==false) // ������ ����
			  out.println("��ϵ� ������ �����ϴ�.");
		  
		  rs.close();
		  rs2.close();
		  pstmt.close();
		  stmt.close();
		  
	}
}
