<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%--DB 정보 입력 부분--%>
<%
	String jdbcDriver = "jdbc:mariadb://localhost:3306/chanil";
	String dbUser = "root";
	String dbPass = "235711";
	String query = "SELECT * FROM magic_information";
	String query1 = "SELECT * FROM magician_information";
	String query2 = "SELECT * FROM ingredient_information";
	String query3 = "SELECT * FROM magicfirm_information";
	String query4 = "SELECT * FROM customer_information";
	String query5 = "SELECT * FROM belongto_information";
	String query6 = "SELECT * FROM needs_information";
	String query7 = "SELECT * FROM instock_information";
	String query8 = "SELECT * FROM partner_information";

	ResultSet result = null;
	Statement stmt = null;
	Connection conn = null;
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="description" content="마법세계의 데이터베이스 접속 페이지">
	<meta name="keywords" content="마법, 데이터베이스">

	<%-- style_logined.css, bootstrap, jquery 사용 --%>
	<link rel="stylesheet" type="text/css" href="style_admin.css" media="all">
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css" media="all">
	<link rel="stylesheet" type="text/css" href="css/animate.css" media="all">

	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.0/js/bootstrap.min.js" integrity="sha384-3qaqj0lc6sV/qpzrc1N5DC6i1VRn/HyX4qdPaiEFbn54VjQBEU341pvjz7Dv3n6P" crossorigin="anonymous"></script>

	<title>로도스 플레임 왕국 데이터 베이스 페이지 - 관리자 로그인 페이지</title>
