<%@page import ="java.sql.SQLException" %>
<%@page import ="java.sql.DriverManager"%>
<%@page import ="java.sql.Statement"%>
<%@page import ="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>

<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="error_buy.jsp" %>
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
	
	<title>로도스 플레임 왕국 데이터 베이스 페이지 - 마법사 정보 수정 결과</title>
</head>
<body>
	<%
		String dbName = "chanil";
		String jdbcDriver = "jdbc:mariadb://localhost:3306/" + dbName;
		String dbUser = "root";
		String dbPass = "235711";
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet result = null;

		int logined_id = (Integer) (session.getAttribute("logined_id"));

		


			try {

				request.setCharacterEncoding("EUC-KR");

				int magicianid = Integer.parseInt(request.getParameter("magicianid"));
				int magicclass = Integer.parseInt(request.getParameter("magicclass"));

				String add_value_magician = "INSERT INTO belongto_information(magicianid, magicfirmid) VALUES ("+magicianid+", "+logined_id+")";

				String driver = "org.mariadb.jdbc.Driver";
				Class.forName(driver);
				conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
				stmt = conn.createStatement();

				String query = "SELECT permissionclass FROM magicfirm_information WHERE magicfirmid ="+logined_id+" ";
				result = stmt.executeQuery(query);

				while(result.next()){
					int permissionclass = result.getInt("permissionclass");

					if(magicclass >= permissionclass){
						stmt.executeUpdate(add_value_magician);

						%>

							<div class="container">
							<div id="title_part">
								<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
								<hr class="my-4">
							</div>
							<div class="p-3 mb-2 bg-light text-dark rounded border" id="content_wrap"> 
								<div class="alert alert-primary" role="alert"> 해당 마법사가 상회에 영입되었습니다.
								</div>
								<div>
									<h2><strong> 영입 처리 성공 </strong></h2>
									<p><strong> 귀하의 요청이 정상적으로 다음과 같이 수행되었습니다. : </strong></p>
									<p><strong> <%=add_value_magician%> </strong> </p>	
								</div>
								<button type="button" class="btn btn-secondary btn-lg" onClick="history.go(-1)">이전 페이지로 돌아가기</button>
							</div>				
						</div> 

						<%
					} else {
						%>

						<div class="container">
							<div id="title_part">
								<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
								<hr class="my-4">
							</div>
							<div class="p-3 mb-2 bg-light text-dark rounded border" id="content_wrap"> 
								<div>
									<h2><strong> 영입 처리 실패 </strong></h2>
									<p><strong> 해당 마법사가 상회의 클래스 수준을 충족하지 못해 영입하지 못했습니다.</strong></p>
								</div>
								<button type="button" class="btn btn-secondary btn-lg" onClick="history.go(-1)">이전 페이지로 돌아가기</button>
							</div>				
						</div>
					<%				
					}
				} 
		} catch(SQLException se) {
			se.printStackTrace();
			%>
			<div class="container">
				<div id="title_part">
					<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
					<hr class="my-4">
				</div>
				<div class="p-3 mb-2 bg-light text-dark rounded border">
					<p>죄송합니다! 입력 양식 오류입니다. 이전 페이지로 돌아가 다시 입력해주세요.</p>
					<button type="button" class="btn btn-secondary btn-lg" onClick="history.go(-1)">이전 페이지로 돌아가기</button>
				</div>
			</div>
			<%
		} finally {
			try {
				stmt.close();
				conn.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}

	%>
</body>
</html>
