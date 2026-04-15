<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<title>New Income | Expense Manager</title>
<meta content="" name="description">
<meta content="" name="keywords">

<!-- Favicons -->
<link href="assets/img/favicon.png" rel="icon">
<link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

<!-- Google Fonts -->
<link href="https://fonts.gstatic.com" rel="preconnect">
<link
	href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i"
	rel="stylesheet">

<!-- Vendor CSS Files -->
<link href="assets/vendor/bootstrap/css/bootstrap.min.css"
	rel="stylesheet">
<link href="assets/vendor/bootstrap-icons/bootstrap-icons.css"
	rel="stylesheet">
<link href="assets/vendor/boxicons/css/boxicons.min.css"
	rel="stylesheet">
<link href="assets/vendor/quill/quill.snow.css" rel="stylesheet">
<link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet">
<link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet">
<link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">

<!-- Template Main CSS File -->
<link href="assets/css/style.css" rel="stylesheet">

<!-- =======================================================
  	* Template Name: NiceAdmin
  	* Updated: Jan 29 2024 with Bootstrap v5.3.2
  	* Template URL: https://bootstrapmade.com/nice-admin-bootstrap-admin-html-template/
  	* Author: BootstrapMade.com
  	* License: https://bootstrapmade.com/license/
  	======================================================== -->
</head>

<body>

	<!-- ======= Session Validate ======= -->
	<%@include file="SessionValidate.jsp"%>
	<!-- End Session Validate -->

	<!-- ======= Header ======= -->
	<jsp:include page="UserHeader.jsp"></jsp:include>
	<!-- End Header -->

	<!-- ======= Sidebar ======= -->
	<jsp:include page="UserSidebar.jsp"></jsp:include>
	<!-- End Sidebar-->

	<main id="main" class="main">

		<div class="pagetitle">
			<h1>New Income</h1>
			<nav>
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a href="/">Home</a></li>
					<li class="breadcrumb-item active">New Income</li>
				</ol>
			</nav>
		</div>
		<!-- End Page Title -->

		<section class="section">
			<div class="row">
				<div class="col-lg-8">
					<div class="card">
						<div class="card-body">
							<div class="card-title">New Income</div>
							<form action="usersaveincome" method="post">


								<div class="row mb-3">
									<label for="inputText" class="col-sm-2 col-form-label">Title</label>
									<div class="col-sm-8">
										<input type="text" class="form-control" name="title">
									</div>
								</div>


								<div class="row mb-3">
									<label for="inputText" class="col-sm-2 col-form-label">Amount</label>
									<div class="col-sm-8">
										<input type="text" class="form-control" name="amount">
									</div>
								</div>

								<div class="row mb-3">
									<label for="inputText" class="col-sm-2 col-form-label">Account</label>
									<div class="col-sm-8">
										<select name="accountId" class="form-select">
													<option>--Select Account--</option>
													<c:forEach items="${accounts}" var="a">
														<option value="${a.accountId }">${a.title}</option>
													</c:forEach>
										</select>
									</div>
								</div>

								<div class="row mb-3">
									<label for="inputText" class="col-sm-2 col-form-label">Date</label>
									<div class="col-sm-8">
										<input type="date" class="form-control" name="date">
									</div>
								</div>

								<div class="row mb-3">
									<label for="inputText" class="col-sm-2 col-form-label">Description</label>
									<div class="col-sm-8">
										<textarea name="description" class="form-control"></textarea> 
									</div>
								</div>




								<input type="submit" class="btn btn-primary"
									value="Save Account"> <a href="userlistincome"
									class="btn btn-danger">Cancel</a>

							</form>

						</div>
					</div>
				</div>
			</div>
		</section>

	</main>
	<!-- End #main -->

	<!-- ======= Footer ======= -->
	<jsp:include page="AdminFooter.jsp"></jsp:include>
	<!-- End Footer -->

	<a href="#"
		class="back-to-top d-flex align-items-center justify-content-center"><i
		class="bi bi-arrow-up-short"></i></a>

	<!-- Vendor JS Files -->
	<script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
	<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="assets/vendor/chart.js/chart.umd.js"></script>
	<script src="assets/vendor/echarts/echarts.min.js"></script>
	<script src="assets/vendor/quill/quill.min.js"></script>
	<script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
	<script src="assets/vendor/tinymce/tinymce.min.js"></script>
	<script src="assets/vendor/php-email-form/validate.js"></script>

	<!-- Template Main JS File -->
	<script src="assets/js/main.js"></script>

</body>

</html>