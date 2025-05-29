<%@ page import="java.util.List" %>
<%@ page import="com.project.model.Employee" %>
<%@ page import="com.project.model.SalaryPayment" %>
<%@ page import="com.project.dao.EmployeeDAO" %>
<%@ page import="com.project.dao.SalaryPaymentDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Employee Salary Report - Professional Dashboard</title>
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
            max-width: 1400px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            backdrop-filter: blur(15px);
        }

        .header {
            background: linear-gradient(45deg, #2c3e50, #3498db);
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
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
            animation: shimmer 4s infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }

        .header h2 {
            font-size: 3rem;
            font-weight: 300;
            letter-spacing: 3px;
            position: relative;
            z-index: 1;
            margin-bottom: 10px;
        }

        .header-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .content {
            padding: 50px;
        }

        .form-section {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 40px;
            border-radius: 15px;
            margin-bottom: 40px;
            border-left: 6px solid #3498db;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }

        .form-section::before {
            content: '📊';
            position: absolute;
            top: 20px;
            right: 30px;
            font-size: 3rem;
            opacity: 0.1;
        }

        .form-section h3 {
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 1.8rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .form-section h3::before {
            content: '🔍';
            font-size: 1.5rem;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-row {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        label {
            display: inline-block;
            min-width: 150px;
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1rem;
        }

        select {
            flex: 1;
            min-width: 300px;
            padding: 15px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 16px;
            background: white;
            transition: all 0.3s ease;
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 15px center;
            background-repeat: no-repeat;
            background-size: 20px;
            padding-right: 50px;
        }

        select:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 4px rgba(52, 152, 219, 0.1);
            transform: translateY(-2px);
        }

        .generate-btn {
            background: linear-gradient(45deg, #3498db, #2980b9);
            color: white;
            padding: 15px 35px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
            overflow: hidden;
            margin-left: 20px;
        }

        .generate-btn:hover {
            background: linear-gradient(45deg, #2980b9, #21618c);
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(52, 152, 219, 0.3);
        }

        .generate-btn:active {
            transform: translateY(-1px);
        }

        .divider {
            height: 3px;
            background: linear-gradient(to right, transparent, #3498db, #27ae60, #f39c12, transparent);
            margin: 50px 0;
            border: none;
            border-radius: 2px;
        }

        .report-section {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .report-header {
            background: linear-gradient(45deg, #27ae60, #2ecc71);
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
        }

        .report-header h3 {
            font-size: 2rem;
            font-weight: 400;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .report-header h3::before {
            content: '📋';
            font-size: 1.8rem;
        }

        .employee-info {
            background: linear-gradient(135deg, #e8f5e8, #d4edda);
            padding: 25px 30px;
            border-left: 5px solid #27ae60;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .employee-details {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }

        .employee-detail {
            display: flex;
            flex-direction: column;
        }

        .employee-detail .label {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 5px;
        }

        .employee-detail .value {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2c3e50;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 30px;
            background: #f8f9fa;
        }

        .stat-card {
            background: linear-gradient(135deg, #fff, #f8f9fa);
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #3498db;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }

        .stat-card .icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }

        .stat-card .label {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-card .value {
            font-size: 1.8rem;
            font-weight: bold;
            color: #2c3e50;
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
            transform: translateX(8px);
            box-shadow: 5px 5px 15px rgba(0, 0, 0, 0.1);
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
            font-size: 1.2rem;
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
            font-size: 1.1rem;
        }

        .actions-section {
            background: linear-gradient(135deg, #e8f4f8, #d1ecf1);
            padding: 30px;
            border-radius: 15px;
            margin: 30px 0;
            text-align: center;
            border-left: 6px solid #17a2b8;
        }

        .pdf-btn {
            background: linear-gradient(45deg, #dc3545, #c82333);
            color: white;
            padding: 18px 40px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            text-decoration: none;
            display: inline-block;
            position: relative;
            overflow: hidden;
        }

        .pdf-btn::before {
            content: '📄';
            margin-right: 10px;
            font-size: 1.2rem;
        }

        .pdf-btn:hover {
            background: linear-gradient(45deg, #c82333, #a71e2a);
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(220, 53, 69, 0.3);
            text-decoration: none;
            color: white;
        }

        .pdf-btn:active {
            transform: translateY(-1px);
        }

        .back-link {
            display: inline-block;
            margin-top: 40px;
            padding: 15px 30px;
            background: linear-gradient(45deg, #6c757d, #5a6268);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .back-link::before {
            content: '⬅️';
            margin-right: 10px;
        }

        .back-link:hover {
            background: linear-gradient(45deg, #5a6268, #495057);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(108, 117, 125, 0.3);
            text-decoration: none;
            color: white;
        }

        .no-data {
            text-align: center;
            padding: 80px 20px;
            color: #6c757d;
            font-size: 1.4rem;
            font-style: italic;
        }

        .no-data::before {
            content: '📋';
            display: block;
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 15px;
            }
            
            .header {
                padding: 30px 20px;
            }
            
            .header h2 {
                font-size: 2rem;
            }
            
            .content {
                padding: 30px 20px;
            }
            
            .form-section {
                padding: 25px 20px;
            }
            
            .form-row {
                flex-direction: column;
                align-items: stretch;
                gap: 15px;
            }
            
            label {
                min-width: auto;
            }
            
            select {
                min-width: auto;
                width: 100%;
            }
            
            .generate-btn {
                margin-left: 0;
                width: 100%;
                margin-top: 15px;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
                padding: 20px;
            }
            
            .employee-details {
                flex-direction: column;
                gap: 15px;
            }
            
            table {
                font-size: 14px;
            }
            
            th, td {
                padding: 12px 8px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }
            
            .header h2 {
                font-size: 1.5rem;
            }
            
            .content {
                padding: 20px 15px;
            }
            
            th, td {
                padding: 8px 4px;
                font-size: 12px;
            }
            
            .stat-card {
                padding: 15px;
            }
            
            .stat-card .value {
                font-size: 1.4rem;
            }
        }

        /* Loading animation */
        .generate-btn.loading {
            color: transparent;
        }

        .generate-btn.loading::after {
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
            width: 10px;
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

        /* Animation classes */
        .fade-in {
            animation: fadeIn 0.6s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .slide-in {
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-30px); }
            to { opacity: 1; transform: translateX(0); }
        }
    </style>
</head>
<body>
    <div class="container fade-in">
        <div class="header">
            <h2>📊 Employee Salary Report</h2>
            <div class="header-subtitle">Comprehensive Salary Analysis & Reporting</div>
        </div>
        
        <div class="content">
            <div class="form-section slide-in">
                <h3>Generate Salary Report</h3>
                <form method="get" action="salaryReport.jsp" id="reportForm">
                    <div class="form-row">
                        <label for="employeeId">Select Employee:</label>
                        <select name="employeeId" id="employeeId" required>
                            <option value="">-- Select Employee --</option>
                            <% for (Employee emp : employees) { %>
                            <option value="<%= emp.getId() %>" <%= (empIdStr != null && emp.getId() == Integer.parseInt(empIdStr)) ? "selected" : "" %>>
                                <%= emp.getName() %> (ID: <%= emp.getId() %>)
                            </option>
                            <% } %>
                        </select>
                        <input type="submit" value="Generate Report" class="generate-btn" />
                    </div>
                </form>
            </div>

            <hr class="divider">

            <% if (payments != null && selectedEmployee != null) { %>
            <div class="report-section slide-in">
                <div class="report-header">
                    <h3>Salary Report</h3>
                </div>
                
                <div class="employee-info">
                    <div class="employee-details">
                        <div class="employee-detail">
                            <div class="label">Employee Name</div>
                            <div class="value"><%= selectedEmployee.getName() %></div>
                        </div>
                        <div class="employee-detail">
                            <div class="label">Employee ID</div>
                            <div class="value">#<%= selectedEmployee.getId() %></div>
                        </div>
                        <div class="employee-detail">
                            <div class="label">Total Records</div>
                            <div class="value"><%= payments.size() %></div>
                        </div>
                    </div>
                </div>
                
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="icon">💰</div>
                        <div class="label">Total Paid</div>
                        <div class="value">₹<%= String.format("%.2f", totalPaid) %></div>
                    </div>
                    <div class="stat-card">
                        <div class="icon">📊</div>
                        <div class="label">Payment Records</div>
                        <div class="value"><%= payments.size() %></div>
                    </div>
                    <div class="stat-card">
                        <div class="icon">📈</div>
                        <div class="label">Average Payment</div>
                        <div class="value">₹<%= payments.size() > 0 ? String.format("%.2f", totalPaid / payments.size()) : "0.00" %></div>
                    </div>
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
                                <td><strong>#<%= sp.getId() %></strong></td>
                                <td><span class="currency">₹<%= String.format("%.2f", sp.getAmount()) %></span></td>
                                <td><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(sp.getPaymentDate()) %></td>
                            </tr>
                            <% } %>
                            <tr class="total-row">
                                <td colspan="3" style="text-align:right;">
                                    <strong>💰 Total Paid: ₹<%= String.format("%.2f", totalPaid) %></strong>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="actions-section">
                <h3 style="margin-bottom: 20px; color: #2c3e50;">📋 Export Options</h3>
                <a href="ExportSalaryPDF?employeeId=<%= selectedEmployee.getId() %>" target="_blank" class="pdf-btn">
                    Download PDF Report
                </a>
            </div>
            <% } else if (empIdStr != null && !empIdStr.trim().isEmpty()) { %>
            <div class="report-section">
                <div class="no-data">
                    No salary records found for the selected employee.
                    <p style="font-size: 1rem; margin-top: 15px; opacity: 0.7;">Please select a different employee or add salary records first.</p>
                </div>
            </div>
            <% } %>

            <a href="dashboard.jsp" class="back-link">Back to Dashboard</a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Add loading animation to form submit
            document.getElementById('reportForm').addEventListener('submit', function() {
                const submitBtn = document.querySelector('.generate-btn');
                submitBtn.classList.add('loading');
            });
            
            // Add hover effects to table rows
            const rows = document.querySelectorAll('tbody tr:not(.total-row)');
            rows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateX(12px) scale(1.01)';
                });
                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateX(0) scale(1)';
                });
            });
            
            // Enhanced select styling
            const select = document.getElementById('employeeId');
            select.addEventListener('change', function() {
                if (this.value) {
                    this.style.borderColor = '#27ae60';
                    this.style.boxShadow = '0 0 0 4px rgba(39, 174, 96, 0.1)';
                } else {
                    this.style.borderColor = '#e0e0e0';
                    this.style.boxShadow = 'none';
                }
            });
            
            // Add smooth animations for elements
            const sections = document.querySelectorAll('.slide-in');
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateX(0)';
                    }
                });
            });
            
            sections.forEach(section => {
                section.style.opacity = '0';
                section.style.transform = 'translateX(-30px)';
                section.style.transition = 'all 0.6s ease-out';
                observer.observe(section);
            });
        });
        
        // Enhanced PDF download with user feedback
        function downloadPDF(employeeId) {
            const pdfBtn = document.querySelector('.pdf-btn');
            const originalText = pdfBtn.innerHTML;
            
            pdfBtn.innerHTML = '⏳ Generating PDF...';
            pdfBtn.style.pointerEvents = 'none';
            
            setTimeout(() => {
                pdfBtn.innerHTML = originalText;
                pdfBtn.style.pointerEvents = 'auto';
            }, 2000);
        }
        
        // Add click handler to PDF button
        document.addEventListener('DOMContentLoaded', function() {
            const pdfBtn = document.querySelector('.pdf-btn');
            if (pdfBtn) {
                pdfBtn.addEventListener('click', function() {
                    const employeeId = this.href.match(/employeeId=(\d+)/)[1];
                    downloadPDF(employeeId);
                });
            }
        });
    </script>
</body>
</html>