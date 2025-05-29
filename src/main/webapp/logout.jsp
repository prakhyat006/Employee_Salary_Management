<%
    session.invalidate();  // Invalidate session
    response.sendRedirect("login.jsp");  // Redirect to login page
%>