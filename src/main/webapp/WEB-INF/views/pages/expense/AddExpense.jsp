<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="${not empty theme ? theme : 'dark'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${not empty expense ? 'Edit' : 'Add'} Expense — MoneyTrail</title>
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
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/listexpense">Expenses</a></li>
            <li class="breadcrumb-item active">${not empty expense ? 'Edit Expense' : 'New Expense'}</li>
          </ol>
        </nav>
        <h1 class="page-title"><i class="bi bi-arrow-up-circle-fill" style="color:var(--expense-color);"></i> ${not empty expense ? 'Edit Expense' : 'New Expense'}</h1>
        <p class="page-subtitle">Record a new expense transaction with category, vendor, and payment details.</p>
      </div>

      <div style="max-width:720px;">
        <div class="form-card">
          <div class="form-card-header">
            <div class="form-card-header-icon" style="background:var(--danger-50);color:var(--danger-600);">
              <i class="bi bi-arrow-up-circle-fill"></i>
            </div>
            <div>
              <div class="form-card-title">Expense Details</div>
              <div class="form-card-subtitle">All fields marked with * are required</div>
            </div>
          </div>

          <form action="${pageContext.request.contextPath}/${not empty expense ? 'updateexpense' : 'saveexpense'}"
                method="POST" id="expenseForm" novalidate>

            <c:if test="${not empty expense}">
              <input type="hidden" name="expenseId" value="${expense.expenseId}">
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
                           value="${not empty expense ? expense.amount : ''}">
                  </div>
                </div>
                <div class="form-group">
                  <label class="form-label" for="expenseDate">Date <span class="required">*</span></label>
                  <div class="input-wrapper">
                    <i class="bi bi-calendar3 input-icon"></i>
                    <input type="date" id="expenseDate" name="expenseDate" class="form-input has-icon"
                           required max="${todayDate}"
                           value="${not empty expense ? expense.expenseDate : todayDate}">
                  </div>
                </div>
              </div>

              <!-- Description -->
              <div class="form-group">
                <label class="form-label" for="description">Description</label>
                <div class="input-wrapper">
                  <i class="bi bi-chat-text input-icon"></i>
                  <input type="text" id="description" name="description" class="form-input has-icon"
                         placeholder="Brief description of the expense" maxlength="255"
                         value="${not empty expense ? expense.description : ''}">
                </div>
              </div>

              <!-- Category & SubCategory -->
              <div class="form-row">
                <div class="form-group">
                  <label class="form-label" for="categoryId">Category <span class="required">*</span></label>
                  <select id="categoryId" name="categoryId" class="form-select" required>
                    <option value="">— Select Category —</option>
                    <c:forEach var="cat" items="${categoryList}">
                      <option value="${cat.categoryId}"
                              ${not empty expense && expense.categoryId == cat.categoryId ? 'selected' : ''}>
                        ${cat.categoryName}
                      </option>
                    </c:forEach>
                  </select>
                </div>
                <div class="form-group">
                  <label class="form-label" for="subCategoryId">Sub-Category</label>
                  <select id="subCategoryId" name="subCategoryId" class="form-select">
                    <option value="">— Select Sub-Category —</option>
                    <c:forEach var="sc" items="${subCategoryList}">
                      <option value="${sc.subCategoryId}"
                              data-cat="${sc.categoryId}"
                              ${not empty expense && expense.subCategoryId == sc.subCategoryId ? 'selected' : ''}>
                        ${sc.subCategoryName}
                      </option>
                    </c:forEach>
                  </select>
                </div>
              </div>

              <!-- Vendor & Account -->
              <div class="form-row">
                <div class="form-group">
                  <label class="form-label" for="vendorId">Vendor</label>
                  <select id="vendorId" name="vendorId" class="form-select">
                    <option value="">— Select Vendor —</option>
                    <c:forEach var="v" items="${vendorList}">
                      <option value="${v.vendorId}"
                              ${not empty expense && expense.vendorId == v.vendorId ? 'selected' : ''}>
                        ${v.vendorName}
                      </option>
                    </c:forEach>
                  </select>
                </div>
                <div class="form-group">
                  <label class="form-label" for="accountId">Account <span class="required">*</span></label>
                  <select id="accountId" name="accountId" class="form-select" required>
                    <option value="">— Select Account —</option>
                    <c:forEach var="acc" items="${accountList}">
                      <option value="${acc.accountId}"
                              ${(not empty expense && expense.accountId == acc.accountId) || (empty expense && acc.exDefault) ? 'selected' : ''}>
                        ${acc.accountName} (${acc.bankName})
                      </option>
                    </c:forEach>
                  </select>
                </div>
              </div>

              <!-- Payment Mode & Status -->
              <div class="form-row">
                <div class="form-group">
                  <label class="form-label" for="paymentMode">Payment Mode <span class="required">*</span></label>
                  <select id="paymentMode" name="paymentMode" class="form-select" required>
                    <option value="">— Select Mode —</option>
                    <option value="Cash"        ${not empty expense && expense.paymentMode == 'Cash'        ? 'selected' : ''}>Cash</option>
                    <option value="UPI"         ${not empty expense && expense.paymentMode == 'UPI'         ? 'selected' : ''}>UPI</option>
                    <option value="Net Banking" ${not empty expense && expense.paymentMode == 'Net Banking' ? 'selected' : ''}>Net Banking</option>
                    <option value="Credit Card" ${not empty expense && expense.paymentMode == 'Credit Card' ? 'selected' : ''}>Credit Card</option>
                    <option value="Debit Card"  ${not empty expense && expense.paymentMode == 'Debit Card'  ? 'selected' : ''}>Debit Card</option>
                    <option value="Cheque"      ${not empty expense && expense.paymentMode == 'Cheque'      ? 'selected' : ''}>Cheque</option>
                    <option value="Other"       ${not empty expense && expense.paymentMode == 'Other'       ? 'selected' : ''}>Other</option>
                  </select>
                </div>
                <div class="form-group">
                  <label class="form-label" for="statusId">Status <span class="required">*</span></label>
                  <select id="statusId" name="statusId" class="form-select" required>
                    <option value="">— Select Status —</option>
                    <c:forEach var="st" items="${statusList}">
                      <option value="${st.statusId}"
                              ${not empty expense && expense.statusId == st.statusId ? 'selected' : ''}>
                        ${st.statusName}
                      </option>
                    </c:forEach>
                  </select>
                </div>
              </div>

            </div>

            <div class="form-card-footer">
              <a href="${pageContext.request.contextPath}/listexpense" class="btn btn-secondary">
                <i class="bi bi-x me-1"></i> Cancel
              </a>
              <button type="submit" class="btn btn-danger" id="submitBtn">
                <i class="bi bi-check-lg me-1"></i> ${not empty expense ? 'Update Expense' : 'Save Expense'}
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
  // Filter sub-categories by selected category
  const catSel = document.getElementById('categoryId');
  const scSel  = document.getElementById('subCategoryId');
  const allScOptions = Array.from(scSel.options).map(o => ({
    val: o.value, text: o.text, cat: o.dataset.cat
  }));

  catSel.addEventListener('change', function(){
    const cid = this.value;
    while(scSel.options.length > 1) scSel.remove(1);
    allScOptions.filter(o => !cid || o.cat == cid).forEach(o => {
      const opt = new Option(o.text, o.val);
      scSel.add(opt);
    });
  });

  // Set today's date as default
  if(!document.getElementById('expenseDate').value){
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('expenseDate').value = today;
  }

  document.getElementById('expenseForm').addEventListener('submit', function(e){
    if(!this.checkValidity()){ e.preventDefault(); this.classList.add('was-validated'); return; }
    const btn = document.getElementById('submitBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Saving...';
  });
</script>
</body>
</html>
