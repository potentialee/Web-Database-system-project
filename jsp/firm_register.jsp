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
	
<title>로도스 플레임 왕국 데이터 베이스 페이지 - 상회 창설 / 정보 등록 신청</title>
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
				<form action="firm_info_todb.jsp" method="post">

					<div class="form-group">
						<label> <strong>상호</strong></label> <input type="text" class="form-control" name="businessname"  placeholder="상호를 입력하세요" required>
					</div>

					<div class="form-group">
						<label> <strong>패스워드</strong></label> <input type="password" class="form-control" name="password" placeholder="패스워드를 입력하세요" required>
					</div>
					
					<div class="form-group">
						<label> <strong>주소</strong></label> <input type="text" class="form-control" name="adress"  placeholder="주소를 입력하세요" required>
					</div>
					
					<div class="form-group">
						<label> <strong>대표자 이름</strong></label> <input type="text" class="form-control" name="representative"  placeholder="대표자 이름을 입력하세요" required>
					</div>
					
					<div class="form-group">
						<label> <strong>거래 허가 클래스</strong></label> <input type="number" class="form-control" name="permissionclass" min="1" max="10" value="1" placeholder="거래 허가 클래스를 입력하세요" required>
						<small id="job_help_block" class="form-text text-muted">
  						거래 허가 클래스보다 높은 마법을 매입하다가 적발될 경우 하울드-위저드들의 심판이 기다립니다.
						</small>
					</div>
					
					<div class="form-group" id="last_form">
						<label> <strong>소지금</strong></label> <input type="number" class="form-control" name="money" value="10000"  min="10000" max="2000000000" placeholder="소지금을 입력하세요" required>
						<small id="money_help_block" class="form-text text-muted">
  						플레임 왕국에서는 상회 창설 / 정보 등록 장려를 위해 10000골드를 등록 시 지급합니다! 10000골드를 합한 상회 보유 금액을 입력하세요.
						</small>
					</div>

					<input type="submit" class="btn btn-primary" value="상회 창설 / 정보 등록 신청">
					<button type="button" class="btn btn-secondary" onclick="location.href='main.html'">로그인 페이지로 돌아가기</button>
				</form>
			</div>
			<%-- 폼 부분 끝 --%>
		</div>
		<%-- 컨텐츠 부분 끝 --%>
	</div>
</body>
</html>
