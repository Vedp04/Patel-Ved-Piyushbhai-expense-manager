<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">

<head>
  	<meta charset="utf-8">
	<meta content="width=device-width, initial-scale=1.0" name="viewport">

  	<title>New User | Expense Manager</title>
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
      		<h1>New User</h1>
      		<nav>
        		<ol class="breadcrumb">
          			<li class="breadcrumb-item"><a href="/">Home</a></li>
          			<li class="breadcrumb-item active">New User</li>
        		</ol>
      		</nav>
    	</div><!-- End Page Title -->

    	<section class="section dashboard">
			<form action="saveuser" method="post">
 				First Name: <input type="text" name="firstName"> <br><br>
 				Last Name: <input type="text" name="lastName"> <br><br>
 				Gender: <br>
 					&emsp; <input type="radio" value="Male" name="gender"> Male <br>
 					&emsp; <input type="radio" value="Female" name="gender"> Female <br><br>
 				Date of Birth: <input type="date" name="dateOfBirth"> <br><br>
 				Address: <textarea rows=5 cols=50></textarea> <br><br>
 				State: 
 					<select name="state">
 						<option value="-1">---Select State---</option>
 						<option value="Gujarat"> Gujarat </option>
 						<option value="Rajasthan"> Rajasthan </option>
 						<option value="Maharashtra"> Maharashtra </option>
 					</select> <br><br>
 				City: 
 					<select name="city">
 						<option value="-1">---Select City---</option>
 						<option value="Ahmedabad"> Ahmedabad </option>
 						<option value="Bhavnagar"> Bhavnagar </option>
 						<option value="Jaypur"> Jaypur </option>
 						<option value="Mumbai"> Mumbai </option>
 					</select> <br><br>
 				Contact Number: <input type="text" name="contactNumber"> <br><br>
 				Email Address: <input type="text" name="emailAddress"> <br><br>
 				Password: <input type="password" name="password"> <br><br>
 				Role: 
 					<select name="roleId">
 						<option value="-1">---Select Role---</option>
 						<c:forEach items="${roleList}" var="role">
 							<option value=${role.roleId}>${role.roleName}</option>
 						</c:forEach>
 					</select> <br><br>
 				<input type="submit" value="Save User">
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