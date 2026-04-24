<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${not empty account ? 'Edit' : 'Add'} Account — MoneyTrail</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/variables.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">

  <!-- Layout Fix -->
  <style>
    .app-wrapper { display:flex; min-height:100vh; }
    .main-area { display:flex; flex-direction:column; flex:1; }
    .page-content { flex:1; display:flex; justify-content:center; padding-bottom:24px; }
    footer { margin-top:auto; }
  </style>
</head>

<body>

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>

<div class="app-wrapper">
  
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

  <div class="main-area">

    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>

    <main class="page-content">

      <jsp:include page="/WEB-INF/views/components/alert.jsp"/>

      <div style="width:100%; max-width:720px;">

        <!-- Header -->
        <div class="page-header">
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/dashboard">
                  <i class="bi bi-house"></i>
                </a>
              </li>
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/listaccount">Accounts</a>
              </li>
              <li class="breadcrumb-item active">
                ${not empty account ? 'Edit Account' : 'New Account'}
              </li>
            </ol>
          </nav>

          <h1 class="page-title">
            <i class="bi bi-bank2"></i>
            ${not empty account ? 'Edit Account' : 'New Account'}
          </h1>

          <p class="page-subtitle">
            ${not empty account 
              ? 'Update the account details below.' 
              : 'Create a new bank account or wallet to track your finances.'}
          </p>
        </div>

        <!-- Card -->
        <div class="form-card">

          <!-- FORM START -->
          <form action="${pageContext.request.contextPath}/${not empty account ? 'updateaccount' : 'saveaccount'}"
                method="POST" id="accountForm" novalidate>

            <!-- Header -->
            <div class="form-card-header">
              <div class="form-card-header-icon">
                <i class="bi bi-bank2"></i>
              </div>
              <div>
                <div class="form-card-title">Account Details</div>
                <div class="form-card-subtitle">All fields marked with * are required</div>
              </div>
            </div>

            <!-- Body -->
            <div class="form-card-body">

              <c:if test="${not empty account}">
                <input type="hidden" name="accountId" value="${account.accountId}">
              </c:if>

              <!-- Account Name -->
              <div class="form-group">
                <label class="form-label">Account Name *</label>
                <div class="input-wrapper">
                  <i class="bi bi-credit-card input-icon"></i>
                  <input type="text" name="accountName" class="form-input has-icon"
                         required maxlength="100"
                         value="${account.accountName}">
                </div>
              </div>

              <!-- Row -->
              <div class="form-row">

                <div class="form-group">
                  <label class="form-label">Account Type *</label>
                  <select name="accountType" class="form-select" required>
                    <option value="">— Select Type —</option>
                    <option value="Savings" ${account.accountType == 'Savings' ? 'selected' : ''}>Savings</option>
                    <option value="Current" ${account.accountType == 'Current' ? 'selected' : ''}>Current</option>
                    <option value="Cash" ${account.accountType == 'Cash' ? 'selected' : ''}>Cash</option>
                    <option value="Wallet" ${account.accountType == 'Wallet' ? 'selected' : ''}>Wallet</option>
                    <option value="Credit" ${account.accountType == 'Credit' ? 'selected' : ''}>Credit</option>
                  </select>
                </div>

                <div class="form-group">
                  <label class="form-label">Bank Name *</label>
                  <div class="input-wrapper">
                    <i class="bi bi-building input-icon"></i>
                    <input type="text" name="bankName" class="form-input has-icon"
                           required maxlength="100"
                           value="${account.bankName}">
                  </div>
                </div>

              </div>

              <!-- Amount -->
              <div class="form-group">
                <label class="form-label">Opening Balance (₹) *</label>
                <div class="amount-wrapper">
                  <div class="amount-prefix">₹</div>
                  <input type="number" name="openingBalance" class="form-input"
                         required step="0.01"
                         value="${account.openingBalance}">
                </div>
              </div>

              <!-- Switch -->
              <div class="form-group" style="flex-direction:row; gap:12px;">
                <label class="switch">
                  <input type="checkbox" name="exDefault"
                         ${(not empty account && account.exDefault) ? 'checked' : ''}>
                  <span class="switch-track"></span>
                </label>
                <div>
                  <label class="fw-600">Set as Default Account</label>
                  <div class="form-help">Used in transactions</div>
                </div>
              </div>

            </div>

            <!-- Footer -->
            <div class="form-card-footer"
                 style="display:flex; justify-content:flex-end; gap:12px; padding:16px; border-top:1px solid var(--border-color);">

              <a href="${pageContext.request.contextPath}/listaccount" class="btn btn-secondary">
                Cancel
              </a>

              <button type="submit" class="btn btn-primary" id="submitBtn">
                ${not empty account ? 'Update' : 'Save'}
              </button>

            </div>

          </form>
          <!-- FORM END -->

        </div>

      </div>

    </main>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

  </div>
</div>

<script>
document.getElementById('accountForm').addEventListener('submit', function(e){
  if(!this.checkValidity()){
    e.preventDefault();
    this.classList.add('was-validated');
    return;
  }
  const btn = document.getElementById('submitBtn');
  btn.disabled = true;
  btn.innerHTML = 'Saving...';
});
</script>

</body>
</html>