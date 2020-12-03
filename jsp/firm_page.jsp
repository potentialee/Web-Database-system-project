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

<%--DB 정보 입력 부분--%>
<%
	String jdbcDriver = "jdbc:mariadb://localhost:3306/chanil";
	String dbUser = "root";
	String dbPass = "235711";

	int logined_id = (Integer) (session.getAttribute("firmid"));
	String logined_password = (String) (session.getAttribute("password"));

	session.setAttribute("logined_id", logined_id);
	session.setAttribute("logined_password", logined_password);

	// 로그인 상회 정보 가져오는 쿼리
	String query = "SELECT * FROM magicfirm_information WHERE magicfirmid = "+ logined_id +" AND password = '"+ logined_password +"' ";

	// 상회 소속 마법사 정보 가져오는 쿼리
	String query1 = "SELECT * FROM magician_information WHERE magicianid = ANY(SELECT magicianid FROM belongto_information WHERE magicfirmid = "+ logined_id +")";

	// 상회 재고 재료 가져오는 쿼리
	String query2 = "SELECT ingredientid, ingredientname, origin, kinds, price, instock FROM instock_information NATURAL JOIN ingredient_information WHERE magicfirmid = "+ logined_id +" ";

	// 재료 전체 가져오는 쿼리
	String query3 = "SELECT * FROM ingredient_information";

	// 상회에 속하지 않는 마법사들을 가져오는 쿼리
	String query4 = "SELECT * FROM magician_information WHERE magician_information.magicianid = ANY(SELECT magician_information.magicianid FROM magician_information LEFT OUTER JOIN belongto_information ON magician_information.magicianid = belongto_information.magicianid WHERE belongto_information.magicianid IS NULL)";

	// 상회의 재료 거래내역을 가져오는 쿼리
	String query5 = "SELECT * FROM customer_ibuy_information WHERE magicfirmid = "+logined_id+" ";

	// 상회의 마법 거래내역을 가져오는 쿼리
	String query6 = "SELECT * FROM customer_mbuy_information WHERE magicfirmid = "+logined_id+" ";

	ResultSet result = null;
	Statement stmt = null;
	Connection conn = null;
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="description" content="마법세계의 데이터베이스 접속 페이지">
	<meta name="keywords" content="마법, 데이터베이스">\

	<%-- style_logined.css, bootstrap, jquery 사용 --%>
	<link rel="stylesheet" type="text/css" href="firm_page_sheet.css" media="all">
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
						String businessname = result.getString("businessname");
			%>
			<%-- JDBC 끝 --%>

			<div class="alert alert-primary alert-dismissible fade show animated bounce" role="alert">
				안녕하세요, 로도스의 플레임 왕국의 상회 <strong><%=businessname%></strong>의 관리자님! 로그인을 환영합니다.
	 			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
	    		<span aria-hidden="true">&times;</span>
	  			</button>
			</div>

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
			<%-- 환영 팝업 끝 --%>

			<%-- 명언 블럭 시작 --%>
			<div class="jumbotron">
				<blockquote class="blockquote">
  				<p class="mb-0"> "마법을 누군가에게 나누는 일은 주도하는 것은 쉽지 않지만, 위대한 것이다." </p>
 				<footer class="blockquote-footer"> 플레임 왕국 국왕 카슈 알그나, <cite title="Source Title"> 마법의 서 1장 15절 </cite></footer>
				</blockquote>
			</div>
			<%-- 명언 블럭 끝 --%>

			<%-- 자바스크립트 탭 리스트 부분 시작 --%>
			<%-- href로 이어져있으니 div의 id속성을 지우지 말것. --%>
			<ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
			  	<li class="nav-item">
			    	<a class="nav-link active" id="firm_info-tab" data-toggle="pill" href="#firm_info" role="tab" aria-controls="firm_info" aria-selected="true">상회 정보</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="belongto_info-tab" data-toggle="pill" href="#belongto_info" role="tab" aria-controls="belongto_info" aria-selected="false">소속 마법사 정보</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="not_belong_m_info-tab" data-toggle="pill" href="#not_belong_m_info" role="tab" aria-controls="not_belong_m_info" aria-selected="false">미소속 마법사 목록</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="instock_info-tab" data-toggle="pill" href="#instock_info" role="tab" aria-controls="instock_info" aria-selected="false">재고 내역</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="purchase_ingredient_info-tab" data-toggle="pill" href="#purchase_ingredient_info" role="tab" aria-controls="purchase_ingredient_info" aria-selected="false">재료 구매</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="sell_ingredient_record-tab" data-toggle="pill" href="#sell_ingredient_record" role="tab" aria-controls="sell_ingredient_record" aria-selected="false">재료 거래 내역</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="sell_magic_record-tab" data-toggle="pill" href="#sell_magic_record" role="tab" aria-controls="sell_magic_record" aria-selected="false">마법 거래 내역</a>
			  	</li>
			</ul>
			<%-- 자바스크립트 탭 리스트 부분 끝 --%>

			<%-- 자바스크립트 탭 내용 부분 시작 --%>
			<div class="tab-content" id="pills-tabContent">

				<%-- 탭 첫 번째 내용 시작 clearfix 처리 --%>
				<div class="tab-pane fade show active clearfix" id="firm_info" role="tabpanel" aria-labelledby="firm_info-tab">

					<%-- 마법사 정보 NAV --%>
					<nav class="navbar navbar-dark bg-dark" style="background-color: #e3f2fd;" id="magicfirm_info_nav">
						<span class="navbar-brand mb-0 h1"><strong>상회 정보</strong></span>
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
							result = stmt.executeQuery(query);

							while (result.next()) {
								int magicfirmid = result.getInt("magicfirmid");
								String businessname = result.getString("businessname");
								String adress = result.getString("adress");
								String representative = result.getString("representative");
								int permissionclass = result.getInt("permissionclass");
								int money = result.getInt("money");
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
							    <tr>
							      <th scope="row">소지금</th>
							      <td><%=money %></td>
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

					<%-- 마법사 정보 NAV2 --%>
 					<nav class="navbar navbar-dark bg-dark" style="background-color: #e3f2fd;" id="magicfirm_info_nav2">
					  <span class="navbar-brand mb-0 h1"><strong>상회 관리 기능</strong></span>
					</nav>

					<%-- 상회 정보 수정 카드 --%>
					<div class="card" id="firm_info_edit_card" >
						<img src="img/edit.png" class="card-img-top" alt="">
						<div class="card-body">
							<h5 class="card-title">상회 정보 수정</h5>
							<p class="card-text">상회의 정보가 변경되었다면, 이 기능을 통해 수정하실 수 있습니다.</p>
							<a href="firm_info_modify.jsp" class="btn btn-primary">상회 정보 수정하기</a>
						</div>
					</div>

				</div>
				<%-- 탭 첫 번째 내용 끝 --%>


				<%-- 탭 두 번째 내용 시작 --%>
				<div class="tab-pane fade" id="belongto_info" role="tabpanel" aria-labelledby="belongto_info-tab">

					<%-- 검색창 --%>
				 	<nav class="navbar navbar-light search_block" style="background-color: #e3f2fd;">
					  <a class="navbar-brand">검색(ID,이름, 나이, 종족, 출신지, 직업, 클래스, 속성) </a>
					  <form class="form-inline">
					    <input id="firm_magician" class="form-control mr-sm-2" type="search" placeholder="검색어를 입력하세요" aria-label="Search">
					  </form>
					</nav>

					<script type="text/javascript">
				 		$(document).ready(function() {
				            $("#firm_magician").keyup(function() {
				                var k = $(this).val();
				                $("#firm_magician_table > tbody > tr").hide();
				                var temp = $("#firm_magician_table > tbody > tr > td:nth-child(-n+9):contains('" + k + "')");
				                $(temp).parent().show();
				            });
				        });
				 	</script>

					<%-- 탭 두 번째 내용 테이블 시작 --%>
  					<div>
	  					<table class="table table-hover" id="firm_magician_table">

	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">마법사ID</th>
	  								<th scope="col">이름</th>
	  								<th scope="col">나이</th>
	  								<th scope="col">종족</th>
	  								<th scope="col">출신지</th>
	  								<th scope="col">직업</th>
	  								<th scope="col">클래스</th>
	  								<th scope="col">속성</th>
	  								<th scope="col">마나량</th>
	  								<th scope="col">      </th>
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
									<form action="firm_m_delete.jsp" method="post">
									<td><input type="number" name="magicianid" value="<%=magicianid%>" class="magician_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><%=magicianname%></td>
									<td><%=age%></td>
									<td><%=tribe%></td>
									<td><%=hometown %></td>
									<td><%=job %></td>
									<td><%=magicclass %></td>
									<td><%=magicattribute %></td>
									<td><%=manacount %></td>
									<td><button type="submit" class="btn btn-primary">추방</button></td>
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
  					<%-- 탭 두 번째 내용 테이블 끝 --%>
				  	
				</div>
				<%-- 탭 두 번째 내용 끝 --%>

				<%-- 탭 세 번째 내용 시작 --%>
				<div class="tab-pane fade" id="instock_info" role="tabpanel" aria-labelledby="instock_info-tab">

					<%-- 검색창 --%>
				 	<nav class="navbar navbar-light search_block" style="background-color: #e3f2fd;">
					  <a class="navbar-brand">검색(ID, 이름, 원산지, 종류) </a>
					  <form class="form-inline">
					    <input id="instock_ingredient_info" class="form-control mr-sm-2" type="search" placeholder="검색어를 입력하세요" aria-label="Search">
					  </form>
					</nav>

					<script type="text/javascript">
				 		$(document).ready(function() {
				            $("#instock_ingredient_info").keyup(function() {
				                var k = $(this).val();
				                $("#instock_ingredient_info_table > tbody > tr").hide();
				                var temp = $("#instock_ingredient_info_table > tbody > tr > td:nth-child(-n+4):contains('" + k + "')");
				                $(temp).parent().show();
				            });
				        });
				 	</script>

					<%-- 탭 세 번째 내용 테이블 시작 --%>
  					<div>
	  					<table class="table table-hover" id="instock_ingredient_info_table">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">재료ID</th>
	  								<th scope="col">이름</th>
	  								<th scope="col">원산지</th>
	  								<th scope="col">종류</th>
	  								<th scope="col">가격</th>
	  								<th scope="col">재고량</th>
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
									int instock = result.getInt("instock");
									
							%>
							<%-- JDBC 끝 --%>

							<tbody>
								<tr>
									<td><%=ingredientid%></td>
									<td><%=ingredientname%></td>
									<td><%=origin%></td>
									<td><%=kinds%></td>
									<td><%=price %></td>
									<td><%=instock %></td>
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
				<%-- 탭 세 번째 내용 끝 --%>

				<%-- 탭 네 번째 내용 시작 --%>
				<div class="tab-pane fade" id="purchase_ingredient_info" role="tabpanel" aria-labelledby="purchase_ingredient_info-tab">

					<%-- 검색창 --%>
				 	<nav class="navbar navbar-light search_block" style="background-color: #e3f2fd;">
					  <a class="navbar-brand">검색(ID,이름, 원산지, 종류) </a>
					  <form class="form-inline">
					    <input id="buy_ingredient" class="form-control mr-sm-2" type="search" placeholder="검색어를 입력하세요" aria-label="Search">
					  </form>
					</nav>

					<script type="text/javascript">
				 		$(document).ready(function() {
				            $("#buy_ingredient").keyup(function() {
				                var k = $(this).val();
				                $("#ingredient_buy_table > tbody > tr").hide();
				                var temp = $("#ingredient_buy_table > tbody > tr > td:nth-child(-n+5):contains('" + k + "')");
				                $(temp).parent().show();
				            });
				        });
				 	</script>

					<%-- 탭 네 번째 내용 테이블 시작 --%>
 					<div>
	  					<table class="table table-hover" id="ingredient_buy_table">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">ID</th>
	  								<th scope="col">이름</th>
	  								<th scope="col">원산지</th>
	  								<th scope="col">종류</th>
	  								<th scope="col">가격</th>
	  								<th scope="col">구매량</th>
	  								<th scope="col">      </th>
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
									int ingredientid = result.getInt("ingredientid");
									String ingredientname = result.getString("ingredientname");
									String origin = result.getString("origin");
									String kinds = result.getString("kinds");
									int price = result.getInt("price"); 
							%>
							<%-- JDBC 끝 --%>

							
							<tbody>
								<tr>
									<form action="firm_buy_result.jsp" method="post" >
									<td><input type="number" name="ingredientid" value="<%=ingredientid%>" id="ingredid_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><%=ingredientname%></td>
									<td><%=origin%></td>
									<td><%=kinds%></td>
									<td><input type="number" name="price" value="<%=price%>" id="price_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><input id="ingredient_buy_amount" type="number" class="form-control" name="amount" min="1" max="500"></td>
									<td><button type="submit" class="btn btn-primary">구매</button></td>
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
  					<%-- 탭 네 번째 내용 테이블 끝 --%>

				</div>
				<%-- 탭 네 번째 내용 끝 --%>

				<%-- 탭 다섯 번째 내용 시작 --%>
				<div class="tab-pane fade" id="not_belong_m_info" role="tabpanel" aria-labelledby="not_belong_m_info-tab">

					<%-- 검색창 --%>
				 	<nav class="navbar navbar-light search_block" style="background-color: #e3f2fd;">
					  <a class="navbar-brand">검색(ID,이름, 나이, 종족, 출신지, 직업, 클래스, 속성) </a>
					  <form class="form-inline">
					    <input id="not_belong_magician" class="form-control mr-sm-2" type="search" placeholder="검색어를 입력하세요" aria-label="Search">
					  </form>
					</nav>

					<script type="text/javascript">
				 		$(document).ready(function() {
				            $("#not_belong_magician").keyup(function() {
				                var k = $(this).val();
				                $("#not_belong_magician_table > tbody > tr").hide();
				                var temp = $("#not_belong_magician_table > tbody > tr > td:nth-child(-n+9):contains('" + k + "')");
				                $(temp).parent().show();
				            });
				        });
				 	</script>

					<%-- 탭 다섯 번째 내용 테이블 시작 --%>
 					<div>
	  					<table class="table table-hover" id="not_belong_magician_table">
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
	  								<th scope="col">      </th>
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
									<form action="firm_m_add.jsp" method="post" >
									<td><input type="number" name="magicianid" value="<%=magicianid%>" class="magician_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><%=magicianname%></td>
									<td><%=age%></td>
									<td><%=tribe%></td>
									<td><%=hometown%></td>
									<td><%=job%></td>
									<td><input type="number" name="magicclass" value="<%=magicclass%>" class="magician_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><%=magicattribute%></td>
									<td><%=manacount%></td>
									<td><button type="submit" class="btn btn-primary">영입</button></td>
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
  					<%-- 탭 탭 다섯 번째 내용 테이블 끝 --%>

				</div>
				<%-- 탭 탭 다섯 번째 내용 끝 --%>

				<%-- 탭 여섯 번째 내용 부분 시작 --%>
 				<div class="tab-pane fade" id="sell_ingredient_record" role="tabpanel" aria-labelledby="sell_ingredient_record-tab">
 					<%-- 탭 여섯 번째 내용 테이블 시작 --%>
 					<div id="sell_ingredient_record_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">고객ID</th>
	  								<th scope="col">재료ID</th>
	  								<th scope="col">매입량</th>
	  								<th scope="col">구매 시간</th>

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
									int customerid = result.getInt("customerid");
									int ingredientid = result.getInt("ingredientid");
									int amount = result.getInt("amount");
									String purchasedat = result.getString("purchasedat");
	

							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=customerid%></td>
									<td><%=ingredientid%></td>
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
  					<%-- 탭 여섯 번째 내용 테이블 끝 --%>

 				</div>
 				<%-- 탭 여섯 번째 내용 부분 끝 --%>

 				<%-- 탭 일곱 번째 내용 부분 시작 --%>
 				<div class="tab-pane fade" id="sell_magic_record" role="tabpanel" aria-labelledby="sell_magic_record-tab">
 					<%-- 탭 일곱 번째 내용 테이블 시작 --%>
 					<div id="sell_magic_record_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">고객ID</th>
	  								<th scope="col">마법사ID</th>
	  								<th scope="col">마법ID</th>
	  								<th scope="col">매입량</th>
	  								<th scope="col">구매 시간</th>

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
									int magicianid = result.getInt("magicianid");
									int magicid = result.getInt("magicid");
									int customerid = result.getInt("customerid");
									int amount = result.getInt("amount");
									String purchasedat = result.getString("purchasedat");
	

							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=customerid%></td>
									<td><%=magicianid%></td>
									<td><%=magicid%></td>
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
  					<%-- 탭 일곱 번째 내용 테이블 끝 --%>

 				</div>
 				<%-- 탭 일곱 번째 내용 부분 끝 --%>


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
