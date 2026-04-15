<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
	<c:if test="${empty user}">
		<c:redirect url="login"></c:redirect>
	</c:if>