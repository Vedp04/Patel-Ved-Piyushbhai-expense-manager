<header id="header" class="header fixed-top d-flex align-items-center">
   	
   	<div class="d-flex align-items-center justify-content-between">
    	
    	<a href="/" class="logo d-flex align-items-center">
       		<img src="assets/img/logo.png" alt="">
       		<span class="d-none d-lg-block">ExpenseManager</span>
   		</a>
   		
   	</div><!-- End Logo --> 
   		
   		<i class="bi bi-list toggle-sidebar-btn"></i>
   		
   		<nav class="header-nav ms-auto">
      		
      		<ul class="d-flex align-items-center">
        		
        		<li class="nav-item dropdown">
          			<a class="nav-link nav-icon" href="#" data-bs-toggle="dropdown">
            			<i class="bi bi-bell"></i>
            			<span class="badge bg-primary badge-number"></span>
          			</a><!-- End Notification Icon -->
				</li>
					
        		<li class="nav-item dropdown">
          			<a class="nav-link nav-icon" href="#" data-bs-toggle="dropdown">
            			<i class="bi bi-chat-left-text"></i>
            			<span class="badge bg-success badge-number"></span>
          			</a><!-- End Messages Icon -->
        		</li>
				
				<c:if test="${not empty user}">
        			<li class="nav-item dropdown pe-3">
          				<a class="nav-link nav-profile d-flex align-items-center pe-0 show" href="#" data-bs-toggle="dropdown" aria-expanded="true">
            				<img src="assets/img/profile.avif" alt="Profile" class="rounded-circle">
            				<span class="d-none d-md-block dropdown-toggle ps-2">${user.firstName} ${user.lastName}</span>
          				</a><!-- End Profile Iamge Icon -->

          				<ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow" data-popper-placement="bottom-end" style="position: absolute; inset: 0px 0px auto auto; margin: 0px; transform: translate3d(-16px, 38.4px, 0px);">
         	    			<li class="dropdown-header">
              					<h6>${user.firstName} ${user.lastName}</h6>
            				</li>
            				<li>
              					<hr class="dropdown-divider">
            				</li>
            				<li>
              					<a class="dropdown-item d-flex align-items-center" href="myprofile">
                					<i class="bi bi-person"></i>
                					<span>My Profile</span>
              					</a>
            				</li>
            		
            				<li>
              					<a class="dropdown-item d-flex align-items-center" href="editprofile">
                					<i class="bi bi-pencil"></i>
                					<span>Edit Profile</span>
              					</a>
            				</li>
            		
            		
            				<li>
              					<hr class="dropdown-divider">
            				</li>
            			 
            				<li>
             					 <hr class="dropdown-divider">
            				</li>
            				 
            				<li>
              					<hr class="dropdown-divider">
            				</li>
            				<li>
              					<a class="dropdown-item d-flex align-items-center" href="/logout">
                					<i class="bi bi-box-arrow-right"></i>
                					<span>Log Out</span>
              					</a>
            				</li>
          				</ul><!-- End Profile Dropdown Items -->
        			</li><!-- End Profile Nav -->
				</c:if>
      		</ul>
      		
    	</nav><!-- End Icons Navigation -->
   	
</header>