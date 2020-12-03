<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="error.jsp" %>

<%-- 캐시 정보 유지 금지 --%>
<%
	response.setHeader("Pragma", "no-cache"); //HTTP 1.0
	response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
	response.setHeader("Cache-Control", "no-store"); //HTTP 1.1
	response.setDateHeader("Expires", 0L); // Do not cache in proxy server
%>

<%--세션 및 데이터베이스 정보 로드--%>
<%
	String jdbcDriver = "jdbc:mariadb://localhost:3306/chanil";
	String dbUser = "root";
	String dbPass = "235711";

	int logined_id = (Integer) (session.getAttribute("magicianid"));
	String logined_password = (String) (session.getAttribute("password"));

	session.setAttribute("logined_id", logined_id);
	session.setAttribute("logined_password", logined_password);

	// 로그인 마법사 정보 가져오는 쿼리
	String query = "SELECT * FROM magician_information WHERE magicianid = " + logined_id + " AND password = '" + logined_password + "' ";

	//소속 상회 정보 가져오는 쿼리
	String query1 = "SELECT * FROM magicfirm_information where magicfirmid = (SELECT magicfirmid FROM belongto_information WHERE magicianid = (SELECT magicianid FROM magician_information WHERE magicianid = " + logined_id + " AND password = '" + logined_password + "'))";

	// 창조한 마법 정보 가져오는 쿼리
	String query2 = "SELECT * FROM magic_information WHERE createrid = (SELECT magicianid FROM magician_information WHERE magicianid = " + logined_id + " AND password = '" + logined_password + "')";

	// 소속 상회의 다른 마법사 가져오는 쿼리
	String query3 = "SELECT * FROM magician_information WHERE magicianid = ANY(SELECT magicianid from belongto_information WHERE magicfirmid = (SELECT magicfirmid FROM belongto_information WHERE magicianid = (SELECT magicianid FROM magician_information WHERE magicianid = " + logined_id + " AND password = '" + logined_password + "'))) AND magicianid != " + logined_id + " ";

	// 창조한 마법의 재료정보 가져오는 쿼리
	String query4 = "SELECT ALL magicid, magicname, ingredientid, ingredientname, needs FROM needs_information natural join magic_information natural join ingredient_information WHERE needs_information.magicid = ANY(SELECT magicid FROM magic_information WHERE createrid = (SELECT magicianid FROM magician_information WHERE magicianid = " + logined_id + " AND password = '" + logined_password + "')) ";

	// 전체 재료 정보 가져오는 쿼리
	String query5 = "SELECT * FROM ingredient_information";

	// 자신의 마법 판매 내역 가져오는 쿼리
	String query6 = "SELECT * FROM customer_mbuy_information WHERE magicianid = "+logined_id+" ";


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
	<link rel="stylesheet" type="text/css" href="magician_page_sheet.css" media="all">
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css" media="all">
	<link rel="stylesheet" type="text/css" href="css/animate.css" media="all">
	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.0/js/bootstrap.min.js" integrity="sha384-3qaqj0lc6sV/qpzrc1N5DC6i1VRn/HyX4qdPaiEFbn54VjQBEU341pvjz7Dv3n6P" crossorigin="anonymous"></script>

	<title>로도스 플레임 왕국 데이터 베이스 페이지 - 관리자 로그인 페이지</title>
	
