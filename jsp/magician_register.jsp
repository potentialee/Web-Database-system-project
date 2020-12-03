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
	
<title>로도스 플레임 왕국 데이터 베이스 페이지 - 마법사 정보 등록 신청</title>
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
				<form action="magician_info_todb.jsp" method="post">

					<div class="form-group">
						<label> <strong>이름</strong></label> <input type="text" class="form-control" name="magicianname"  placeholder="이름을 입력하세요" required>
					</div>

					<div class="form-group">
						<label> <strong>패스워드</strong></label> <input type="password" class="form-control" name="password" placeholder="패스워드를 입력하세요" required>
					</div>
					
					<div class="form-group">
						<label> <strong>나이</strong></label> <input type="number" class="form-control" name="age" min="1" max="2135"  placeholder="나이를 입력하세요" required>
						<small id="age_help_block" class="form-text text-muted">
  						로도스 역사상 암흑의 마법에 의해 절대적으로 가장 오래 산 사람은 다크 엘프인 드리즈트 도어덴이며 2135살입니다. 따라서 2135 까지만 입력할 수 있습니다.
						</small>
					</div>
					
					<div class="form-group">
						<label> <strong>종족</strong></label> <input type="text" class="form-control" name="tribe"  placeholder="종족을 입력하세요" required>
						<small id="tribe_help_block" class="form-text text-muted">
  						플레임 왕국은 어느 신생 종족이든 자유로운 왕국 이므로, 종족이라는 범위를 제한하지 않습니다. 자유롭게 입력하세요.
						</small>
					</div>
					
					<div class="form-group">
						<label> <strong>출신지</strong></label> <input type="text" class="form-control" name="hometown"  placeholder="출신지를 입력하세요" required>
						<small id="home_help_block" class="form-text text-muted">
  						마찬가지입니다. 플레임 왕국은 지역 감정에 의한 분쟁을 법으로 금지하므로, 어느 누구도 출신지에 의해 권리를 침해받지 않습니다.
						</small>
					</div>
					
					<div class="form-group">
						<label> <strong>직업</strong></label> <input type="text" class="form-control" name="job"  placeholder="직업을 입력하세요" required>
						<small id="job_help_block" class="form-text text-muted">
  						직업에는 귀천도 없고 무엇이든 될 수 있습니다. 자유롭게 입력하세요. 없으면 "무직" 입니다.
						</small>
					</div>
					
					<div class="form-group">
						<label> <strong>클래스</strong></label> <input type="number" class="form-control" name="magicclass" min="1" max="10" value="1" placeholder="클래스를 입력하세요" required>
						<small id="class_help_block" class="form-text text-muted">
  						로도스에서 최고의 마법사는 10클래스를 달성한 엘민스터이며, 그는 이렇게 말했습니다. "아마 인간을 초월하여 신이 되어야만 더 높은 수준의 마법이 가능할 것이다."
						</small>
					</div>
					
					<div class="form-group">
						<label> <strong>속성</strong></label>
						<select class="custom-select" name="magicattribute" required>
							 <option value="화염" selected >화염</option>
							 <option value="냉기">냉기</option>
							 <option value="대지">대지</option>
							 <option value="암흑">암흑</option>
							 <option value="바람">바람</option>
						</select>
						<small id="pro_help_block" class="form-text text-muted">
  						태초에 사람들은 화염, 냉기, 대지, 바람, 암흑 등 많은 속성을 발견해냈으나 그들은 계속 말합니다. "새로운 속성은 있다."
						</small>
					</div>

					<div class="form-group">
						<label> <strong>마나량</strong></label> <input type="number" class="form-control" name="manacount" min="0" max="11000000"  placeholder="마나량을 입력하세요" required>
						<small id="mana_help_block" class="form-text text-muted">
  						마나량은 선천적인 특성이며 일생을 살며 절대로 늘어나지 않습니다. 위대한 마법사들은 타고난 것이죠. 엘민스터는 1000만 정도의 마력을 지녔다고 전해집니다.
						</small>
					</div>

					<div class="form-group" id="last_form">
						<label> <strong>소지금</strong></label> <input type="number" class="form-control" name="money" value="1000"  min="1000" max="2000000000" placeholder="소지금을 입력하세요" required>
						<small id="mana_help_block" class="form-text text-muted">
  						플레임 왕국에서는 마법사 데이터 베이스 정보 등록 장려를 위해 등록 시 1000골드를 지급합니다! 1000골드를 합한 자신의 보유 금액을 적어주세요.
						</small>
					</div>

					<input type="submit" class="btn btn-primary" value="마법사 정보 등록 신청">
					<button type="button" class="btn btn-secondary" onclick="location.href='main.html'">로그인 페이지로 돌아가기</button>
				</form>
			</div>
			<%-- 폼 부분 끝 --%>
		</div>
		<%-- 컨텐츠 부분 끝 --%>
	</div>
</body>
</html>
