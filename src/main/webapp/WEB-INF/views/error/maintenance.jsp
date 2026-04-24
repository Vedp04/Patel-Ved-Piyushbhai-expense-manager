<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Under Maintenance — MoneyTrail</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/variables.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
</head>
<body>
<div style="min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:40px 20px;text-align:center;background:var(--bg-app);">

  <!-- Brand -->
  <div style="display:flex;align-items:center;gap:12px;margin-bottom:40px;">
    <div style="width:42px;height:42px;background:linear-gradient(135deg,var(--brand-500),var(--accent-500));border-radius:var(--r-lg);display:flex;align-items:center;justify-content:center;">
      <i class="bi bi-currency-rupee text-white" style="font-size:20px;"></i>
    </div>
    <span style="font-size:20px;font-weight:700;color:var(--text-primary);">MoneyTrail</span>
  </div>

  <div style="width:80px;height:80px;background:var(--bg-card);border:2px solid var(--border-color);border-radius:var(--r-xl);display:flex;align-items:center;justify-content:center;margin-bottom:24px;animation:spin 3s linear infinite;">
    <i class="bi bi-gear-fill" style="font-size:36px;color:var(--brand-500);"></i>
  </div>

  <h2 style="font-size:28px;font-weight:700;color:var(--text-primary);margin-bottom:12px;">We'll be right back</h2>
  <p style="color:var(--text-muted);max-width:440px;margin-bottom:12px;line-height:1.7;">
    MoneyTrail is currently undergoing scheduled maintenance to improve your experience.
    We'll be back up shortly.
  </p>
  <p style="color:var(--text-muted);font-size:13px;">
    Expected downtime: <strong style="color:var(--text-primary);">~30 minutes</strong>
  </p>

  <div style="margin-top:32px;padding:16px 24px;background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--r-lg);max-width:340px;">
    <p style="font-size:13px;color:var(--text-muted);margin:0;">
      For urgent queries, contact us at
      <a href="mailto:support@moneytrail.in" style="color:var(--brand-500);">support@moneytrail.in</a>
    </p>
  </div>

</div>
<style>
@keyframes spin { from{transform:rotate(0deg)} to{transform:rotate(360deg)} }
</style>
</body>
</html>
