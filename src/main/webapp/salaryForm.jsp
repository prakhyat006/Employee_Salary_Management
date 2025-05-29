<%@ page import="com.project.model.SalaryPayment" %>

<%
    SalaryPayment sp = (SalaryPayment) request.getAttribute("salaryPayment");
    boolean isEdit = (sp != null);
%>

<h2><%= isEdit ? "Edit Salary Payment" : "Add Salary Payment" %></h2>

<form method="post" action="SalaryServlet">
    <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>" />
    <% if (isEdit) { %>
        <input type="hidden" name="id" value="<%= sp.getId() %>" />
    <% } %>

    Employee ID: <input type="number" name="employee_id" value="<%= isEdit ? sp.getEmployeeId() : "" %>" required /><br><br>
    Amount: <input type="number" step="0.01" name="amount" value="<%= isEdit ? sp.getAmount() : "" %>" required /><br><br>
    Payment Date: <input type="date" name="payment_date" value="<%= isEdit ? sp.getPaymentDate() : "" %>" required /><br><br>

    <input type="submit" value="<%= isEdit ? "Update" : "Add" %>" />
</form>