</head>
<body>
	<div id="content_wrap">
		<%-- 제목 부분 시작 --%>
		<div id="title_part">
			<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
			<hr class="my-4">
		</div>
		<%-- 제목 부분 끝 --%>

		<%--콘텐츠 부분 시작 --%>
		<div class="p-3 mb-2 bg-light text-dark rounded border">
			<%-- 환영 팝업 시작 --%>

			<%-- JDBC 시작 --%>
	  		<%
				try {
					String driver = "org.mariadb.jdbc.Driver";
					Class.forName(driver);
					conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
					stmt = conn.createStatement();
					result = stmt.executeQuery(query);

					while (result.next()) {
						String magicianname = result.getString("magicianname");
			%>
			<%-- JDBC 끝 --%>

			<div class="alert alert-primary alert-dismissible fade show animated bounce" role="alert">
				안녕하세요, 로도스의 플레임 왕국의 마법사 <strong><%=magicianname%></strong>님! 로그인을 환영합니다.
	 			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
	    		<span aria-hidden="true">&times;</span>
	  			</button>
			</div>
			<%-- 환영 팝업 끝 --%>

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

			<%-- 명언 블럭 시작 --%>
			<div class="jumbotron">
				<blockquote class="blockquote">
  				<p class="mb-0"> "마법은 모두를 위해 만들어져야 하고, 모두를 위해 사용되어야 한다." </p>
 				<footer class="blockquote-footer"> 플레임 왕국 국왕 카슈 알그나, <cite title="Source Title"> 마법의 서 1장 11절 </cite></footer>
				</blockquote>
			</div>
			<%-- 명언 블럭 끝 --%>

			<%-- 자바스크립트 탭 리스트 부분 시작 --%>
			<%-- href로 이어져있으니 div의 id속성을 지우지 말것. --%>
			<ul class="nav nav-pills mb-3" id="nav-tab" role="tablist">
			  	<li class="nav-item">
			    	<a class="nav-link active" id="profile-tab" data-toggle="pill" href="#profile" role="tab" aria-controls="profile" aria-selected="true">마법사 정보</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="belongto-tab" data-toggle="pill" href="#belongto" role="tab" aria-controls="belongto" aria-selected="false">소속 상회 정보</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="magiccreated-tab" data-toggle="pill" href="#magiccreated" role="tab" aria-controls="magiccreated" aria-selected="false">창조한 마법 정보</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="magictrade_info-tab" data-toggle="pill" href="#magictrade_info" role="tab" aria-controls="magictrade_info" aria-selected="false">창조한 마법 거래 내역</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="ingredient_info-tab" data-toggle="pill" href="#ingredient_info" role="tab" aria-controls="ingredient_info" aria-selected="false">재료 정보</a>
			  	</li>

			</ul>
			<%-- 자바스크립트 탭 리스트 부분 끝 --%>

			<%-- 자바스크립트 탭 내용 부분 시작 --%>
			<div class="tab-content" id="pills-tabContent">

				<%-- 탭 첫 번째 내용 시작 clearfix 처리 --%>
				<div class="tab-pane fade show active clearfix" id="profile" role="tabpanel" aria-labelledby="profile-tab">

					<%-- 마법사 정보 NAV --%>
					<nav class="navbar navbar-dark bg-dark" style="background-color: #e3f2fd;" id="magician_info_nav">
						<span class="navbar-brand mb-0 h1"><strong>마법사 정보</strong></span>
					</nav>

					<%-- 마법사 프로필 이미지 --%>
					<img id="magician_img" src="img/magician.png" class="img-fluid" alt="magician image">

					<%-- 탭 첫 번째 내용 테이블 시작 --%>
 					<div id="magician_info_table">
 						
 						<table class="table table-hover">
						  <thead class="thead-light">
						    <tr>
						      <th scope="col">카테고리</th>
						      <th scope="col">정보</th>
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
						      <th scope="row">이름</th>
						      <td><%=magicianname %></td>
						    </tr>
						    <tr>
						      <th scope="row">나이</th>
						      <td><%=age %></td>
						    </tr>
						    <tr>
						      <th scope="row">종족</th>
						      <td><%=tribe %></td>
						    </tr>
						    <tr>
						      <th scope="row">출신지</th>
						      <td><%=hometown %></td>
						    </tr>
						    <tr>
						      <th scope="row">직업</th>
						      <td><%=job %></td>
						    </tr>
						    <tr>
						      <th scope="row">클래스</th>
						      <td><%=magicclass %></td>
						    </tr>
						    <tr>
						      <th scope="row">속성</th>
						      <td><%=magicattribute %></td>
						    </tr>
						    <tr>
						      <th scope="row">마나량</th>
						      <td><%=manacount %></td>
						    </tr>
						    <tr>
						      <th scope="row">소지금</th>
						      <td><%=money %></td>
						    </tr>
						  </tbody>
						</table>

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
 					<%-- 탭 첫 번째 내용 테이블 끝 --%>

					<%-- 마법사 정보 NAV2 --%>
 					<nav class="navbar navbar-dark bg-dark" style="background-color: #e3f2fd;" id="magician_info_nav2">
					  <span class="navbar-brand mb-0 h1"><strong>정보 관리 기능</strong></span>
					</nav>

					<%-- 마법사 데이터 수정/삭제 카드 --%>
					<div class="card" id="update_delete_card" >
					  <img src="img/edit.png" class="card-img-top" alt="editordelete">
					  <div class="card-body">
					    <h5 class="card-title">마법사 정보 수정하기</h5>
					    <p class="card-text">수정을 원하는 마법사 정보가 있다면 여기를 눌러서 수정하세요.</p>
					    <a href="magician_info_modify.jsp" class="btn btn-primary">내 정보 수정하기</a>
					  </div>
					</div>

					<%-- 마법 데이터 정보 생성 카드 --%>
					<div class="card" id="magic_edit_card" >
					  <img src="img/magic.png" class="card-img-top" alt="magic">
					  <div class="card-body">
					    <h5 class="card-title">창조한 마법 등록하기</h5>
					    <p class="card-text">본인이 새롭게 창조한 마법을 재료와 함께 작성하여 등록하세요.</p>
					    <a href="magic_add.jsp" class="btn btn-primary">창조한 마법 등록</a>
					  </div>
					</div>

					<%-- 재료 데이터 정보 생성 카드 --%>
					<div class="card" id="ingredient_new_card" >
					  <img src="img/ingredient.jpg" class="card-img-top" alt="ingredient">
					  <div class="card-body">
					    <h5 class="card-title">발견한 재료 등록하기</h5>
					    <p class="card-text">로도스에서 누구도 발견하지 못한 진귀한 재료를 등록해보세요.</p>
					    <a href="ingredient_add.jsp" class="btn btn-primary">발견한 재료 등록</a>
					  </div>
					</div>

				</div>
				<%-- 탭 첫 번째 내용 끝 --%>


				<%-- 탭 두 번째 내용 시작 --%>
				<div class="tab-pane fade" id="belongto" role="tabpanel" aria-labelledby="belongto-tab">

					<%-- 마법 상회 정보 NAV --%>
					<nav class="navbar navbar-dark bg-dark" style="background-color: #e3f2fd;" id="belongto_magicfirm_info_nav">
						<span class="navbar-brand mb-0 h1"><strong>소속 상회 정보</strong></span>
					</nav>

					<%-- 마법 상회 프로필 이미지 --%>
					<img id="magicfirm_img" src="img/magicfirm.png" class="img-fluid" alt="magicfirm image">

					<%-- 탭 두 번째 내용 테이블 시작 --%>
					<div id="magicfirm_info_table">

						<table class="table table-hover">
	  						<thead class="thead-light">
							    <tr>
							      <th scope="col">카테고리</th>
							      <th scope="col">정보</th>
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
								int magicfirmid = result.getInt("magicfirmid");
								String businessname = result.getString("businessname");
								String adress = result.getString("adress");
								String representative = result.getString("representative");
								int permissionclass = result.getInt("permissionclass");
						%>
						 <%-- JDBC 끝 --%>

							 <tbody>
							    <tr>
							      <th scope="row">마법 상회 ID</th>
							      <td><%=magicfirmid %></td>
							    </tr>
							    <tr>
							      <th scope="row">상호</th>
							      <td><%=businessname %></td>
							    </tr>
							    <tr>
							      <th scope="row">주소</th>
							      <td><%=adress %></td>
							    </tr>
							    <tr>
							      <th scope="row">대표자 이름</th>
							      <td><%=representative %></td>
							    </tr>
							    <tr>
							      <th scope="row">거래 허가 클래스</th>
							      <td><%=permissionclass %></td>
							    </tr>
							  </tbody>
						</table>
						<%-- 탭 두 번째 내용 테이블 끝 --%>

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
					<%-- 탭 두 번째 내용 테이블 끝 --%>


					<%-- 마법 상회 정보 NAV2 --%>
					<nav class="navbar navbar-dark bg-dark" style="background-color: #e3f2fd;" id="other_magicfirm_member_nav">
						<span class="navbar-brand mb-0 h1"><strong>상회의 다른 마법사 정보</strong></span>
					</nav>

					<%-- 탭 두 번째 내용 테이블-2 시작 --%>
 					<div id="other_magician_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">ID</th>
	  								<th scope="col">이름</th>
	  								<th scope="col">나이</th>
	  								<th scope="col">종족</th>
	  								<th scope="col">출신지</th>
	  								<th scope="col">직업</th>
	  								<th scope="col">클래스</th>
	  								<th scope="col">속성</th>
	  								<th scope="col">마나량</th>
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
									int magicianid = result.getInt("magicianid");
									String magicianname = result.getString("magicianname");
									int age = result.getInt("age");
									String tribe = result.getString("tribe");
									String hometown = result.getString("hometown");
									String job = result.getString("job");
									int magicclass = result.getInt("magicclass");
									String magicattribute = result.getString("magicattribute");
									int manacount = result.getInt("manacount");
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=magicianid%></td>
									<td><%=magicianname%></td>
									<td><%=age%></td>
									<td><%=tribe%></td>
									<td><%=hometown%></td>
									<td><%=job%></td>
									<td><%=magicclass%></td>
									<td><%=magicattribute%></td>
									<td><%=manacount%></td>
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
  					<%-- 탭 두 번째 내용-2 테이블 끝 --%>

				</div>
				<%-- 탭 두 번째 내용 끝 --%>

				 <%-- 탭 세 번째 내용 시작 --%>
				 <div class="tab-pane fade" id="magiccreated" role="tabpanel" aria-labelledby="magiccreated-tab">

				 	<script type="text/javascript">
				 		$(document).ready(function() {
				            $("#created_magic_keyword").keyup(function() {
				                var k = $(this).val();
				                $("#created_magic_table > tbody > tr").hide();
				                var temp = $("#created_magic_table > tbody > tr > td:nth-child(-n+5):contains('" + k + "')");
				                $(temp).parent().show();
				            });
				        });
				 	</script>

				 	<%-- 검색창 --%>
				 	<nav class="navbar navbar-light search_block" style="background-color: #e3f2fd;">
					  <a class="navbar-brand">검색(마법이름, 클래스, 종류) </a>
					  <form class="form-inline">
					    <input id="created_magic_keyword" class="form-control mr-sm-2" type="search" placeholder="검색어를 입력하세요" aria-label="Search">
					  </form>
					</nav>

				 	<%-- 창조한 마법 정보 NAV --%>
					<nav class="navbar navbar-dark bg-dark" style="background-color: #e3f2fd;" id="created_magic_nav">
						<span class="navbar-brand mb-0 h1"><strong>창조한 마법 정보</strong></span>
					</nav>

				 	<%-- 탭 세 번째 내용 테이블 시작 --%>
  					<div>
	  					<table class="table table-hover" id="created_magic_table">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">ID</th>
	  								<th scope="col">마법 이름</th>
	  								<th scope="col">클래스</th>
	  								<th scope="col">종류</th>
	  								<th scope="col">효과량</th>
	  								<th scope="col">마나 소비</th>
	  								<th scope="col">가격</th>
	  								<th scope="col">    </th>
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
									int magicid = result.getInt("magicid");
									String magicname = result.getString("magicname");
									int magicclass = result.getInt("magicclass");
									String magictype = result.getString("magictype");
									int effectivedose = result.getInt("effectivedose");
									int manaconsume = result.getInt("manaconsume");
									int sellingprice = result.getInt("sellingprice");
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<form action="magician_magic_modify.jsp" method="post">
									<td><input type="number" name="magicid" value="<%=magicid%>" class="magic_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><%=magicname%></td>
									<td><%=magicclass%></td>
									<td><%=magictype%></td>
									<td><%=effectivedose%></td>
									<td><%=manaconsume%></td>
									<td><%=sellingprice%></td>
									<td><button type="submit" class="btn btn-primary">수정</button></td>
									</form>
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

  					<%-- 검색창 --%>
				 	<nav class="navbar navbar-light search_block" style="background-color: #e3f2fd;">
					  <a class="navbar-brand">검색(마법이름) </a>
					  <form class="form-inline">
					    <input id="created_magic_ingredient_keyword" class="form-control mr-sm-2" type="search" placeholder="검색어를 입력하세요" aria-label="Search">
					  </form>
					</nav>

					<script type="text/javascript">
				 		$(document).ready(function() {
				            $("#created_magic_ingredient_keyword").keyup(function() {
				                var k = $(this).val();
				                $("#create_magic_ingredient_table > tbody > tr").hide();
				                var temp1 = $("#create_magic_ingredient_table > tbody > tr > td:nth-child(3):contains('" + k + "')");
				                $(temp1).parent().show();
				            });
				        });
				 	</script>

  					<%-- 창조한 마법 정보 NAV2 --%>
					<nav class="navbar navbar-dark bg-dark" style="background-color: #e3f2fd;" id="created_magic_ingredient_nav">
						<span class="navbar-brand mb-0 h1"><strong>창조한 마법의 재료 정보</strong></span>
					</nav>


					<%-- 탭 세 번째 내용 테이블-2 시작 --%>
  					<div>
	  					<table class="table table-hover" id="create_magic_ingredient_table">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">마법ID</th>
	  								<th scope="col">재료 ID</th>
	  								<th scope="col">마법 이름</th>
	  								<th scope="col">재료 이름</th>
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
								result = stmt.executeQuery(query4);

								while (result.next()) {
									int magicid = result.getInt("magicid");
									String magicname = result.getString("magicname");
									int ingredientid = result.getInt("ingredientid");
									String ingredientname = result.getString("ingredientname");
									int needs = result.getInt("needs");
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=magicid%></td>
									<td><%=ingredientid%></td>
									<td><%=magicname%></td>
									<td><%=ingredientname%></td>
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
  					<%-- 탭 세 번째 내용 테이블-2 끝 --%>

				  	
				 </div>
				 <%-- 탭 세 번째 내용 끝 --%>

				 <%-- 탭 네 번째 내용 시작 --%>
				 <div class="tab-pane fade" id="magictrade_info" role="tabpanel" aria-labelledby="magictrade_info-tab">
				 	<%-- 탭 네 번째 내용 테이블 시작 --%>
 					<div id="buy_magic_record_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">상회ID</th>
	  								<th scope="col">마법ID</th>
	  								<th scope="col">고객 ID</th>
	  								<th scope="col">매출량</th>
	  								<th scope="col">판매 시간</th>

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
									int magicfirmid = result.getInt("magicfirmid");
									int magicid = result.getInt("magicid");
									int customerid = result.getInt("customerid");
									int amount = result.getInt("amount");
									String purchasedat = result.getString("purchasedat");
	

							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=magicfirmid%></td>
									<td><%=magicid%></td>
									<td><%=customerid%></td>
									<td><%=amount%></td>
									<td><%=purchasedat%></td>
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
				 <%-- 탭 네 번째 내용 끝 --%>

				 <%-- 탭 다섯 번째 내용 시작 --%>
				 <div class="tab-pane fade" id="ingredient_info" role="tabpanel" aria-labelledby="ingredient_info-tab">

				 	<script type="text/javascript">
				 		$(document).ready(function() {
				            $("#ingredient_keyword").keyup(function() {
				                var k = $(this).val();
				                $("#ingredient_info_table > tbody > tr").hide();
				                var temp2 = $("#ingredient_info_table > tbody > tr > td:nth-child(n):contains('" + k + "')");
				                $(temp2).parent().show();
				            });
				        });
				 	</script>

				 	<%-- 검색창 --%>
				 	<nav class="navbar navbar-light search_block" style="background-color: #e3f2fd;">
					  <a class="navbar-brand">검색 (ID, 이름, 원산지, 종류, 가격) </a>
					  <form class="form-inline">
					    <input class="form-control mr-sm-2" id="ingredient_keyword" type="search" placeholder="검색어를 입력하세요" aria-label="Search">
					  </form>
					</nav>

				  	<%-- 탭 다섯 번째 내용 테이블 시작 --%>
 					<div>
	  					<table class="table table-hover" id="ingredient_info_table">
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
								result = stmt.executeQuery(query5);

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
  					<%-- 탭 다섯 번째 내용 테이블 끝 --%>
				 </div>
				 <%-- 탭 다섯 번째 내용 끝 --%>

			</div>
			<%-- 자바스크립트 탭 내용 부분 끝 --%>

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
			        <button type="button" class="btn btn-primary" onclick="location.href='logout.jsp'" >예</button>
			      </div>
			    </div>
			  </div>
			</div>

		</div>
		<%--콘텐츠 부분 끝 --%>
		
	</div>
</body>
</html>
