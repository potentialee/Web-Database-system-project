<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
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
	String query = "SELECT * FROM magician_information WHERE magicianid = " + logined_id + " AND password = '" + logined_password + "' ";

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
	
<title>로도스 플레임 왕국 데이터 베이스 페이지 - 마법 정보 등록</title>

</head>
<body>
	<div class="container">
		<%-- 타이틀 부분 시작 --%>
		<div id="title_part">
			<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
			<hr class="my-4">
		</div>
		<%--  타이틀 부분 끝 --%>

		<%-- JDBC 시작 --%>
	  		<%
				try {
					String driver = "org.mariadb.jdbc.Driver";
					Class.forName(driver);
					conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
					stmt = conn.createStatement();
					result = stmt.executeQuery(query);

						while (result.next()) {
							String magicattribute = result.getString("magicattribute");
							int magicclass = result.getInt("magicclass");

			%>

			<%-- JDBC 끝 --%>

		<%-- 콘텐츠 부분 시작 --%>
		<div class="p-3 mb-2 bg-light text-dark rounded border" id="content_wrap"> 
			<%-- 폼 부분 시작 --%>
			<div>
				<form action="magic_info_todb.jsp" method="post">

					<%-- 마법 정보 부분 시작 --%>

					<div class="form-group">
						<label> <strong>이름</strong></label> <input type="text" class="form-control" name="magicname"  placeholder="이름을 입력하세요" required>
					</div>

					<div class="form-group">
						<label> <strong>마법 설명</strong></label> <input type="text" class="form-control" name="magicexplanation"  placeholder="설명을 입력하세요" required>
					</div>

					<div class="form-group">
						<label> <strong>클래스</strong></label> <input type="number" class="form-control" name="magicclass" value="1"  min="1" max="<%=magicclass%>" placeholder="클래스를 입력하세요" required>
						<small id="class_help_block" class="form-text text-muted">
  						마법 클래스는 1부터 10까지 있으며 자신의 최대 클래스까지 생성 가능합니다.
						</small>
					</div>

					<div class="form-group">
						<label> <strong>속성</strong></label>
						<select class="custom-select" name="magicattribute" required>
							 <option value="<%=magicattribute%>" selected><%=magicattribute%></option>
						</select>
					</div>

					<div class="form-group">
						<label> <strong>종류</strong></label>
						<select class="custom-select" name="magictype" required>
							 <option value="공격" selected >공격</option>
							 <option value="방어">방어</option>
							 <option value="조작">조작</option>
						</select>
					</div>
					

					<div class="form-group">
						<label> <strong>효과량</strong></label> <input type="number" class="form-control" name="effectivedose" value="0" min="0" max="100" placeholder="효과량을 입력하세요" required>
						<small id="age_help_block" class="form-text text-muted">
  						효과량은 0부터 100까지만 입력할 수 있습니다.
						</small>
					</div>

					<div class="form-group">
						<label> <strong>마나 소모량</strong></label> <input type="number" class="form-control" name="manaconsume"  min="1" max="20000000" placeholder="마나 소모량을 입력하세요" required>
					</div>

					<div class="form-group">
						<label> <strong>판매 가격</strong></label> <input type="number" class="form-control" name="sellingprice"  min="1" max="20000000" placeholder="판매 가격을 입력하세요" required>
					</div>

					<div class="form-group" id="last_form">
						<label> <strong>창조자 ID</strong></label> <input type="number" class="form-control" name="createrid" value="<%=logined_id%>" readonly required>
					</div>

					<%-- 마법 정보 부분 끝 --%>

					<%-- 재료 정보 부분 시작 --%>
					<h2><strong> 마법에 필요한 재료 </strong></h2>
					<p> <strong> 필요한 재료 수 만큼 체크하고 입력하세요. 마법은 무조건 하나 이상의 재료는 필요하며, <br> 최대 세 개의 재료로 탄생합니다. 등록된 재료 ID는 로그인 페이지에서 확인하세요. </strong> </p>

					<div class="input-group mb-3">
						<div class="input-group-prepend">
							<span class="input-group-text">첫 번째 재료 ID / 필요량</span>
						</div>
						<input type="number" class="form-control" aria-label="Text input with checkbox" name="ingredientid1" min="5000" max="6999" required>
						<input type="number" aria-label="needs" min="1" name="needs1" class="form-control" required>
					</div>

					<div class="input-group mb-3">
						<div class="input-group-prepend">
							<div class="input-group-text">
								<input type="checkbox" name="ingredient-2" aria-label="Checkbox for following text input">
							</div>
							<span class="input-group-text">두 번째 재료 ID / 필요량</span>
						</div>
						<input type="number" class="form-control" aria-label="Text input with checkbox" name="ingredientid2" min="5000" max="6999">
						<input type="number" aria-label="needs" name="needs2" min="1" class="form-control">

					</div>

					<div class="input-group mb-3">
						<div class="input-group-prepend">
							<div class="input-group-text">
								<input type="checkbox" name="ingredient-3" aria-label="Checkbox for following text input">
							</div>
							<span class="input-group-text">세 번째 재료 ID / 필요량</span>
						</div>
						<input type="number" class="form-control" name="ingredientid3" aria-label="Text input with checkbox" name="ingredientid3" min="5000" max="6999">
						<input type="number" aria-label="needs" name="needs3" min="1" class="form-control">
					</div>

					<%-- 재료 정보 부분 끝 --%>

					<%-- 등록 버튼 --%>
					<input type="submit" class="btn btn-primary buttonmargin" value="마법 등록">
					<button type="button" class="btn btn-secondary buttonmargin" onClick="history.go(-1)">이전 페이지로 돌아가기</button>

				</form>
			</div>
			<%-- 폼 부분 끝 --%>
		</div>
		<%-- 컨텐츠 부분 끝 --%>

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
</body>
</html>