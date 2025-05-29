<%@ page import="java.util.List" %>
<%@ page import="com.project.model.Employee" %>
<%@ page import="com.project.model.SalaryPayment" %>
<%@ page import="com.project.dao.EmployeeDAO" %>
<%@ page import="com.project.dao.SalaryPaymentDAO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<Employee> employees = EmployeeDAO.getAllEmployees();

    String empIdStr = request.getParameter("employeeId");
    List<SalaryPayment> payments = null;
    Employee selectedEmployee = null;
    double totalPaid = 0;
    boolean allEmployees = "ALL".equals(empIdStr);

    // For individual employee
    if (empIdStr != null && !empIdStr.trim().isEmpty() && !allEmployees) {
        try {
            int empId = Integer.parseInt(empIdStr);
            payments = SalaryPaymentDAO.getSalaryPaymentsByEmployeeId(empId);
            selectedEmployee = EmployeeDAO.getEmployeeById(empId);
            for (SalaryPayment sp : payments) {
                totalPaid += sp.getAmount();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // For all employees
    List<SalaryPayment> allPayments = null;
    if (allEmployees) {
        allPayments = SalaryPaymentDAO.getAllSalaryPaymentsWithEmployee(); // You need to implement this
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate Salary Report - Employee Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            backdrop-filter: blur(10px);
            animation: slideIn 0.8s cubic-bezier(0.4, 0, 0.2, 1);
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            padding: 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        .header h2 {
            font-size: 2.5rem;
            font-weight: 300;
            position: relative;
            z-index: 1;
            margin: 0;
        }

        .main-content {
            padding: 40px;
        }

        .selection-section {
            background: white;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .selection-form {
            display: flex;
            gap: 20px;
            align-items: center;
            flex-wrap: wrap;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
            min-width: 250px;
        }

        .form-group label {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group select {
            padding: 15px 20px;
            border: 2px solid #e0e6ed;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
            color: #2c3e50;
            cursor: pointer;
        }

        .form-group select:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            transition: left 0.6s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(52, 152, 219, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(39, 174, 96, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
        }

        .btn-secondary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(149, 165, 166, 0.4);
        }

        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }

        .btn-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(231, 76, 60, 0.4);
        }

        .divider {
            height: 2px;
            background: linear-gradient(90deg, transparent, #3498db, transparent);
            margin: 30px 0;
            border-radius: 1px;
        }

        .report-section {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .report-header {
            background: linear-gradient(135deg, #34495e, #2c3e50);
            color: white;
            padding: 25px 30px;
            border-bottom: 3px solid #3498db;
        }

        .report-header h3 {
            font-size: 1.8rem;
            font-weight: 300;
            margin: 0;
        }

        .report-content {
            padding: 30px;
        }

        .table-container {
            overflow-x: auto;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95rem;
            background: white;
        }

        .table th {
            background: linear-gradient(135deg, #34495e, #2c3e50);
            color: white;
            padding: 18px 15px;
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.85rem;
        }

        .table td {
            padding: 15px;
            border-bottom: 1px solid #ecf0f1;
            color: #2c3e50;
            vertical-align: middle;
        }

        .table tbody tr {
            transition: all 0.3s ease;
        }

        .table tbody tr:hover {
            background: rgba(52, 152, 219, 0.05);
        }

        .table tbody tr:nth-child(even) {
            background: rgba(0, 0, 0, 0.02);
        }

        .total-row {
            background: linear-gradient(135deg, #27ae60, #229954) !important;
            color: white !important;
            font-weight: 600;
        }

        .total-row td {
            border-bottom: none !important;
            color: white !important;
        }

        .currency {
            font-weight: 600;
            color: #27ae60;
        }

        .payment-id {
            font-weight: 600;
            color: #3498db;
        }

        .employee-name {
            font-weight: 600;
            color: #2c3e50;
        }

        .date {
            color: #7f8c8d;
            font-family: 'Courier New', monospace;
        }

        .download-section {
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #ecf0f1;
            text-align: center;
        }

        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }

        .no-data h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #95a5a6;
        }

        .no-data p {
            font-size: 1.1rem;
        }

        .back-link {
            text-align: center;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px solid #ecf0f1;
        }

        .back-link a {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 1.1rem;
        }

        .back-link a:hover {
            color: #2980b9;
            transform: translateX(-5px);
        }

        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            text-align: center;
            border-left: 4px solid #3498db;
        }

        .stat-card h4 {
            color: #7f8c8d;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 10px;
        }

        .stat-card .value {
            color: #2c3e50;
            font-size: 1.8rem;
            font-weight: 600;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }

            .header {
                padding: 30px 20px;
            }

            .header h2 {
                font-size: 2rem;
            }

            .main-content {
                padding: 20px;
            }

            .selection-form {
                flex-direction: column;
                align-items: stretch;
            }

            .form-group {
                min-width: auto;
            }

            .btn {
                width: 100%;
            }

            .table-container {
                font-size: 0.85rem;
            }

            .stats-cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>📊 Generate Salary Report</h2>
        </div>

        <div class="main-content">
            <!-- Selection Form -->
            <div class="selection-section">
                <form method="get" action="generateReport.jsp" class="selection-form">
                    <div class="form-group">
                        <label for="employeeId">Select Employee:</label>
                        <select name="employeeId" id="employeeId" required>
                            <option value="">-- Select Employee --</option>
                            <option value="ALL" <%= allEmployees ? "selected" : "" %>>📈 All Employees</option>
                            <% for (Employee emp : employees) { %>
                                <option value="<%= emp.getId() %>" <%= (empIdStr != null && !allEmployees && emp.getId() == Integer.parseInt(empIdStr)) ? "selected" : "" %>>
                                    <%= emp.getName() %> (ID: <%= emp.getId() %>)
                                </option>
                            <% } %>
                        </select>
                    </div>
                    <input type="submit" class="btn btn-primary" value="📊 Generate Report" />
                </form>
            </div>

            <div class="divider"></div>

            <!-- Report for Individual Employee -->
            <% if (payments != null && !payments.isEmpty()) { %>
                <div class="report-section">
                    <div class="report-header">
                        <h3>💰 Salary Report for <%= selectedEmployee.getName() %> (ID: <%= selectedEmployee.getId() %>)</h3>
                    </div>
                    <div class="report-content">
                        <div class="stats-cards">
                            <div class="stat-card">
                                <h4>Total Payments</h4>
                                <div class="value"><%= payments.size() %></div>
                            </div>
                            <div class="stat-card">
                                <h4>Total Amount Paid</h4>
                                <div class="value currency">₹<%= String.format("%.2f", totalPaid) %></div>
                            </div>
                        </div>

                        <div class="table-container">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Payment ID</th>
                                        <th>Amount</th>
                                        <th>Payment Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (SalaryPayment sp : payments) { %>
                                        <tr>
                                            <td><span class="payment-id">#<%= sp.getId() %></span></td>
                                            <td><span class="currency">₹<%= String.format("%.2f", sp.getAmount()) %></span></td>
                                            <td><span class="date"><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(sp.getPaymentDate()) %></span></td>
                                        </tr>
                                    <% } %>
                                    <tr class="total-row">
                                        <td colspan="2" style="text-align:right;">
                                            <strong>💰 Total Paid:</strong>
                                        </td>
                                        <td>
                                            <strong>₹<%= String.format("%.2f", totalPaid) %></strong>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="download-section">
                            <form method="post" action="GenerateSlipServlet">
                                <input type="hidden" name="employeeId" value="<%= selectedEmployee.getId() %>">
                                <input type="submit" class="btn btn-success" value="📄 Download Salary Slip as PDF">
                            </form>
                        </div>
                    </div>
                </div>

            <% } else if (allEmployees && allPayments != null && !allPayments.isEmpty()) { %>
                <div class="report-section">
                    <div class="report-header">
                        <h3>📈 Salary Report for All Employees</h3>
                    </div>
                    <div class="report-content">
                        <div class="table-container">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Employee Name</th>
                                        <th>Payment ID</th>
                                        <th>Amount</th>
                                        <th>Payment Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% String lastEmp = ""; double total = 0;
                                       for (SalaryPayment sp : allPayments) {
                                           Employee emp = sp.getEmployee(); // assumes SalaryPayment includes employee
                                           if (!emp.getName().equals(lastEmp) && !lastEmp.isEmpty()) {
                                    %>
                                    <tr class="total-row">
                                        <td colspan="3" style="text-align:right;"><strong>Total for <%= lastEmp %>:</strong></td>
                                        <td><strong>₹<%= String.format("%.2f", total) %></strong></td>
                                    </tr>
                                    <% total = 0; } %>
                                    <tr>
                                        <td><span class="employee-name"><%= emp.getName() %></span></td>
                                        <td><span class="payment-id">#<%= sp.getId() %></span></td>
                                        <td><span class="currency">₹<%= String.format("%.2f", sp.getAmount()) %></span></td>
                                        <td><span class="date"><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(sp.getPaymentDate()) %></span></td>
                                    </tr>
                                    <% total += sp.getAmount(); lastEmp = emp.getName(); } %>
                                    <tr class="total-row">
                                        <td colspan="3" style="text-align:right;"><strong>Total for <%= lastEmp %>:</strong></td>
                                        <td><strong>₹<%= String.format("%.2f", total) %></strong></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="download-section">
                            <form method="post" action="GenerateAllSlipServlet">
                                <input type="submit" class="btn btn-success" value="📄 Download Combined Report as PDF">
                            </form>
                        </div>
                    </div>
                </div>

            <% } else if (empIdStr != null) { %>
                <div class="report-section">
                    <div class="no-data">
                        <h3>📋 No Data Found</h3>
                        <p>No salary payment records were found for the selected criteria.</p>
                    </div>
                </div>
            <% } %>

            <div class="back-link">
                <a href="dashboard.jsp">← Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>