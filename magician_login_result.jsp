<%@page import ="java.sql.DriverManager"%>
<%@page import ="java.sql.Statement"%>
<%@page import ="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>

<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="description" content="마법세계의 데이터베이스 접속 페이지">
	<meta name="keywords" content="마법, 데이터베이스">
	<link rel="stylesheet" type="text/css" href="style_result_page.css" media="all">
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css" media="all">
	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.0/js/bootstrap.min.js" integrity="sha384-3qaqj0lc6sV/qpzrc1N5DC6i1VRn/HyX4qdPaiEFbn54VjQBEU341pvjz7Dv3n6P" crossorigin="anonymous"></script>
	
	<title>로도스 플레임 왕국 데이터 베이스 페이지 - 로그인 결과</title>
</head>
<body>
	<%
			String dbName = "chanil";
			String jdbcDriver = "jdbc:mariadb://localhost:3306/" + dbName;
			String dbUser = "root";
			String dbPass = "235711";

			Connection conn = null;
			PreparedStatement preStmt = null;
			ResultSet result = null;

		try {

			int magicianid = Integer.parseInt(request.getParameter("id_info"));
			String password = request.getParameter("password_info");

			String redirect = null;

			conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);

			String query = "SELECT * FROM magician_information where magicianid = ?";
			preStmt = conn. prepareStatement(query);

			preStmt.setInt(1, magicianid);
			result = preStmt.executeQuery();
			String password_origin;
			result.next();
			password_origin = result.getString("password");

			preStmt.close();
			conn.close();
			result.close();

			if(password_origin.equals(password)){
				session.setAttribute("magicianid", magicianid);
				session.setAttribute("password", password);
				redirect ="magician_page.jsp";
			}

			if(redirect!=null){
				response.sendRedirect(redirect);
			}

			else {
				%>
					<div class="container">
						<div id="content_wrap">
							<div id="title_part">
								<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
								<hr class="my-4">
							</div>
							<div class="p-3 mb-2 bg-light text-dark rounded border">
								<p>죄송합니다! 아이디 또는 비밀번호가 틀립니다. 이전 페이지로 돌아가 다시 입력해주세요.</p>
								<button type="button" class="btn btn-secondary btn-lg" onclick="location.href='main.html'">로그인 페이지로 돌아가기</button>
							</div>
						</div>
					</div>
				<%

			}

		} catch(NumberFormatException e) {
			%>
				<div class="container">
					<div id="content_wrap">
						<div id="title_part">
							<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
							<hr class="my-4">
						</div>
						<div class="p-3 mb-2 bg-light text-dark rounded border">
							<p>죄송합니다! 잘못된 정보로 인한 오류입니다. 이전 페이지로 돌아가 다시 입력해주세요.</p>
							<button type="button" class="btn btn-secondary btn-lg" onclick="location.href='main.html'">로그인 페이지로 돌아가기</button>
						</div>
					</div>
				</div>
			<%			
		}

	%>
</body>
</html>