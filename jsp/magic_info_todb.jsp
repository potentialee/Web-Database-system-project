<%@page import ="java.sql.SQLException" %>
<%@page import ="java.sql.DriverManager"%>
<%@page import ="java.sql.Statement"%>
<%@page import ="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>

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
	
	<title>로도스 플레임 왕국 데이터 베이스 페이지 - 마법 등록 결과</title>
</head>
<body>
	<%
			String dbName = "chanil";
			String jdbcDriver = "jdbc:mariadb://localhost:3306/" + dbName;
			String dbUser = "root";
			String dbPass = "235711";
			String query = "SELECT MAX(magicid) FROM magic_information; ";

			Connection conn = null;
			Statement stmt = null;
			ResultSet result = null;

		try {
				request.setCharacterEncoding("EUC-KR");
				
				// 마법 정보 파라미터 가져오기
				String magicname = request.getParameter("magicname");
				String magicexplanation = request.getParameter("magicexplanation");
				int magicclass = Integer.parseInt(request.getParameter("magicclass"));
				String magicattribute = request.getParameter("magicattribute");
				String magictype = request.getParameter("magictype");
				int effectivedose = Integer.parseInt(request.getParameter("effectivedose"));
				int sellingprice = Integer.parseInt(request.getParameter("sellingprice"));
				int manaconsume = Integer.parseInt(request.getParameter("manaconsume"));
				int createrid = Integer.parseInt(request.getParameter("createrid"));

				// 기본 재료 정보 파라미터 가져오기 (필수 1개 정보)
				int ingredientid1 = Integer.parseInt(request.getParameter("ingredientid1"));
				int needs1 = Integer.parseInt(request.getParameter("needs1"));

				int ingredientid2 = 0;
				int needs2 = 0;

				int ingredientid3 = 0;
				int needs3 = 0;

				// 재료 체크박스 정보 가져오기 
				String ingredient_check1 = request.getParameter("ingredient-2");
				String ingredient_check2 = request.getParameter("ingredient-3");
				

				// 재료 체크박스 조건문
				if (ingredient_check1 != null && ingredient_check1.equals("on") ){
					ingredientid2 = Integer.parseInt(request.getParameter("ingredientid2"));
					needs2 = Integer.parseInt(request.getParameter("needs2"));
				}

				if (ingredient_check2 != null && ingredient_check2.equals("on") ){
					ingredientid3 = Integer.parseInt(request.getParameter("ingredientid3"));
					needs3 = Integer.parseInt(request.getParameter("needs3"));
				}

				// 마법 정보 DB에 입력
				String insert_value_to_magic = "INSERT INTO magic_information(magicname, magicexplanation, magicclass, magicattribute,magictype,effectivedose,manaconsume,sellingprice,createrid) values ('"+ magicname +"', '"+ magicexplanation +"', "+ magicclass +", '"+ magicattribute +"' , '"+ magictype +"' , "+ effectivedose +" , " + manaconsume + " , "+ sellingprice +", "+ createrid + " );";


				String driver = "org.mariadb.jdbc.Driver";
				Class.forName(driver);
				conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
				stmt = conn.createStatement();
				stmt.executeUpdate(insert_value_to_magic);

				result = stmt.executeQuery(query);

				while(result.next()) {

					int magicid = result.getInt("MAX(magicid)");

					// 재료 정보 DB에 입력
					String insert_value_to_ingredient = "INSERT INTO needs_information(magicid, ingredientid, needs) values("+ magicid +", "+ ingredientid1 +", "+ needs1 +" )";

					stmt.executeUpdate(insert_value_to_ingredient);

					if (ingredientid2 != 0 && needs2 != 0){
						String insert_value_to_ingredient2 = "INSERT INTO needs_information(magicid, ingredientid, needs) values("+ magicid +", "+ ingredientid2 +", "+ needs2 +" )";
						stmt.executeUpdate(insert_value_to_ingredient2);
					}

					if (ingredientid3 != 0 && needs3 != 0){
						String insert_value_to_ingredient3 = "INSERT INTO needs_information(magicid, ingredientid, needs) values("+ magicid +", "+ ingredientid3 +", "+ needs3 +" )";
						stmt.executeUpdate(insert_value_to_ingredient3);
					}
				

			%>
				<div class="container">
					<div id="title_part">
						<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
						<hr class="my-4">
					</div>
					<div class="p-3 mb-2 bg-light text-dark rounded border" id="content_wrap"> 
						<div class="alert alert-primary" role="alert"> 작성하신 마법의 정보가 로도스의 플레임 왕국 마법 DB에 성공적으로 등록되었습니다!
						</div>
						<div id="login_result">
							<h2><strong> 데이터 베이스에 마법 정보 등록 완료 </strong></h2>
							<p><strong> 관리자님께서 작성하신 마법 정보가 데이터 베이스 <%=dbName%> 에 등록되었습니다. 수행한 SQL Statement는 다음과 같습니다 : </strong></p>
							<p><strong> <%=insert_value_to_magic%> </strong> </p>
							<p><strong> 등록된 마법의 ID는 다음과 같습니다. : <%=magicid%> </strong></p>			
						</div>
						<button type="button" class="btn btn-secondary" onClick="history.go(-2)">이전 페이지로 돌아가기</button>
					</div>				
				</div>
			<%
			}
				} catch(SQLException se) {
					se.printStackTrace();
					%>
					<div class="container">
						<div id="content_wrap">
							<div id="title_part">
								<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
								<hr class="my-4">
							</div>
							<div class="p-3 mb-2 bg-light text-dark rounded border" id="content_wrap">
								<h2><strong> 데이터 베이스에 마법 정보 등록 실패 </strong></h2>
								<p>죄송합니다! 데이터베이스에 없는 값을 입력하셨습니다.  </p>
								<button type="button" class="btn btn-secondary" onClick="history.go(-2)">이전 페이지로 돌아가기</button>
							</div>
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
