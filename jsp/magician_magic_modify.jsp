<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>

<%--세션 및 데이터베이스 정보 로드--%>
<%
	request.setCharacterEncoding("EUC-KR");

	String jdbcDriver = "jdbc:mariadb://localhost:3306/chanil";
	String dbUser = "root";
	String dbPass = "235711";

	int logined_id = (Integer) (session.getAttribute("logined_id"));

	int magicid = Integer.parseInt(request.getParameter("magicid"));

	ResultSet result = null;
	Statement stmt = null;
	Connection conn = null;


	// 마법사 정보 가져오는 쿼리
	String query = "SELECT * FROM magic_information WHERE magicid = "+magicid+" ";

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
							String magicexplanation = result.getString("magicexplanation");
							String magicname = result.getString("magicname");
							int magicclass = result.getInt("magicclass");
							int effectivedose = result.getInt("effectivedose");
							int sellingprice = result.getInt("sellingprice");
							int manaconsume =  result.getInt("manaconsume");

			%>

			<%-- JDBC 끝 --%>

		<%-- 콘텐츠 부분 시작 --%>
		<div class="p-3 mb-2 bg-light text-dark rounded border" id="content_wrap"> 
			<%-- 폼 부분 시작 --%>
			<div>
				<form action="magic_mod_result.jsp" method="post">

					<div class="form-group">
						<label> <strong>마법ID</strong></label> <input type="number" class="form-control" name="magicid"  value="<%=magicid%>" style ="-moz-appearance:textfield;" required readonly>
					</div>

					<div class="form-group">
						<label> <strong>이름</strong></label> <input type="text" class="form-control" name="magicname"  value="<%=magicname%>" required>
					</div>

					<div class="form-group">
						<label> <strong>마법 설명</strong></label> <input type="text" class="form-control" name="magicexplanation"  value="<%=magicexplanation%>" required>
					</div>

					<div class="form-group">
						<label> <strong>클래스</strong></label> <input type="number" class="form-control" name="magicclass"min="1" max="<%=magicclass%>" value="<%=magicclass%>" required>
						<small id="class_help_block" class="form-text text-muted">
  						마법 클래스는 1부터 10까지 있지만, 본인의 클래스를 넘어서는 마법은 창조할 수 없습니다.
						</small>
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
						<label> <strong>효과량</strong></label> <input type="number" class="form-control" name="effectivedose" min="0" max="100" value="<%=effectivedose%>" required>
						<small id="age_help_block" class="form-text text-muted">
  						효과량은 0부터 100까지만 입력할 수 있습니다.
						</small>
					</div>

					<div class="form-group">
						<label> <strong>마나 소모량</strong></label> <input type="number" class="form-control" name="manaconsume"  min="1" max="20000000" value="<%=manaconsume%>" required>
					</div>

					<div class="form-group">
						<label> <strong>판매 가격</strong></label> <input type="number" class="form-control" name="sellingprice"  min="1" max="20000000" value="<%=sellingprice%>" required>
					</div>


					<%-- 등록 버튼 --%>
					<input type="submit" class="btn btn-primary buttonmargin" value="수정하기">
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
