<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>404 Not Found — MoneyTrail</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/variables.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body style="display:flex;align-items:center;justify-content:center;min-height:100vh;background:var(--bg-app);">
  <div style="text-align:center;max-width:480px;padding:var(--sp-8);animation:authIn 0.4s var(--ease-spring);">
    <div style="font-size:120px;font-weight:900;letter-spacing:-0.08em;color:var(--accent-500);line-height:1;font-family:var(--font-mono);">404</div>
    <div style="width:64px;height:4px;background:linear-gradient(90deg,var(--accent-500),var(--brand-500));border-radius:var(--r-full);margin:var(--sp-4) auto;"></div>
    <h1 style="font-size:var(--text-2xl);font-weight:700;color:var(--text-primary);margin-bottom:var(--sp-3);">Page Not Found</h1>
    <p style="color:var(--text-muted);font-size:var(--text-base);line-height:1.7;margin-bottom:var(--sp-8);">
      The page you're looking for doesn't exist or may have been moved. Let's get you back on track.
    </p>
    <a href="${pageContext.request.contextPath}/dashboard"
       style="display:inline-flex;align-items:center;gap:var(--sp-2);padding:0 var(--sp-6);height:44px;background:var(--brand-500);color:#fff;border-radius:var(--r-lg);font-weight:600;font-size:var(--text-sm);text-decoration:none;font-family:var(--font-sans);box-shadow:0 4px 14px rgba(18,179,131,0.3);">
      <i class="bi bi-arrow-left-circle-fill"></i> Back to Dashboard
    </a>
  </div>
<style>
@keyframes authIn { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }
</style>
</body>
</html>
