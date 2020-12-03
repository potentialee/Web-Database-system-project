<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="error.jsp" %>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>

<%--세션 및 데이터베이스 정보 로드--%>
<%
	String jdbcDriver = "jdbc:mariadb://localhost:3306/chanil";
	String dbUser = "root";
	String dbPass = "235711";

	int logined_id = (Integer) (session.getAttribute("logined_id"));
	String logined_password = (String) (session.getAttribute("logined_password"));

	ResultSet result = null;
	Statement stmt = null;
	Connection conn = null;

	// 로그인 마법사 정보 가져오는 쿼리
	String query = "SELECT * FROM magicfirm_information WHERE magicfirmid = " + logined_id + " AND password = '" + logined_password + "' ";

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
	<meta name="description" content="마법세계의 데이터베이스 접속 페이지">
	<meta name="keywords" content="마법, 데이터베이스">
	<link rel="stylesheet" type="text/css" href="style_register.css" media="all">
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css" media="all">
	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.0/js/bootstrap.min.js" integrity="sha384-3qaqj0lc6sV/qpzrc1N5DC6i1VRn/HyX4qdPaiEFbn54VjQBEU341pvjz7Dv3n6P" crossorigin="anonymous"></script>
	
<title>로도스 플레임 왕국 데이터 베이스 페이지 - 상회 정보 수정</title>
</head>
<body>

	<div class="container">
		<%-- 타이틀 부분 시작 --%>
		<div id="title_part">
			<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
			<hr class="my-4">
		</div>
		<%--  타이틀 부분 끝 --%>

		<%-- 콘텐츠 부분 시작 --%>
		<div class="p-3 mb-2 bg-light text-dark rounded border">

			<%-- JDBC 시작 --%>
	  		<%
				try {
					String driver = "org.mariadb.jdbc.Driver";
					Class.forName(driver);
					conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
					stmt = conn.createStatement();
					result = stmt.executeQuery(query);

					while (result.next()) {
						String businessname = result.getString("businessname");
						String password = result.getString("password");
						String adress = result.getString("adress");
						String representative = result.getString("representative");
						int permissionclass = result.getInt("permissionclass");
						int money = result.getInt("money"); 
			%>

			<%-- JDBC 끝 --%>

			<%-- 폼 부분 시작 --%>
			<div>
				<form action="firm_modify_result.jsp" method="post">

					<div class="form-group">
						<label> <strong>상호</strong></label> <input type="text" class="form-control" name="businessname" value="<%=businessname %>" required>
					</div>

					<div class="form-group">
						<label> <strong>패스워드</strong></label> <input type="password" class="form-control" name="password" value="<%=password %>" required>
					</div>
					
					<div class="form-group">
						<label> <strong>주소</strong></label> <input type="text" class="form-control" name="adress" value="<%=adress %>"  required>
					</div>
					
					<div class="form-group">
						<label> <strong>대표자 이름</strong></label> <input type="text" class="form-control" name="representative" value="<%=representative %>" required>
					</div>
					
					<div class="form-group">
						<label> <strong>거래 허가클래스</strong></label> <input type="number" class="form-control" name="permissionclass" min="1" max="10" value="<%=permissionclass %>"  required>
					</div>

					<div class="form-group" id="last_form">
						<label> <strong>소지금</strong></label> <input type="number" class="form-control" name="money"  min="0" max="2000000000" value="<%=money %>" required>
					</div>

					<input type="submit" class="btn btn-primary" value="정보 변경">
					<button type="button" class="btn btn-secondary" onClick="history.go(-1)">이전 페이지로 돌아가기</button>
				</form>
			</div>
			<%-- 폼 부분 끝 --%>

			<%-- JDBC 시작 --%>
			<%
					}
				} catch(Exception e) {
					e.printStackTrace();
				} finally {
					try {
						result.close();
						stmt.close();
						conn.close();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			%>
			<%-- JDBC 끝 --%>

		</div>
		<%-- 컨텐츠 부분 끝 --%>
	</div>
</body>
</html>