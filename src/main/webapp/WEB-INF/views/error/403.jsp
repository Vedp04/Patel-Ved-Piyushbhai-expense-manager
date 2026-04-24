<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>403 Forbidden — MoneyTrail</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/variables.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body style="display:flex;align-items:center;justify-content:center;min-height:100vh;background:var(--bg-app);">
  <div style="text-align:center;max-width:480px;padding:var(--sp-8);animation:authIn 0.4s var(--ease-spring);">
    <div style="font-size:120px;font-weight:900;letter-spacing:-0.08em;color:var(--warning-500);line-height:1;font-family:var(--font-mono);">403</div>
    <div style="width:64px;height:4px;background:linear-gradient(90deg,var(--brand-500),var(--accent-500));border-radius:var(--r-full);margin:var(--sp-4) auto;"></div>
    <h1 style="font-size:var(--text-2xl);font-weight:700;color:var(--text-primary);margin-bottom:var(--sp-3);">Access Denied</h1>
    <p style="color:var(--text-muted);font-size:var(--text-base);line-height:1.7;margin-bottom:var(--sp-8);">
      You don't have permission to access this page. If you believe this is a mistake, please contact your administrator.
    </p>
    <div style="display:flex;gap:var(--sp-3);justify-content:center;">
      <a href="${pageContext.request.contextPath}/dashboard"
         style="display:inline-flex;align-items:center;gap:var(--sp-2);padding:0 var(--sp-5);height:42px;background:var(--brand-500);color:#fff;border-radius:var(--r-lg);font-weight:600;font-size:var(--text-sm);text-decoration:none;font-family:var(--font-sans);">
        <i class="bi bi-house-fill"></i> Go to Dashboard
      </a>
      <a href="${pageContext.request.contextPath}/login"
         style="display:inline-flex;align-items:center;gap:var(--sp-2);padding:0 var(--sp-5);height:42px;background:var(--bg-card);border:1px solid var(--border-color);color:var(--text-secondary);border-radius:var(--r-lg);font-weight:600;font-size:var(--text-sm);text-decoration:none;font-family:var(--font-sans);">
        <i class="bi bi-box-arrow-in-right"></i> Sign In
      </a>
    </div>
  </div>
<style>
@keyframes authIn { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }
</style>
</body>
</html>