</head>
<body>
	<%-- 다른 페이지와 다르게 container가 아니라 크기 조정을 위해 content_wrap을 맨 바깥으로 감쌌음.수정 시 주의--%>
	<%-- content wrap 시작 --%>
	<div id="content_wrap">
		<%-- 제목 부분 시작 --%>
		<div id="title_part">
			<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
			<hr class="my-4">
		</div>
		<%-- 제목 부분 끝 --%>

		<%-- 콘텐츠 부분 시작 --%>
		<div class="p-3 mb-2 bg-light text-dark rounded border"> 

			<%-- 환영 팝업 시작 --%>
			<div class="alert alert-primary alert-dismissible fade show animated bounce" role="alert">
				안녕하세요, 로도스의 플레임 왕국 <strong>데이터베이스 관리자</strong>님! 로그인을 환영합니다. 새롭게 업데이트된 정보를 확인하세요.
 				<button type="button" class="close" data-dismiss="alert" aria-label="Close">
    			<span aria-hidden="true">&times;</span>
  				</button>
			</div>
			<%-- 환영 팝업 끝 --%>

			<%-- 명언 블럭 부분 시작 --%>
			<div class="jumbotron">
				<blockquote class="blockquote">
  				<p class="mb-0"> "마법의 발전은 모두에게 나누어질 때 비로소 이루어진다." </p>
 				<footer class="blockquote-footer"> 플레임 왕국 국왕 카슈 알그나, <cite title="Source Title"> 마법의 서 3장 22절 </cite></footer>
				</blockquote>
			</div>
			<%-- 명언 블럭 부분 끝 --%>

			<%-- 자바스크립트 탭 리스트 부분 시작 --%>
			<%-- href로 이어져있으니 div의 id속성을 지우지 말것. --%>
			<div id="tap_list">
				<ul class="nav nav-tabs" id="myTab" role="tablist">
	  				<li class="nav-item">
	    				<a class="nav-link active" id="admin_main-tab" data-toggle="tab" href="#admin_main" role="tab" aria-controls="admin-main" aria-selected="true">관리 패널</a>
	  				</li>
	  				<li class="nav-item">
	    				<a class="nav-link" id="database_info-tab" data-toggle="tab" href="#database_magic" role="tab" aria-controls="database_info" aria-selected="false">마법</a>
	 				</li>
	  				<li class="nav-item">
	    				<a class="nav-link" id="database_modify-tab" data-toggle="tab" href="#database_magician" role="tab" aria-controls="database_modify" aria-selected="false">마법사</a>
	  				</li>
	  				<li class="nav-item">
						<a class="nav-link" id="database_ingredient-tab" data-toggle="tab" href="#database_ingredient" role="tab" aria-controls="database_ingredient" aria-selected="false">재료</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" id="database_firm-tab" data-toggle="tab" href="#database_firm" role="tab" aria-controls="database_firm" aria-selected="false">마법 상회</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" id="database_customer-tab" data-toggle="tab" href="#database_customer" role="tab" aria-controls="database_customer" aria-selected="false">고객</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" id="database_belongto-tab" data-toggle="tab" href="#database_belongto" role="tab" aria-controls="database_belongto" aria-selected="false">마법사-상회</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" id="database_needs-tab" data-toggle="tab" href="#database_needs" role="tab" aria-controls="database_needs" aria-selected="false">마법-재료</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" id="database_partner-tab" data-toggle="tab" href="#database_partner" role="tab" aria-controls="ddatabase_partner" aria-selected="false">고객-상회</a>
					</li>
				</ul>	
			</div>
			<%-- 자바스크립트 탭 리스트 부분 끝 --%>

			<%-- 자바스크립트 탭 내용 부분 시작 --%>
			<div class="tab-content" id="myTabContent">
				<%-- 탭 첫 번째 내용 부분 시작, float에 의한 clearfix 처리했음. --%>
 				<div class="tab-pane fade show active clearfix" id="admin_main" role="tabpanel" aria-labelledby="admin_main-tab">
 					
 					<%-- 관리자 정보 NAV --%>
					<nav class="navbar navbar-light" style="background-color: #e3f2fd;" id="admin_info_nav">
					  <span class="navbar-brand mb-0 h1"><strong>플레임 왕국 데이터 베이스 관리자 정보</strong></span>
					</nav>

					<%-- 프로필 이미지 카드 --%>
 					<div class="card" id="adprofile_card">
					  <img src="img/profile.jpg" class="card-img-top" alt="profile">
					  <div class="card-body">
					    <p id="carddescribe" class="card-text"><strong>찬일 전, 여명의 태양</strong> <br> <strong>Chanil Jeon <br> the sun of dawn</strong>  </p>
					  </div>
					</div>

					<%-- 탭 첫 번째 내용 테이블 시작 --%>
 					<div id="admin_info_table">
 						
 						<table class="table">
						  <thead class="thead-light">
						    <tr>
						      <th scope="col">카테고리</th>
						      <th scope="col">정보</th>
						    </tr>
						  </thead>
						  <tbody>
						    <tr>
						      <th scope="row">이름</th>
						      <td>찬일 전, 여명의 태양</td>
						    </tr>
						    <tr>
						      <th scope="row">나이</th>
						      <td>112</td>
						    </tr>
						    <tr>
						      <th scope="row">종족</th>
						      <td>하프-엘프(인간)</td>
						    </tr>
						    <tr>
						      <th scope="row">출신지</th>
						      <td>네버윈터</td>
						    </tr>
						    <tr>
						      <th scope="row">직업</th>
						      <td>데이터베이스 관리자</td>
						    </tr>
						    <tr>
						      <th scope="row">클래스</th>
						      <td>10</td>
						    </tr>
						    <tr>
						      <th scope="row">속성</th>
						      <td>불</td>
						    </tr>
						    <tr>
						      <th scope="row">마나량</th>
						      <td>1,250,236</td>
						    </tr>
						  </tbody>
						</table>
 					</div>
 					<%-- 탭 첫 번째 내용 테이블 끝 --%>

 					<%-- 관리자 정보 NAV2 --%>
 					<nav class="navbar navbar-light" style="background-color: #e3f2fd;" id="admin_info_nav2">
					  <span class="navbar-brand mb-0 h1"><strong>관리자 기능</strong></span>
					</nav>

					<%-- 재료 데이터 정보 생성 카드 --%>
					<div class="card" id="ingredient_new_card" >
					  <img src="img/ingredient.jpg" class="card-img-top" alt="ingredient">
					  <div class="card-body">
					    <h5 class="card-title">새로운 재료 추가</h5>
					    <p class="card-text">왕국 마법부에서 새롭게 인가한 재료의 목록이 들어왔다면, 데이터베이스에 추가해주세요.</p>
					    <a href="ingredient_add.jsp" class="btn btn-primary">새로운 재료 등록</a>
					  </div>
					</div>

					<%-- 마법 데이터 정보 생성 카드 --%>
					<div class="card" id="magic_new_card" >
					  <img src="img/magic.png" class="card-img-top" alt="magic">
					  <div class="card-body">
					    <h5 class="card-title">새로운 마법 추가</h5>
					    <p class="card-text">왕국 마법부에서 새롭게 인가한 마법의 목록이 들어왔다면, 데이터베이스에 추가해주세요.</p>
					    <a href="magic_add.jsp" class="btn btn-primary">새로운 마법 등록</a>
					  </div>
					</div>

					<%-- 데이터 수정/삭제 카드 --%>
					<div class="card" id="update_delete_card" >
					  <img src="img/edit.png" class="card-img-top" alt="editordelete">
					  <div class="card-body">
					    <h5 class="card-title">정보 수정/삭제</h5>
					    <p class="card-text">잘못된 정보가 있나요? 그럼 이 메뉴를 통해 수정하거나 삭제하세요. (UPDATE / DELETE문 등 SQL문 사용)</p>
					    <a href="admin_page.jsp" class="btn btn-primary">SQL문 입력하기</a>
					  </div>
					</div>

 					<%-- Clearfix를 위한 footer div이다. Float을 사용하므로 반드시 이 위에 위치해야함.--%>
 					<div id="footer"> </div>

 				</div>
 				<%-- 탭 첫 번째 내용 부분 끝 --%> 

 				<%-- 탭 두 번째 내용 부분 시작 --%>
  				<div class="tab-pane fade" id="database_magic" role="tabpanel" aria-labelledby="database_magic-tab">
  					<%-- 탭 두 번째 내용 테이블 시작 --%>
  					<div id="magic_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">ID</th>
	  								<th scope="col">이름</th>
	  								<th scope="col">설명</th>
	  								<th scope="col">클래스</th>
	  								<th scope="col">속성</th>
	  								<th scope="col">종류</th>
	  								<th scope="col">효과량</th>
	  								<th scope="col">마나 소비</th>
	  								<th scope="col">가격</th>
	  								<th scope="col">창조자ID</th>
	  							</tr>
	  						</thead>

	  						<%-- JDBC 시작 --%>
	  						<%
								try {
								String driver = "org.mariadb.jdbc.Driver";
								Class.forName(driver);
								conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
								stmt = conn.createStatement();
								result = stmt.executeQuery(query);

								while (result.next()) {
									int magicid = result.getInt("magicid");
									String magicname = result.getString("magicname");
									String magicexplanation = result.getString("magicexplanation");
									int magicclass = result.getInt("magicclass");
									String magicattribute = result.getString("magicattribute");
									String magictype = result.getString("magictype");
									int effectivedose = result.getInt("effectivedose");
									int manaconsume = result.getInt("manaconsume");
									int sellingprice = result.getInt("sellingprice");
									int createrid = result.getInt("createrid"); 
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=magicid%></td>
									<td><%=magicname%></td>
									<td><%=magicexplanation%></td>
									<td><%=magicclass%></td>
									<td><%=magicattribute%></td>
									<td><%=magictype%></td>
									<td><%=effectivedose%></td>
									<td><%=manaconsume%></td>
									<td><%=sellingprice%></td>
									<td><%=createrid%></td>
								</tr>
							</tbody>
							

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

	  					</table>
  					</div>
  					<%-- 탭 두 번째 내용 테이블 끝 --%>
  				</div>
  				<%-- 탭 두 번째 내용 부분 끝 --%>

  				<%-- 탭 세 번째 내용 부분 시작 --%>
 				<div class="tab-pane fade" id="database_magician"  role="tabpanel" aria-labelledby="database_magician-tab">
 					<%-- 탭 세 번째 내용 테이블 시작 --%>
 					<div id="magician_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">ID</th>
	  								<th scope="col">패스워드</th>
	  								<th scope="col">이름</th>
	  								<th scope="col">나이</th>
	  								<th scope="col">종족</th>
	  								<th scope="col">출신지</th>
	  								<th scope="col">직업</th>
	  								<th scope="col">클래스</th>
	  								<th scope="col">속성</th>
	  								<th scope="col">마나량</th>
	  								<th scope="col">소지금</th>
	  							</tr>
	  						</thead>

	  						<%-- JDBC 시작 --%>
	  						<%
								try {
								String driver = "org.mariadb.jdbc.Driver";
								Class.forName(driver);
								conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
								stmt = conn.createStatement();
								result = stmt.executeQuery(query1);

								while (result.next()) {
									int magicianid = result.getInt("magicianid");
									String password = result.getString("password");
									String magicianname = result.getString("magicianname");
									int age = result.getInt("age");
									String tribe = result.getString("tribe");
									String hometown = result.getString("hometown");
									String job = result.getString("job");
									int magicclass = result.getInt("magicclass");
									String magicattribute = result.getString("magicattribute");
									int manacount = result.getInt("manacount");
									int money = result.getInt("money"); 
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=magicianid%></td>
									<td><%=password%></td>
									<td><%=magicianname%></td>
									<td><%=age%></td>
									<td><%=tribe%></td>
									<td><%=hometown%></td>
									<td><%=job%></td>
									<td><%=magicclass%></td>
									<td><%=magicattribute%></td>
									<td><%=manacount%></td>
									<td><%=money%></td>
								</tr>
							</tbody>
							

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
	  					</table>
  					</div>
  					<%-- 탭 세 번째 내용 테이블 끝 --%>
 				</div>
 				<%-- 탭 세 번째 내용 부분 끝 --%>

 				<%-- 탭 네 번째 내용 부분 시작 --%>
 				<div class="tab-pane fade" id="database_ingredient" role="tabpanel" aria-labelledby="database_ingredient-tab">
 					<%-- 탭 네 번째 내용 테이블 시작 --%>
 					<div id="ingredient_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">ID</th>
	  								<th scope="col">이름</th>
	  								<th scope="col">원산지</th>
	  								<th scope="col">종류</th>
	  								<th scope="col">가격</th>
	  							</tr>
	  						</thead>

	  						<%-- JDBC 시작 --%>
	  						<%
								try {
								String driver = "org.mariadb.jdbc.Driver";
								Class.forName(driver);
								conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
								stmt = conn.createStatement();
								result = stmt.executeQuery(query2);

								while (result.next()) {
									int ingredientid = result.getInt("ingredientid");
									String ingredientname = result.getString("ingredientname");
									String origin = result.getString("origin");
									String kinds = result.getString("kinds");
									int price = result.getInt("price"); 
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=ingredientid%></td>
									<td><%=ingredientname%></td>
									<td><%=origin%></td>
									<td><%=kinds%></td>
									<td><%=price%></td>
								</tr>
							</tbody>
							

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
	  					</table>
  					</div>
  					<%-- 탭 네 번째 내용 테이블 끝 --%>

 				</div>
 				<%-- 탭 네 번째 내용 부분 끝 --%>

 				<%-- 탭 다섯 번째 내용 부분 시작 --%>
 				<div class="tab-pane fade" id="database_firm" role="tabpanel" aria-labelledby="database_firm-tab">
 					<%-- 탭 다섯 번째 내용 테이블 시작 --%>
 					<div id="magicfirm_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">ID</th>
	  								<th scope="col">패스워드</th>
	  								<th scope="col">상호</th>
	  								<th scope="col">주소</th>
	  								<th scope="col">대표자 이름</th>
	  								<th scope="col">거래 허가 클래스</th>
	  								<th scope="col">소지금</th>
	  							</tr>
	  						</thead>

	  						<%-- JDBC 시작 --%>
	  						<%
								try {
								String driver = "org.mariadb.jdbc.Driver";
								Class.forName(driver);
								conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
								stmt = conn.createStatement();
								result = stmt.executeQuery(query3);

								while (result.next()) {
									int magicfirmid = result.getInt("magicfirmid");
									String password = result.getString("password");
									String businessname = result.getString("businessname");
									String adress = result.getString("adress");
									String representative = result.getString("representative");
									int permissionclass = result.getInt("permissionclass");
									int money = result.getInt("money"); 
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=magicfirmid%></td>
									<td><%=password%></td>
									<td><%=businessname%></td>
									<td><%=adress%></td>
									<td><%=representative%></td>
									<td><%=permissionclass%></td>
									<td><%=money%></td>
								</tr>
							</tbody>
							

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
	  					</table>
  					</div>
  					<%-- 탭 다섯 번째 내용 테이블 끝 --%>

 				</div>
 				<%-- 탭 다섯 번째 내용 부분 끝 --%>

 				<%-- 탭 여섯 번째 내용 부분 시작 --%>
 				<div class="tab-pane fade" id="database_customer" role="tabpanel" aria-labelledby="database_customer-tab">
 					<%-- 탭 여섯 번째 내용 테이블 시작 --%>
 					<div id="customer_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">ID</th>
	  								<th scope="col">패스워드</th>
	  								<th scope="col">이름</th>
	  								<th scope="col">나이</th>
	  								<th scope="col">주소</th>
	  								<th scope="col">속성</th>
	  								<th scope="col">소지금</th>
	  							</tr>
	  						</thead>

	  						<%-- JDBC 시작 --%>
	  						<%
								try {
								String driver = "org.mariadb.jdbc.Driver";
								Class.forName(driver);
								conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
								stmt = conn.createStatement();
								result = stmt.executeQuery(query4);

								while (result.next()) {
									int customerid = result.getInt("customerid");
									String password = result.getString("password");
									String customername = result.getString("customername");
									int age = result.getInt("age");
									String adress = result.getString("adress");
									String attribute = result.getString("attribute");
									int money = result.getInt("money"); 
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=customerid%></td>
									<td><%=password%></td>
									<td><%=customername%></td>
									<td><%=age%></td>
									<td><%=adress%></td>
									<td><%=attribute%></td>
									<td><%=money%></td>
								</tr>
							</tbody>
							

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
	  					</table>
  					</div>
  					<%-- 탭 여섯 번째 내용 테이블 끝 --%>
 				</div>
 				<%-- 탭 여섯 번째 내용 부분 끝 --%>

 				<%-- 탭 일곱 번째 내용 부분 시작 --%>
  				<div class="tab-pane fade" id="database_belongto" role="tabpanel" aria-labelledby="database_magic-tab">
  					<%-- 탭 일곱 번째 내용 테이블 시작 --%>
  					<div id="belongto_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">마법사ID</th>
	  								<th scope="col">소속 상회ID</th>

	  							</tr>
	  						</thead>

	  						<%-- JDBC 시작 --%>
	  						<%
								try {
								String driver = "org.mariadb.jdbc.Driver";
								Class.forName(driver);
								conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
								stmt = conn.createStatement();
								result = stmt.executeQuery(query5);

								while (result.next()) {
									int magicianid = result.getInt("magicianid");
									int magicfirmid = result.getInt("magicfirmid");
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=magicianid%></td>
									<td><%=magicfirmid%></td>
								</tr>
							</tbody>
							
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

	  					</table>
  					</div>
  					<%-- 탭 일곱 번째 내용 테이블 끝 --%>
  				</div>
  				<%-- 탭 일곱 번째 내용 부분 끝 --%>

  				<%-- 탭 여덟 번째 내용 부분 시작 --%>
  				<div class="tab-pane fade" id="database_needs" role="tabpanel" aria-labelledby="database_needs">
  					<%-- 탭 여덟 번째 내용 테이블 시작 --%>
  					<div id="needs_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">마법ID</th>
	  								<th scope="col">재료ID</th>
	  								<th scope="col">필요량</th>
	  							</tr>
	  						</thead>

	  						<%-- JDBC 시작 --%>
	  						<%
								try {
								String driver = "org.mariadb.jdbc.Driver";
								Class.forName(driver);
								conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
								stmt = conn.createStatement();
								result = stmt.executeQuery(query6);

								while (result.next()) {
									int magicid = result.getInt("magicid");
									int ingredientid = result.getInt("ingredientid");
									int needs = result.getInt("needs");
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=magicid%></td>
									<td><%=ingredientid%></td>
									<td><%=needs%></td>
								</tr>
							</tbody>
							
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

	  					</table>
  					</div>
  					<%-- 탭 여덟 번째 내용 테이블 끝 --%>
  				</div>
  				<%-- 탭 여덟 번째 내용 부분 끝 --%>


  				<%-- 탭 아홉 번째 내용 부분 시작 --%>
  				<div class="tab-pane fade" id="database_partner" role="tabpanel" aria-labelledby="database_partner">
  					<%-- 탭 아홉 번째 내용 테이블 시작 --%>
  					<div id="partner_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">마법상회ID</th>
	  								<th scope="col">고객ID</th>
	  							</tr>
	  						</thead>

	  						<%-- JDBC 시작 --%>
	  						<%
								try {
								String driver = "org.mariadb.jdbc.Driver";
								Class.forName(driver);
								conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
								stmt = conn.createStatement();
								result = stmt.executeQuery(query8);

								while (result.next()) {
									int magicfirmid = result.getInt("magicfirmid");
									int customerid = result.getInt("customerid");
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=magicfirmid%></td>
									<td><%=customerid%></td>
								</tr>
							</tbody>
							
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

	  					</table>
  					</div>
  					<%-- 탭 아홉 번째 내용 테이블 끝 --%>
  				</div>
  				<%-- 탭 아홉 번째 내용 부분 끝 --%>

			</div>
			<%-- 자바 스크립트 탭 내용 부분 끝 --%>

			<!-- 로그아웃 확인 팝업 버튼 -->
			<button  id="loginout_part" type="button" class="btn btn-primary" data-toggle="modal" data-target="#ModalCenter">
			  로그아웃
			</button>

			<!-- 로그아웃 확인 팝업 -->
			<div class="modal fade" id="ModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
			  <div class="modal-dialog modal-dialog-centered" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h5 class="modal-title" id="exampleModalCenterTitle">알림</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			      </div>
			      <div class="modal-body">
			        정말 로그아웃 하시겠습니까? 
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-secondary" data-dismiss="modal">아니오</button>
			        <button type="button" class="btn btn-primary" onclick="location.href='main.html'" >예</button>
			      </div>
			    </div>
			  </div>
			</div>

		</div>
		<%-- 콘텐츠 부분 끝 --%>
	</div>
</body>
</html>