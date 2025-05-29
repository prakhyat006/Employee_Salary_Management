<%@ page import="java.util.List" %>
<%@ page import="com.project.model.Employee" %>
<%@ page import="com.project.model.SalaryPayment" %>
<%@ page import="com.project.dao.EmployeeDAO" %>
<%@ page import="com.project.dao.SalaryPaymentDAO" %>
<%
List<Employee> employees = EmployeeDAO.getAllEmployees();

String empIdStr = request.getParameter("employeeId");
List<SalaryPayment> payments = null;
Employee selectedEmployee = null;
double totalPaid = 0;

if (empIdStr != null && !empIdStr.trim().isEmpty()) {
    int empId = Integer.parseInt(empIdStr);
    payments = SalaryPaymentDAO.getSalaryPaymentsByEmployeeId(empId);
    selectedEmployee = EmployeeDAO.getEmployeeById(empId);
    for (SalaryPayment sp : payments) {
        totalPaid += sp.getAmount();
    }
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
            color: #333;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .header {
            background: linear-gradient(45deg, #2c3e50, #3498db);
            color: white;
            padding: 30px;
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
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
            animation: shimmer 3s infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }

        .header h2 {
            font-size: 2.5rem;
            font-weight: 300;
            letter-spacing: 2px;
            position: relative;
            z-index: 1;
        }

        .content {
            padding: 40px;
        }

        .form-section {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 5px solid #3498db;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1rem;
        }

        select {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            background: white;
            transition: all 0.3s ease;
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 12px center;
            background-repeat: no-repeat;
            background-size: 16px;
            padding-right: 50px;
        }

        select:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            transform: translateY(-2px);
        }

        .submit-btn {
            background: linear-gradient(45deg, #3498db, #2980b9);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
            overflow: hidden;
        }

        .submit-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(52, 152, 219, 0.3);
        }

        .submit-btn:active {
            transform: translateY(-1px);
        }

        .divider {
            height: 2px;
            background: linear-gradient(to right, transparent, #3498db, transparent);
            margin: 40px 0;
            border: none;
        }

        .report-section {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .report-header {
            background: linear-gradient(45deg, #27ae60, #2ecc71);
            color: white;
            padding: 25px;
            text-align: center;
        }

        .report-header h3 {
            font-size: 1.8rem;
            font-weight: 400;
            margin: 0;
        }

        .table-container {
            overflow-x: auto;
            padding: 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        th {
            background: linear-gradient(45deg, #34495e, #2c3e50);
            color: white;
            padding: 20px;
            text-align: left;
            font-weight: 600;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: relative;
        }

        th::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 3px;
            background: #3498db;
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        th:hover::after {
            width: 80%;
        }

        td {
            padding: 18px 20px;
            border-bottom: 1px solid #ecf0f1;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        tbody tr {
            transition: all 0.3s ease;
        }

        tbody tr:hover {
            background: linear-gradient(45deg, #f8f9fa, #e9ecef);
            transform: scale(1.01);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        tbody tr:nth-child(even):hover {
            background: linear-gradient(45deg, #e9ecef, #dee2e6);
        }

        .total-row {
            background: linear-gradient(45deg, #f39c12, #e67e22) !important;
            color: white !important;
            font-weight: bold;
            font-size: 1.1rem;
        }

        .total-row td {
            border-bottom: none;
            padding: 25px 20px;
        }

        .total-row:hover {
            background: linear-gradient(45deg, #e67e22, #d35400) !important;
            transform: none;
        }

        .currency {
            color: #27ae60;
            font-weight: 600;
        }

        .back-link {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 25px;
            background: linear-gradient(45deg, #95a5a6, #7f8c8d);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .back-link:hover {
            background: linear-gradient(45deg, #7f8c8d, #6c7b7d);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(127, 140, 141, 0.3);
            text-decoration: none;
            color: white;
        }

        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
            font-size: 1.2rem;
            font-style: italic;
        }

        .employee-info {
            background: linear-gradient(45deg, #e8f4f8, #d4edda);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 5px solid #27ae60;
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 10px;
            }
            
            .header h2 {
                font-size: 2rem;
            }
            
            .content {
                padding: 20px;
            }
            
            .form-section {
                padding: 20px;
            }
            
            table {
                font-size: 14px;
            }
            
            th, td {
                padding: 12px 8px;
            }
            
            .submit-btn {
                width: 100%;
                padding: 18px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }
            
            .header {
                padding: 20px;
            }
            
            .header h2 {
                font-size: 1.5rem;
            }
            
            th, td {
                padding: 8px 4px;
                font-size: 12px;
            }
        }

        /* Loading animation for form submission */
        .submit-btn.loading {
            position: relative;
            color: transparent;
        }

        .submit-btn.loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 20px;
            height: 20px;
            margin: -10px 0 0 -10px;
            border: 2px solid transparent;
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Smooth scrolling */
        html {
            scroll-behavior: smooth;
        }

        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb {
            background: linear-gradient(45deg, #3498db, #2980b9);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(45deg, #2980b9, #21618c);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Generate Salary Report</h2>
        </div>
        
        <div class="content">
            <div class="form-section">
                <form method="get" action="reports.jsp">
                    <div class="form-group">
                        <label for="employeeId">Select Employee:</label>
                        <select name="employeeId" id="employeeId" required>
                            <option value="">-- Select Employee --</option>
                            <% for (Employee emp : employees) { %>
                            <option value="<%= emp.getId() %>" <%= (empIdStr != null && emp.getId() == Integer.parseInt(empIdStr)) ? "selected" : "" %>>
                                <%= emp.getName() %> (ID: <%= emp.getId() %>)
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <input type="submit" value="Generate Report" class="submit-btn" />
                </form>
            </div>

            <hr class="divider">

            <% if (payments != null) { %>
            <div class="report-section">
                <div class="report-header">
                    <h3>Salary Report for <%= selectedEmployee.getName() %> (ID: <%= selectedEmployee.getId() %>)</h3>
                </div>
                
                <div class="employee-info">
                    <strong>Employee:</strong> <%= selectedEmployee.getName() %> | 
                    <strong>Employee ID:</strong> <%= selectedEmployee.getId() %> | 
                    <strong>Total Records:</strong> <%= payments.size() %>
                </div>
                
                <div class="table-container">
                    <table>
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
                                <td><%= sp.getId() %></td>
                                <td><span class="currency">&#8377;<%= String.format("%.2f", sp.getAmount()) %></span></td>
                                <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(sp.getPaymentDate()) %></td>
                            </tr>
                            <% } %>
                            <tr class="total-row">
                                <td colspan="3" style="text-align:right;">
                                    <strong>Total Paid: &#8377;<%= String.format("%.2f", totalPaid) %></strong>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } else if (empIdStr != null && !empIdStr.trim().isEmpty()) { %>
            <div class="report-section">
                <div class="no-data">
                    <p>No salary payment records found for the selected employee.</p>
                </div>
            </div>
            <% } %>

            <a href="dashboard.jsp" class="back-link">Back to Dashboard</a>
        </div>
    </div>

    <script>
        // Add loading animation to submit button
        document.querySelector('form').addEventListener('submit', function() {
            const submitBtn = document.querySelector('.submit-btn');
            submitBtn.classList.add('loading');
        });

        // Add smooth hover effects
        document.addEventListener('DOMContentLoaded', function() {
            const rows = document.querySelectorAll('tbody tr:not(.total-row)');
            rows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateX(5px)';
                });
                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateX(0)';
                });
            });
        });
    </script>
</body>
</html>