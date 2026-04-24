<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty successMsg}">
  <div class="alert alert-success" role="alert" id="autoAlert">
    <div class="alert-icon"><i class="bi bi-check-circle-fill"></i></div>
    <div><div class="alert-title">${successMsg}</div></div>
    <button type="button" class="alert-close" onclick="this.closest('.alert').remove()">&times;</button>
  </div>
</c:if>

<c:if test="${not empty errorMsg}">
  <div class="alert alert-danger" role="alert" id="autoAlert">
    <div class="alert-icon"><i class="bi bi-exclamation-triangle-fill"></i></div>
    <div><div class="alert-title">${errorMsg}</div></div>
    <button type="button" class="alert-close" onclick="this.closest('.alert').remove()">&times;</button>
  </div>
</c:if>

<c:if test="${not empty error}">
  <div class="alert alert-danger" role="alert">
    <div class="alert-icon"><i class="bi bi-exclamation-circle-fill"></i></div>
    <div>${error}</div>
    <button type="button" class="alert-close" onclick="this.closest('.alert').remove()">&times;</button>
  </div>
</c:if>

<c:if test="${not empty success}">
  <div class="alert alert-success" role="alert">
    <div class="alert-icon"><i class="bi bi-check-circle-fill"></i></div>
    <div>${success}</div>
    <button type="button" class="alert-close" onclick="this.closest('.alert').remove()">&times;</button>
  </div>
</c:if>

<c:if test="${not empty info}">
  <div class="alert alert-info" role="alert">
    <div class="alert-icon"><i class="bi bi-info-circle-fill"></i></div>
    <div>${info}</div>
    <button type="button" class="alert-close" onclick="this.closest('.alert').remove()">&times;</button>
  </div>
</c:if>

<script>
  // Auto-dismiss alerts after 5 seconds
  (function(){
    var el = document.getElementById('autoAlert');
    if(el) { setTimeout(function(){ el.style.opacity='0'; el.style.transition='opacity 0.4s'; setTimeout(function(){ el.remove(); },400); }, 5000); }
  })();
</script>
