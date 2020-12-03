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

	// 앞의 로그인 페이지로부터 세션을 받아온다.
	int logined_id = (Integer) (session.getAttribute("customerid"));
	String logined_password = (String) (session.getAttribute("password"));

	// 다음 페이지에 세션 정보 전달
	session.setAttribute("logined_id", logined_id);
	session.setAttribute("logined_password", logined_password);

	// 로그인 고객 정보 가져오는 쿼리
	String query = "SELECT * FROM customer_information WHERE customerid = "+ logined_id +" AND password = '"+ logined_password +"'";

	// 거래처 상회 정보 가져오는 쿼리
	String query1 = "SELECT * FROM magicfirm_information WHERE magicfirmid = ANY(SELECT magicfirmid FROM partner_information WHERE customerid="+ logined_id+" ) ";

	// 거래처가 아닌 상회 정보 가져오는 쿼리
	String query2 = "SELECT * FROM magicfirm_information WHERE magicfirmid NOT IN (SELECT magicfirmid FROM partner_information WHERE customerid=9001)"; 


	// 거래처인 상회의 마법사들이 창조한 마법과 상회ID를 가져오는 쿼리
	String query3 = "SELECT magicfirmid, magicid, magicname, magicclass, magicattribute, magictype, createrid, sellingprice FROM magic_information INNER JOIN belongto_information ON magic_information.createrid = belongto_information.magicianid WHERE magicfirmid = ANY(SELECT magicfirmid FROM partner_information WHERE customerid = "+logined_id+")";

	// 거래처인 상회의 재료 정보를 가져오는 쿼리
	String query4 = "SELECT magicfirmid, ingredientid, ingredientname, origin, kinds, price, instock FROM instock_information NATURAL JOIN ingredient_information  WHERE magicfirmid IN (SELECT magicfirmid FROM partner_information WHERE customerid= "+logined_id+") ";

	// 고객의 마법 거래내역을 가져오는 쿼리
	String query5 = "SELECT * FROM customer_mbuy_information WHERE customerid = "+logined_id+" ";

	// 고객의 재료 거래내역을 가져오는 쿼리
	String query6 = "SELECT * FROM customer_ibuy_information WHERE customerid = "+logined_id+" ";


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
	<link rel="stylesheet" type="text/css" href="customer_page_sheet.css" media="all">
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
						String customername = result.getString("customername");
			%>
			<%-- JDBC 끝 --%>

			<div class="alert alert-primary alert-dismissible fade show animated bounce" role="alert">
				안녕하세요, 로도스의 플레임 왕국의 고객 <strong><%=customername%></strong>님! 로그인을 환영합니다.
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
  				<p class="mb-0"> "마법의 진정한 가치는 이용자로부터 나온다." </p>
 				<footer class="blockquote-footer"> 플레임 왕국 국왕 카슈 알그나, <cite title="Source Title"> 마법의 서 2장 1절 </cite></footer>
				</blockquote>
			</div>
			<%-- 명언 블럭 끝 --%>

			<%-- 자바스크립트 탭 리스트 부분 시작 --%>
			<%-- href로 이어져있으니 div의 id속성을 지우지 말것. --%>
			<ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
			  	<li class="nav-item">
			    	<a class="nav-link active" id="customer_info-tab" data-toggle="pill" href="#customer_info" role="tab" aria-controls="customer_info" aria-selected="true">고객 정보</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="using_vendor-tab" data-toggle="pill" href="#using_vendor" role="tab" aria-controls="using_vendor" aria-selected="false">거래처</a>
			  	</li>
			  	
			  	<li class="nav-item">
			    	<a class="nav-link" id="not_using_vendor-tab" data-toggle="pill" href="#not_using_vendor" role="tab" aria-controls="not_using_vendor" aria-selected="false">거래처가 아닌 상회</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="buy_magic-tab" data-toggle="pill" href="#buy_magic" role="tab" aria-controls="buy_magic" aria-selected="false">마법 구매</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="buy_ingredient-tab" data-toggle="pill" href="#buy_ingredient" role="tab" aria-controls="buy_ingredient" aria-selected="false">재료 구매</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="buy_magic_record-tab" data-toggle="pill" href="#buy_magic_record" role="tab" aria-controls="buy_magic_record" aria-selected="false">마법 구매 내역</a>
			  	</li>
			  	<li class="nav-item">
			    	<a class="nav-link" id="buy_ingredient_record-tab" data-toggle="pill" href="#buy_ingredient_record" role="tab" aria-controls="buy_ingredient_record" aria-selected="false">재료 구매 내역</a>
			  	</li>
			  	


			</ul>
			<%-- 자바스크립트 탭 리스트 부분 끝 --%>

			<%-- 자바스크립트 탭 내용 부분 시작 --%>
			<div class="tab-content" id="pills-tabContent">

				<%-- 탭 첫 번째 내용 시작 clearfix 처리 --%>
				<div class="tab-pane fade show active clearfix" id="customer_info" role="tabpanel" aria-labelledby="customer_info-tab">

					<%-- 마법사 정보 NAV --%>
					<nav class="navbar navbar-dark bg-dark" style="background-color: #e3f2fd;" id="customer_info_nav">
						<span class="navbar-brand mb-0 h1"><strong>고객 정보</strong></span>
					</nav>

					<%-- 마법 상회 프로필 이미지 --%>
					<img id="customer_img" src="img/customer.png" class="img-fluid" alt="customer image">

					<%-- 탭 두 번째 내용 테이블 시작 --%>
					<div id="customer_info_table">

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
							      <th scope="row">ID</th>
							      <td><%=customerid %></td>
							    </tr>
							    <tr>
							      <th scope="row">이름</th>
							      <td><%=customername %></td>
							    </tr>
							    <tr>
							      <th scope="row">나이</th>
							      <td><%=age %></td>
							    </tr>
							    <tr>
							      <th scope="row">주소</th>
							      <td><%=adress %></td>
							    </tr>
							    <tr>
							      <th scope="row">속성</th>
							      <td><%=attribute %></td>
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
 					<nav class="navbar navbar-dark bg-dark" style="background-color: #e3f2fd;" id="customer_info_nav2">
					  <span class="navbar-brand mb-0 h1"><strong>정보 관리 기능</strong></span>
					</nav>

					<%-- 상회 정보 수정 카드 --%>
					<div class="card" id="customer_info_edit_card" >
						<img src="img/edit.png" class="card-img-top" alt="">
						<div class="card-body">
							<h5 class="card-title">고객 정보 수정</h5>
							<p class="card-text">고객님의 정보가 변경되었다면, 이 기능을 통해 수정하실 수 있습니다.</p>
							<a href="customer_info_modify.jsp" class="btn btn-primary">고객 정보 수정하기</a>
						</div>
					</div>

				</div>
				<%-- 탭 첫 번째 내용 끝 --%>


				<%-- 탭 두 번째 내용 시작 --%>
				<div class="tab-pane fade" id="using_vendor" role="tabpanel" aria-labelledby="using_vendor-tab">

					<%-- 검색창 --%>
				 	<nav class="navbar navbar-light search_block" style="background-color: #e3f2fd;">
					  <a class="navbar-brand">검색(상호, 주소, 대표자 이름, 거래 허가 클래스) </a>
					  <form class="form-inline">
					    <input id="contract_info" class="form-control mr-sm-2" type="search" placeholder="검색어를 입력하세요" aria-label="Search">
					  </form>
					</nav>

					<script type="text/javascript">
				 		$(document).ready(function() {
				            $("#contract_info").keyup(function() {
				                var k = $(this).val();
				                $("#contract_info_table > tbody > tr").hide();
				                var temp = $("#contract_info_table > tbody > tr > td:nth-child(n):contains('" + k + "')");
				                $(temp).parent().show();
				            });
				        });
				 	</script>

					<%-- 탭 두 번째 내용 테이블 시작 --%>
 					<div>
	  					<table class="table table-hover" id="contract_info_table">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">ID</th>
	  								<th scope="col">상호</th>
	  								<th scope="col">주소</th>
	  								<th scope="col">대표자 이름</th>
	  								<th scope="col">거래 허가 클래스</th>
	  								<th scope="col">         </th>
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
									<form action="customer_f_delete.jsp" method="post">
									<td><input type="number" name="magicfirmid" value="<%=magicfirmid%>" class="magicfirmid_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><%=businessname%></td>
									<td><%=adress%></td>
									<td><%=representative%></td>
									<td><%=permissionclass%></td>
									<td><button type="submit" class="btn btn-primary">해지</button></td>
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
				<div class="tab-pane fade" id="not_using_vendor" role="tabpanel" aria-labelledby="not_using_vendor-tab">

					<%-- 검색창 --%>
				 	<nav class="navbar navbar-light search_block" style="background-color: #e3f2fd;">
					  <a class="navbar-brand">검색(상호, 주소, 대표자 이름, 거래 허가 클래스) </a>
					  <form class="form-inline">
					    <input id="not_contract_info" class="form-control mr-sm-2" type="search" placeholder="검색어를 입력하세요" aria-label="Search">
					  </form>
					</nav>

					<script type="text/javascript">
				 		$(document).ready(function() {
				            $("#not_contract_info").keyup(function() {
				                var k = $(this).val();
				                $("#not_contract_info_table > tbody > tr").hide();
				                var temp = $("#not_contract_info_table > tbody > tr > td:nth-child(n):contains('" + k + "')");
				                $(temp).parent().show();
				            });
				        });
				 	</script>

					<%-- 탭 세 번째 내용 테이블 시작 --%>
 					<div>
	  					<table class="table table-hover" id="not_contract_info_table">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">ID</th>
	  								<th scope="col">상호</th>
	  								<th scope="col">주소</th>
	  								<th scope="col">대표자 이름</th>
	  								<th scope="col">거래 허가 클래스</th>
	  								<th scope="col">         </th>
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
									int magicfirmid = result.getInt("magicfirmid");
									String businessname = result.getString("businessname");
									String adress = result.getString("adress");
									String representative = result.getString("representative");
									int permissionclass = result.getInt("permissionclass");
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<form action="customer_f_add.jsp" method="post">
									<td><input type="number" name="magicfirmid" value="<%=magicfirmid%>" class="magicfirmid_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><%=businessname%></td>
									<td><%=adress%></td>
									<td><%=representative%></td>
									<td><%=permissionclass%></td>
									<td><button type="submit" class="btn btn-primary">등록</button></td>
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
				</div>
				<%-- 탭 세 번째 내용 끝 --%>

				<%-- 탭 네 번째 내용 부분 시작 --%>
  				<div class="tab-pane fade" id="buy_magic" role="tabpanel" aria-labelledby="buy_magic-tab">
  					<h3>거래처인 상회의 마법사들이 창조한 마법입니다.</h3>

  					<%-- 검색창 --%>
				 	<nav class="navbar navbar-light search_block" style="background-color: #e3f2fd;">
					  <a class="navbar-brand">검색(이름, 클래스, 속성, 종류) </a>
					  <form class="form-inline">
					    <input id="buy_magic_search" class="form-control mr-sm-2" type="search" placeholder="검색어를 입력하세요" aria-label="Search">
					  </form>
					</nav>

					<script type="text/javascript">
				 		$(document).ready(function() {
				            $("#buy_magic_search").keyup(function() {
				                var k = $(this).val();
				                $("#buy_magic_table > tbody > tr").hide();
				                var temp = $("#buy_magic_table > tbody > tr > td:nth-child(-n+7):contains('" + k + "')");
				                $(temp).parent().show();
				            });
				        });
				 	</script>

  					<%-- 탭 네 번째 내용 테이블 시작 --%>
  					<div>
	  					<table class="table table-hover" id="buy_magic_table">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">상회ID</th>
	  								<th scope="col">마법ID</th>
	  								<th scope="col">이름</th>
	  								<th scope="col">클래스</th>
	  								<th scope="col">속성</th>
	  								<th scope="col">종류</th>
	  								<th scope="col">창조자ID</th>
	  								<th scope="col">가격</th>
	  								<th scope="col">개수</th>	
	  								<th scope="col">       </th>
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
									int magicid = result.getInt("magicid");
									String magicname = result.getString("magicname");
									int magicclass = result.getInt("magicclass");
									String magicattribute = result.getString("magicattribute");
									int createrid = result.getInt("createrid");
									String magictype = result.getString("magictype");
									int sellingprice = result.getInt("sellingprice");
							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<form action="customer_m_buy_result.jsp" method="post">
									<td><input type="number" name="magicfirmid" value="<%=magicfirmid%>" class="magic_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><input type="number" name="magicid" value="<%=magicid%>" class="magic_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><%=magicname%></td>
									<td><%=magicclass%></td>
									<td><%=magicattribute%></td>
									<td><%=magictype%></td>
									<td><input type="number" name="createrid" value="<%=createrid%>" class="magic_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly>
									</td>
									<td><input type="number" name="sellingprice" value="<%=sellingprice%>" class="sellingprice_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly>
									</td>
									<td><input id="magic_buy_amount" type="number" class="form-control" name="amount" min="1" max="500"></td>
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
  				<%-- 탭 네 번째 내용 부분 끝 --%>

  				<%-- 탭 다섯 번째 내용 부분 시작 --%>
 				<div class="tab-pane fade" id="buy_ingredient" role="tabpanel" aria-labelledby="buy_ingredient-tab">
 					<h3>거래처인 상회가 보유하고 있는 재료 목록입니다.</h3>

 					<%-- 검색창 --%>
				 	<nav class="navbar navbar-light search_block" style="background-color: #e3f2fd;">
					  <a class="navbar-brand">검색(이름, 원산지, 종류, 가격) </a>
					  <form class="form-inline">
					    <input id="buy_ingredient_search" class="form-control mr-sm-2" type="search" placeholder="검색어를 입력하세요" aria-label="Search">
					  </form>
					</nav>

					<script type="text/javascript">
				 		$(document).ready(function() {
				            $("#buy_ingredient_search").keyup(function() {
				                var k = $(this).val();
				                $("#buy_ingredient_table > tbody > tr").hide();
				                var temp = $("#buy_ingredient_table > tbody > tr > td:nth-child(-n+7):contains('" + k + "')");
				                $(temp).parent().show();
				            });
				        });
				 	</script>

 					<%-- 탭 다섯 번째 내용 테이블 시작 --%>
 					<div>
	  					<table class="table table-hover" id="buy_ingredient_table">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">상회ID</th>
	  								<th scope="col">재료 ID</th>
	  								<th scope="col">이름</th>
	  								<th scope="col">원산지</th>
	  								<th scope="col">종류</th>
	  								<th scope="col">가격</th>
	  								<th scope="col">재고량</th>
	  								<th scope="col">개수</th>
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
									int magicfirmid = result.getInt("magicfirmid");
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
									<form action="customer_i_buy_result.jsp" method="post">
									<td><input type="number" name="magicfirmid" value="<%=magicfirmid%>" class="ingredient_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><input type="number" name="ingredientid" value="<%=ingredientid%>" class="ingredient_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><%=ingredientname%></td>
									<td><%=origin%></td>
									<td><%=kinds%></td>
									<td><input type="number" name="price" value="<%=price%>" class="ingredient_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
									<td><input type="number" name="instock" value="<%=instock%>" class="ingredient_input" style ="background-color:transparent; border: 0px; -moz-appearance:textfield;" onfocus="this.blur()" readonly></td>
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
  					<%-- 탭 다섯 번째 내용 테이블 끝 --%>

 				</div>
 				<%-- 탭 다섯 번째 내용 부분 끝 --%>

 				<%-- 탭 여섯 번째 내용 부분 시작 --%>
 				<div class="tab-pane fade" id="buy_magic_record" role="tabpanel" aria-labelledby="buy_magic_record-tab">
 					<%-- 탭 여섯 번째 내용 테이블 시작 --%>
 					<div id="buy_magic_record_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">상회ID</th>
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
								result = stmt.executeQuery(query5);

								while (result.next()) {
									int magicfirmid = result.getInt("magicfirmid");
									int magicid = result.getInt("magicid");
									int magicianid = result.getInt("magicianid");
									int amount = result.getInt("amount");
									String purchasedat = result.getString("purchasedat");
	

							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=magicfirmid%></td>
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
  					<%-- 탭 여섯 번째 내용 테이블 끝 --%>

 				</div>
 				<%-- 탭 여섯 번째 내용 부분 끝 --%>

 				<%-- 탭 일곱 번째 내용 부분 시작 --%>
 				<div class="tab-pane fade" id="buy_ingredient_record" role="tabpanel" aria-labelledby="buy_ingredient_record-tab">
 					<%-- 탭 일곱 번째 내용 테이블 시작 --%>
 					<div id="buy_ingredient_record_info">
	  					<table class="table table-hover">
	  						<thead class="thead-light">
	  							<tr>
	  								<th scope="col">상회ID</th>
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
								result = stmt.executeQuery(query6);

								while (result.next()) {
									int magicfirmid = result.getInt("magicfirmid");
									int ingredientid = result.getInt("ingredientid");
									int amount = result.getInt("amount");
									String purchasedat = result.getString("purchasedat");
	

							%>

							<%-- JDBC 끝 --%>
							<tbody>
								<tr>
									<td><%=magicfirmid%></td>
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