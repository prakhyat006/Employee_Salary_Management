<%@ page import="java.util.*, com.project.model.SalaryPayment, com.project.model.Employee, com.project.dao.SalaryPaymentDAO" %>
<%
    List<SalaryPayment> payments = SalaryPaymentDAO.getAllSalaryPaymentsWithEmployee();
    String lastEmployee = "";
    double totalForEmployee = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <title>All Salary Payments Report</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9fafd;
            margin: 30px;
            color: #333;
        }

        h2 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 25px;
            font-weight: 700;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            background-color: #fff;
            border-radius: 6px;
            overflow: hidden;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border: 1px solid #ddd;
        }

        tr:nth-child(even) {
            background-color: #f2f7fb;
        }

        tr:hover {
            background-color: #d1e7fd;
        }

        th {
            background-color: #2980b9;
            color: white;
        }

        td[colspan="4"] {
            font-weight: 700;
            color: #1a5276;
            background-color: #eaf4fc;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            background-color: #2980b9;
            color: white;
            padding: 8px 18px;
            border-radius: 4px;
            font-weight: 600;
            transition: background-color 0.3s ease;
        }

        a:hover {
            background-color: #1c5980;
        }
    </style>
</head>
<body>
    <h2>All Salary Payments</h2>
    <table>
        <tr>
            <th>Employee</th>
            <th>Payment ID</th>
            <th>Amount</th>
            <th>Payment Date</th>
        </tr>
        <% for (int i = 0; i < payments.size(); i++) {
            SalaryPayment sp = payments.get(i);
            String empName = (sp.getEmployee() != null && sp.getEmployee().getName() != null) 
                                ? sp.getEmployee().getName() 
                                : "Unknown";

            if (!empName.equals(lastEmployee) && i != 0) {
        %>
            <tr>
                <td colspan="4" style="text-align:right">
                    <b>Total for <%= lastEmployee %>: &#8377;<%= String.format("%.2f", totalForEmployee) %></b>
                </td>
            </tr>
        <% 
            totalForEmployee = 0; 
            } 
        %>
        <tr>
            <td><%= empName %></td>
            <td><%= sp.getId() %></td>
            <td>&#8377;<%= String.format("%.2f", sp.getAmount()) %></td>
            <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(sp.getPaymentDate()) %></td>
        </tr>
        <%
            lastEmployee = empName;
            totalForEmployee += sp.getAmount();

            if (i == payments.size() - 1) {
        %>
            <tr>
                <td colspan="4" style="text-align:right">
                    <b>Total for <%= lastEmployee %>: &#8377;<%= String.format("%.2f", totalForEmployee) %></b>
                </td>
            </tr>
        <%  
            } 
        } %>
    </table>
    <br>
    <a href="dashboard.jsp">Back to Dashboard</a>
</body>
</html>
