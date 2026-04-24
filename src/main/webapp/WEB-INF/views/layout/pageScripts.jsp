<%-- Page-specific scripts injected via request attribute "extraJs" --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty extraJs}">
  <c:forEach var="jsFile" items="${extraJs}">
    <script src="${pageContext.request.contextPath}/js/${jsFile}"></script>
  </c:forEach>
</c:if>
<c:if test="${not empty inlineScript}">
  <script>${inlineScript}</script>
</c:if>
