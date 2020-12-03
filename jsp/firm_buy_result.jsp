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

				int ingredientid = Integer.parseInt(request.getParameter("ingredientid"));
				int amount = Integer.parseInt(request.getParameter("amount"));
				int price = Integer.parseInt(request.getParameter("price"));

				// 상회 돈 정보를 가지고 오는 쿼리
				String query = "SELECT money from magicfirm_information where magicfirmid= "+ logined_id +"";

				String driver = "org.mariadb.jdbc.Driver";
				Class.forName(driver);
				conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
				stmt = conn.createStatement();

				result = stmt.executeQuery(query);

				while(result.next()) {
					int money = result.getInt("money");
					if(money >= (price * amount) ){
						
						// 상회 돈을 구매 소지금만큼 빼는 쿼리
						String update_value_money = "UPDATE magicfirm_information SET money = money - ("+ price +" * "+ amount +") WHERE magicfirmid = "+logined_id+" ";
						// 상회 재고 상황에 등록
						String update_or_insert_value_instock = "INSERT INTO instock_information(magicfirmid,ingredientid,instock) VALUES ("+ logined_id +", "+ ingredientid +", "+ amount +") ON DUPLICATE KEY UPDATE instock = instock + "+ amount +" ";

						stmt.executeUpdate(update_value_money);
						stmt.executeUpdate(update_or_insert_value_instock);
						%>

						<div class="container">
							<div id="title_part">
								<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
								<hr class="my-4">
							</div>
							<div class="p-3 mb-2 bg-light text-dark rounded border" id="content_wrap"> 
								<div class="alert alert-primary" role="alert"> 요청하신 구매가 정상적으로 이루어졌습니다!
								</div>
								<div>
									<h2><strong> 구매 성공 </strong></h2>
									<p><strong> 귀하께서 구매하신 요청이 정상적으로 다음과 같이 수행되었습니다. : </strong></p>
									<p><strong> <%=update_value_money%> </strong> </p>	
									<p><strong> <%=update_or_insert_value_instock%> </strong> </p>
								</div>
								<button type="button" class="btn btn-secondary btn-lg" onClick="history.go(-1)">이전 페이지로 돌아가기</button>
							</div>				
						</div> <%
					} else { %> 
							<div class="container">
								<div id="title_part">
									<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
									<hr class="my-4">
								</div>
								<div class="p-3 mb-2 bg-light text-dark rounded border" id="content_wrap"> 
									<div>
										<h2><strong> 구매 실패 </strong></h2>
										<p><strong> 귀하께서 구매하신 요청이 자금이 부족하여 실패하였습니다. : </strong></p>
									</div>
									<button type="button" class="btn btn-secondary btn-lg" onClick="history.go(-1)">이전 페이지로 돌아가기</button>
								</div>				
							</div> <%
					}

			%>
			<% }
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
