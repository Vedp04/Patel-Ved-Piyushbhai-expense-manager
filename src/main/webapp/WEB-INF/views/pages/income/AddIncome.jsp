<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${not empty income ? 'Edit' : 'Add'} Income — MoneyTrail</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/variables.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
</head>
<body>
<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<div class="app-wrapper">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>
  <div class="main-area">
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
    <main class="page-content">

      <jsp:include page="/WEB-INF/views/components/alert.jsp"/>

      <div class="page-header">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-house"></i></a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/listincome">Income</a></li>
            <li class="breadcrumb-item active">${not empty income ? 'Edit Income' : 'New Income'}</li>
          </ol>
        </nav>
        <h1 class="page-title"><i class="bi bi-arrow-down-circle-fill" style="color:var(--income-color);"></i> ${not empty income ? 'Edit Income' : 'New Income'}</h1>
        <p class="page-subtitle">Record an income transaction with source, account, and payment details.</p>
      </div>

      <div style="max-width:680px;">
        <div class="form-card">
          <div class="form-card-header">
            <div class="form-card-header-icon" style="background:var(--success-50);color:var(--success-600);">
              <i class="bi bi-arrow-down-circle-fill"></i>
            </div>
            <div>
              <div class="form-card-title">Income Details</div>
              <div class="form-card-subtitle">All fields marked with * are required</div>
            </div>
          </div>

          <form action="${pageContext.request.contextPath}/${not empty income ? 'updateincome' : 'saveincome'}"
                method="POST" id="incomeForm" novalidate>

            <c:if test="${not empty income}">
              <input type="hidden" name="incomeId" value="${income.incomeId}">
            </c:if>

            <div class="form-card-body">

              <!-- Amount & Date -->
              <div class="form-row">
                <div class="form-group">
                  <label class="form-label" for="amount">Amount (₹) <span class="required">*</span></label>
                  <div class="amount-wrapper">
                    <div class="amount-prefix">₹</div>
                    <input type="number" id="amount" name="amount" class="form-input"
                           placeholder="0.00" required min="0.01" step="0.01"
                           value="${not empty income ? income.amount : ''}">
                  </div>
                </div>
                <div class="form-group">
                  <label class="form-label" for="incomeDate">Date <span class="required">*</span></label>
                  <div class="input-wrapper">
                    <i class="bi bi-calendar3 input-icon"></i>
                    <input type="date" id="incomeDate" name="incomeDate" class="form-input has-icon"
                           required max="${todayDate}"
                           value="${not empty income ? income.incomeDate : todayDate}">
                  </div>
                </div>
              </div>

              <!-- Income Source -->
              <div class="form-group">
                <label class="form-label" for="incomeSource">Income Source <span class="required">*</span></label>
                <div class="input-wrapper">
                  <i class="bi bi-briefcase input-icon"></i>
                  <input type="text" id="incomeSource" name="incomeSource" class="form-input has-icon"
                         placeholder="e.g. Salary, Freelance, Rental Income" required maxlength="150"
                         value="${not empty income ? income.incomeSource : ''}">
                </div>
                <span class="form-help">Describe the source or nature of this income.</span>
              </div>

              <!-- Account & Payment Mode -->
              <div class="form-row">
                <div class="form-group">
                  <label class="form-label" for="accountId">Account <span class="required">*</span></label>
                  <select id="accountId" name="accountId" class="form-select" required>
                    <option value="">— Select Account —</option>
                    <c:forEach var="acc" items="${accountList}">
                      <option value="${acc.accountId}"
                              ${(not empty income && income.accountId == acc.accountId) || (empty income && acc.exDefault) ? 'selected' : ''}>
                        ${acc.accountName} (${acc.bankName})
                      </option>
                    </c:forEach>
                  </select>
                </div>
                <div class="form-group">
                  <label class="form-label" for="paymentMode">Payment Mode <span class="required">*</span></label>
                  <select id="paymentMode" name="paymentMode" class="form-select" required>
                    <option value="">— Select Mode —</option>
                    <option value="Cash"         ${not empty income && income.paymentMode == 'Cash'         ? 'selected' : ''}>Cash</option>
                    <option value="UPI"          ${not empty income && income.paymentMode == 'UPI'          ? 'selected' : ''}>UPI</option>
                    <option value="BANK_TRANSFER"${not empty income && income.paymentMode == 'BANK_TRANSFER'? 'selected' : ''}>BANK_TRANSFER</option>
                    <option value="Net Banking"  ${not empty income && income.paymentMode == 'Net Banking'  ? 'selected' : ''}>Net Banking</option>
                    <option value="NEFT/RTGS"    ${not empty income && income.paymentMode == 'NEFT/RTGS'    ? 'selected' : ''}>NEFT / RTGS</option>
                    <option value="Cheque"       ${not empty income && income.paymentMode == 'Cheque'       ? 'selected' : ''}>Cheque</option>
                    <option value="Other"        ${not empty income && income.paymentMode == 'Other'        ? 'selected' : ''}>Other</option>
                  </select>
                </div>
              </div>

              <!-- Status -->
              <div class="form-group" style="max-width:50%;">
                <label class="form-label" for="statusId">Status <span class="required">*</span></label>
                <select id="statusId" name="statusId" class="form-select" required>
                  <option value="">— Select Status —</option>
                  <c:forEach var="st" items="${statusList}">
                    <option value="${st.statusId}"
                            ${not empty income && income.statusId == st.statusId ? 'selected' : ''}>
                      ${st.statusName}
                    </option>
                  </c:forEach>
                </select>
              </div>

            </div>

            <div class="form-card-footer">
              <a href="${pageContext.request.contextPath}/listincome" class="btn btn-secondary">
                <i class="bi bi-x me-1"></i> Cancel
              </a>
              <button type="submit" class="btn btn-success" id="submitBtn">
                <i class="bi bi-check-lg me-1"></i> ${not empty income ? 'Update Income' : 'Save Income'}
              </button>
            </div>

          </form>
        </div>
      </div>

    </main>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/js/theme-switcher.js"></script>
<script>
  if(!document.getElementById('incomeDate').value){
    document.getElementById('incomeDate').value = new Date().toISOString().split('T')[0];
  }
  document.getElementById('incomeForm').addEventListener('submit', function(e){
    if(!this.checkValidity()){ e.preventDefault(); this.classList.add('was-validated'); return; }
    const btn = document.getElementById('submitBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Saving...';
  });
</script>
</body>
</html>
