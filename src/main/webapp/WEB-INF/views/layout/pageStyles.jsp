<%-- Page-specific styles injected via request attribute "extraStyles" --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty extraStyles}">
  <c:forEach var="cssFile" items="${extraStyles}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/${cssFile}">
  </c:forEach>
</c:if>
<c:if test="${not empty inlineStyle}">
  <style>${inlineStyle}</style>
</c:if>
