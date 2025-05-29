<%@ page import="java.util.List" %>
<%@ page import="com.project.model.SalaryPayment" %>

<%
    List<SalaryPayment> salaryList = (List<SalaryPayment>) request.getAttribute("salaryList");
%>

<h2>Salary Payments</h2>

<a href="salaryForm.jsp">Add New Payment</a><br><br>

<table border="1" cellpadding="5" cellspacing="0">
    <tr>
        <th>ID</th><th>Employee ID</th><th>Amount</th><th>Payment Date</th><th>Actions</th>
    </tr>
    <%
        if (salaryList != null) {
            for (SalaryPayment sp : salaryList) {
    %>
    <tr>
        <td><%= sp.getId() %></td>
        <td><%= sp.getEmployeeId() %></td>
        <td><%= sp.getAmount() %></td>
        <td><%= sp.getPaymentDate() %></td>
        <td>
            <a href="SalaryServlet?action=edit&id=<%= sp.getId() %>">Edit</a> |
            <a href="SalaryServlet?action=delete&id=<%= sp.getId() %>" onclick="return confirm('Are you sure?');">Delete</a>
        </td>
    </tr>
    <%
            }
        } else {
    %>
    <tr><td colspan="5">No records found.</td></tr>
    <%
        }
    %>
</table>
