<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">

<head>
  	<meta charset="utf-8">
	<meta content="width=device-width, initial-scale=1.0" name="viewport">

  	<title>New Expense | Expense Manager</title>
  	<meta content="" name="description">
  	<meta content="" name="keywords">

  	<!-- Favicons -->
  	<link href="assets/img/favicon.png" rel="icon">
  	<link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  	<!-- Google Fonts -->	
  	<link href="https://fonts.gstatic.com" rel="preconnect">
  	<link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

  	<!-- Vendor CSS Files -->
  	<link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  	<link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  	<link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
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
  	<%@include file="SessionValidate.jsp" %>
  	<!-- End Session Validate -->

  	<!-- ======= Header ======= -->
  	<jsp:include page="AdminHeader.jsp"></jsp:include>
  	<!-- End Header -->

  	<!-- ======= Sidebar ======= -->
  	<jsp:include page="AdminSidebar.jsp"></jsp:include>
  	<!-- End Sidebar-->

  	<main id="main" class="main">

    	<div class="pagetitle">
      		<h1>New Expense</h1>
      		<nav>
        		<ol class="breadcrumb">
          			<li class="breadcrumb-item"><a href="/">Home</a></li>
          			<li class="breadcrumb-item active">New Expense</li>
        		</ol>
      		</nav>
    	</div><!-- End Page Title -->

    	<section class="section dashboard">
			<form action="saveexpense" method="post">
				Title: <input type="text" name="title"> <br><br>
				Category: 
					<select name="categoryId">
						<option value="-1">---Select Category---</option>
						<c:forEach items="${categoryList}" var="category">
							<option value="${category.categoryId}">${category.categoryName}</option>
						</c:forEach>
					</select> <br><br>
				Sub-category:
					<select name="subcategoryId">
						<option value="-1">---Select Sub-category---</option>
						<c:forEach items="${subcategoryList}" var="subcategory">
							<option value="${subcategory.subcategoryId}">${subcategory.subcategoryName}</option>
						</c:forEach>
					</select> <br><br>
				Vendor:
					<select name="vendorId">
						<option value="-1">---Select Vendor---</option>
						<c:forEach items="${vendorList}" var="vendor">
							<option value="${vendor.vendorId}">${vendor.vendorName}</option>
						</c:forEach>
					</select> <br><br>
				Account Type:
					<select name="accountTypeId">
						<option value="-1">---Select Account Type---</option>
						<c:forEach items="${accountList}" var="account">
							<option value="${account.accountId}">${account.title}</option>
						</c:forEach>
					</select> <br><br>
				Status:
					<select name="statusId">
						<option value="-1">---Select Status---</option>
						<c:forEach items="${statusList}" var="status">
							<option value="${status.statusId}">${status.statusName}</option>
						</c:forEach>
					</select> <br><br>
				Amount: <input type="text" name="amount"> <br><br>
				Date: <input type="date" name="date"> <br><br>
				Description: <textarea rows="5" cols="50"></textarea> <br><br>
				User:
					<select name="userId">
						<option value="-1">---Select User---</option>
						<c:forEach items="${userList}" var="user">
							<option value="${user.userId}">${user.firstName} ${user.lastName}</option>
						</c:forEach>
					</select> <br><br>
				<input type="submit" value="Save Expense">
			</form>
    	</section>

  	</main><!-- End #main -->

  	<!-- ======= Footer ======= -->
  	<jsp:include page="AdminFooter.jsp"></jsp:include>
  	<!-- End Footer -->

  	<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

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