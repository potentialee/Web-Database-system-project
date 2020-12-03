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
	<link rel="stylesheet" type="text/css" href="for_common_edit.css" media="all">
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css" media="all">
	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.0/js/bootstrap.min.js" integrity="sha384-3qaqj0lc6sV/qpzrc1N5DC6i1VRn/HyX4qdPaiEFbn54VjQBEU341pvjz7Dv3n6P" crossorigin="anonymous"></script>

	<title>로도스 플레임 왕국 데이터 베이스 페이지 - 관리자 로그인 페이지</title>
	
</head>
<body>
	<%--세션 로그아웃 처리--%>
	<% 
		session.invalidate();
		response.sendRedirect("main.html");
	%>
</body>
</html>