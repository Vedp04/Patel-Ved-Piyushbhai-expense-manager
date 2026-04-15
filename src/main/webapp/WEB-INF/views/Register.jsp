<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>Register | ExpenseManager</title>
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

  <main>
    <div class="container">

      <section class="section register min-vh-100 d-flex flex-column align-items-center justify-content-center py-4">
        <div class="container">
          <div class="row justify-content-center">
            <div class="col-lg-4 col-md-6 d-flex flex-column align-items-center justify-content-center">

              <div class="d-flex justify-content-center py-4">
                <a href="/" class="logo d-flex align-items-center w-auto">
                  <img src="assets/img/logo.png" alt="">
                  <span class="d-none d-lg-block">ExpenseManager</span>
                </a>
              </div><!-- End Logo -->

              <div class="card mb-3">

                <div class="card-body">

                  <div class="pt-4 pb-2">
                    <h5 class="card-title text-center pb-0 fs-4">Create an Account</h5>
                    <p class="text-center small">Enter your personal details to create account</p>
                  </div>
                  
                  <div class="small mb-0">
                    <span style="color:red">${error}</span>
                    <span style="color:red">${passwordError}</span>
				  </div>

                  <form action="saveperson" method="post" class="row g-3 needs-validation" novalidate>
                   
                    <div class="col-12">
                      <label for="firstName" class="form-label">First Name</label>
                      <input type="text" name="firstName" class="form-control" id="firstName" required>
                      <div class="invalid-feedback">Please, enter your first name!</div>
                    </div>
                    
                    <div class="col-12">
                      <label for="lastName" class="form-label">Last Name</label>
                      <input type="text" name="lastName" class="form-control" id="lastName" required>
                      <div class="invalid-feedback">Please, enter your last name!</div>
                    </div>
                    
                    <div class="col-12"> 
                      <label for="gender" class="form-label">Gender</label>
                      <div class="form-check">
                        <input class="form-check-input" type="radio" name="gender" id="male" value="Male" checked="true">
                        <label class="form-check-label" for="male">Male</label>
                      </div>
                      <div class="form-check">
                        <input class="form-check-input" type="radio" name="gender" id="female" value="Female">
                      	<label class="form-check-label" for="female">Female</label>
                      </div>
                    </div>

					<div class="col-12">
                  	  <label for="dateOfBirth">Date of Birth</label><br>
                      <input type="date" name="dateOfBirth" class="form-control" id="dateOfBirth">
                    </div>
                    
                    <div class="col-12">
                  	  <label for="address">Address</label>
                      <textarea name="address" class="form-control" id="address" style="height: 100px"></textarea>
                    </div>
                    
                    <div class="col-12">
                  	  <label for="city" class="col-sm-2 col-form-label">City</label>
                      <select name="city" class="form-select" id="city" aria-label="Default select example">
                      	<option value="-1">---Select City---</option>
                      	<option value="Bhavnagar">Bhavnagar</option>
                      	<option value="Ahmedabad">Ahmedabad</option>
                      	<option value="Gandhinagar">Gandhinagar</option>
                      </select>
                	</div>
                	
                	<div class="col-12">
                  	  <label for="state" class="col-sm-2 col-form-label">State</label>
                      <select name="state" class="form-select" id="state" aria-label="Default select example">
                      	<option value="-1">---Select State---</option>
                      	<option value="Gujarat">Gujarat</option>
                      	<option value="Maharashtra">Maharashtra</option>
                      	<option value="Rajasthan">Rajasthan</option>
                      </select>
                	</div>

                    <div class="col-12">
                      <label for="emailAddress" class="form-label">Email Address</label>
                      <input type="email" name="emailAddress" class="form-control" id="emailAddress" required>
                      <div class="invalid-feedback">Please enter a valid email adddress!</div>
                    </div>

                    <div class="col-12">
                      <label for="contactNumber" class="form-label">Contact Number</label>
                      <input type="text" name="contactNumber" class="form-control" id="contactNumber" required>
                      <div class="invalid-feedback">Please enter your contact number!</div>
                    </div>

                    <div class="col-12">
                      <label for="password" class="form-label">Password</label>
                      <input type="password" name="password" class="form-control" id="password" required>
                      <div class="invalid-feedback">Please enter your password!</div>
                    </div>
                    
                    <div class="col-12">
                      <label for="confirmPassword" class="form-label">Confirm Password</label>
                      <input type="password" name="confirmPassword" class="form-control" id="confirmPassword" required>
                      <div class="invalid-feedback">Please enter confirm password!</div>
                    </div>
                    
                    <div class="col-12">
                      <div class="form-check">
                        <input class="form-check-input" name="terms" type="checkbox" value="" id="acceptTerms" required>
                        <label class="form-check-label" for="acceptTerms">I agree and accept the <a href="#">terms and conditions</a></label>
                        <div class="invalid-feedback">You must agree before submitting.</div>
                      </div>
                    </div>
                    
                    <div class="col-12">
                      <button class="btn btn-primary w-100" type="submit">Create Account</button>
                    </div>
                    
                    <div class="col-12">
                      <p class="small mb-0">Already have an account? <a href="login">Log in</a></p>
                    </div>
                    
                  </form>

                </div>
              </div>

              <div class="credits">
                <!-- All the links in the footer should remain intact. -->
                <!-- You can delete the links only if you purchased the pro version. -->
                <!-- Licensing information: https://bootstrapmade.com/license/ -->
                <!-- Purchase the pro version with working PHP/AJAX contact form: https://bootstrapmade.com/nice-admin-bootstrap-admin-html-template/ -->
                <p>Developed by Ved Patel</p>
              </div>

            </div>
          </div>
        </div>

      </section>

    </div>
  </main><!-- End #main -->

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