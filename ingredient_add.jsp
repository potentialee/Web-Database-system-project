<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
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
	
<title>로도스 플레임 왕국 데이터 베이스 페이지 - 재료 정보 등록</title>
</head>
<body>
	<div class="container">
		<%-- 타이틀 부분 시작 --%>
		<div id="title_part">
			<h1><strong>로도스의 플레임 왕국 </strong><span class="badge badge-secondary">데이터베이스 시스템</span></h1>
			<hr class="my-4">
		</div>
		<%--  타이틀 부분 끝 --%>

		<%-- 콘텐츠 부분 시작 --%>
		<div class="p-3 mb-2 bg-light text-dark rounded border" id="content_wrap"> 
			<%-- 폼 부분 시작 --%>
			<div>
				<form action="ingredient_info_todb.jsp" method="post">

					<div class="form-group">
						<label> <strong>이름</strong></label> <input type="text" class="form-control" name="ingredientname"  placeholder="이름을 입력하세요" required>
					</div>

					<div class="form-group">
						<label> <strong>원산지</strong></label> <input type="text" class="form-control" name="origin"  placeholder="원산지를 입력하세요" required>
					</div>

					<div class="form-group">
						<label> <strong>종류</strong></label> <input type="text" class="form-control" name="kinds"  placeholder="종류를 입력하세요" required>
					</div>
					
					<div class="form-group" id="last_form">
						<label> <strong>가격</strong></label> <input type="number" class="form-control" name="price"  min="1" max="20000000" placeholder="가격을 입력하세요" required>
					</div>

					<input type="submit" class="btn btn-primary" value="재료 등록">
					<button type="button" class="btn btn-secondary" onClick="history.go(-1)">이전 페이지로 돌아가기</button>

				</form>
			</div>
			<%-- 폼 부분 끝 --%>
		</div>
		<%-- 컨텐츠 부분 끝 --%>
	</div>
</body>
</html>