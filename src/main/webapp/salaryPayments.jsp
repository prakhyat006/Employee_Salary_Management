<%@ page import="java.util.List" %>
<%@ page import="com.project.model.SalaryPayment" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
String empIdStr = null;
Object empIdAttr = request.getAttribute("employeeId");
if (empIdAttr != null) {
    empIdStr = empIdAttr.toString();
} else {
    empIdStr = request.getParameter("employeeId");
}

if (empIdStr == null || empIdStr.trim().isEmpty()) {
    out.println("Error: Employee ID not provided.");
    return;
}

int employeeId = Integer.parseInt(empIdStr);
List<SalaryPayment> salaries = (List<SalaryPayment>) request.getAttribute("salaries");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salary Payments Management - Employee ID: <%= employeeId %></title>
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
            font-size: 2.8rem;
            font-weight: 300;
            letter-spacing: 2px;
            position: relative;
            z-index: 1;
            margin-bottom: 10px;
        }

        .employee-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 10px 20px;
            border-radius: 25px;
            display: inline-block;
            font-size: 1.1rem;
            font-weight: 500;
            position: relative;
            z-index: 1;
        }

        .content {
            padding: 50px;
        }

        .section {
            margin-bottom: 50px;
        }

        .payments-section {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            margin-bottom: 40px;
        }

        .section-header {
            background: linear-gradient(45deg, #27ae60, #2ecc71);
            color: white;
            padding: 25px 30px;
            font-size: 1.5rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .section-header .icon {
            font-size: 1.8rem;
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
            transform: translateX(5px);
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

        .delete-btn {
            background: linear-gradient(45deg, #e74c3c, #c0392b);
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .delete-btn:hover {
            background: linear-gradient(45deg, #c0392b, #a93226);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(231, 76, 60, 0.3);
            text-decoration: none;
            color: white;
        }

        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
            font-size: 1.3rem;
            font-style: italic;
            background: linear-gradient(45deg, #ecf0f1, #bdc3c7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .add-payment-section {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 15px;
            padding: 40px;
            border-left: 6px solid #3498db;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
        }

        .add-payment-section h3 {
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2rem;
            font-weight: 400;
            text-align: center;
            position: relative;
        }

        .add-payment-section h3::after {
            content: '';
            display: block;
            width: 80px;
            height: 3px;
            background: linear-gradient(45deg, #3498db, #2980b9);
            margin: 15px auto;
            border-radius: 2px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-row {
            display: flex;
            gap: 30px;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .form-group label {
            display: inline-block;
            min-width: 140px;
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1rem;
        }

        .form-group input[type="number"],
        .form-group input[type="date"] {
            padding: 15px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            background: white;
            transition: all 0.3s ease;
            width: 250px;
            flex: 1;
            min-width: 200px;
        }

        .form-group input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            transform: translateY(-2px);
        }

        .submit-btn {
            background: linear-gradient(45deg, #27ae60, #2ecc71);
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
            position: relative;
            overflow: hidden;
            display: block;
            margin: 30px auto 0;
        }

        .submit-btn:hover {
            background: linear-gradient(45deg, #2ecc71, #27ae60);
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(39, 174, 96, 0.3);
        }

        .submit-btn:active {
            transform: translateY(-1px);
        }

        .back-link {
            display: inline-block;
            margin-top: 40px;
            padding: 15px 30px;
            background: linear-gradient(45deg, #95a5a6, #7f8c8d);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 14px;
        }

        .back-link:hover {
            background: linear-gradient(45deg, #7f8c8d, #6c7b7d);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(127, 140, 141, 0.3);
            text-decoration: none;
            color: white;
        }

        .stats-card {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            margin: 20px 0;
            box-shadow: 0 8px 20px rgba(52, 152, 219, 0.3);
        }

        .stats-card h4 {
            font-size: 1rem;
            margin-bottom: 10px;
            opacity: 0.9;
        }

        .stats-card .value {
            font-size: 2rem;
            font-weight: bold;
        }

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
            
            .form-row {
                flex-direction: column;
                align-items: stretch;
                gap: 15px;
            }
            
            .form-group label {
                min-width: auto;
                margin-bottom: 5px;
            }
            
            .form-group input[type="number"],
            .form-group input[type="date"] {
                width: 100%;
                min-width: auto;
            }
            
            table {
                font-size: 14px;
            }
            
            th, td {
                padding: 12px 8px;
            }
            
            .submit-btn {
                width: 100%;
                padding: 20px;
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
            
            .content {
                padding: 20px 15px;
            }
            
            .add-payment-section {
                padding: 25px 20px;
            }
            
            th, td {
                padding: 8px 4px;
                font-size: 12px;
            }
            
            .delete-btn {
                padding: 6px 10px;
                font-size: 12px;
            }
        }

        /* Loading animation */
        .submit-btn.loading {
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

        /* Success/Error messages */
        .message {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .success {
            background: linear-gradient(45deg, #d4edda, #c3e6cb);
            border-left: 5px solid #27ae60;
            color: #155724;
        }

        .error {
            background: linear-gradient(45deg, #f8d7da, #f1aeb5);
            border-left: 5px solid #e74c3c;
            color: #721c24;
        }

        /* Animation classes */
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container fade-in">
        <div class="header">
            <h2>💰 Salary Payments Management</h2>
            <div class="employee-badge">Employee ID: <%= employeeId %></div>
        </div>
        
        <div class="content">
            <div class="section payments-section">
                <div class="section-header">
                    <span>📊 Payment History</span>
                    <span class="icon">💳</span>
                </div>
                
                <%
                double totalPaid = 0;
                int paymentCount = 0;
                if (salaries != null && !salaries.isEmpty()) {
                    paymentCount = salaries.size();
                %>
                
                <div class="stats-card">
                    <h4>Total Payments</h4>
                    <div class="value"><%= paymentCount %></div>
                </div>
                
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Payment ID</th>
                                <th>Amount</th>
                                <th>Payment Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            for (SalaryPayment sp : salaries) {
                                totalPaid += sp.getAmount();
                            %>
                            <tr>
                                <td><strong>#<%= sp.getId() %></strong></td>
                                <td><span class="currency">₹<%= String.format("%.2f", sp.getAmount()) %></span></td>
                                <td><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(sp.getPaymentDate()) %></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/SalaryServlet?action=delete&id=<%= sp.getId() %>&employeeId=<%= employeeId %>" 
                                       class="delete-btn" 
                                       onclick="return confirm('⚠️ Are you sure you want to delete this payment record?');">
                                        🗑️ Delete
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                            <tr class="total-row">
                                <td colspan="4" style="text-align:right;">
                                    <strong>💰 Total Paid: ₹<%= String.format("%.2f", totalPaid) %></strong>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="no-data">
                    <p>📭 No salary payments found or salary list not loaded.</p>
                    <p style="font-size: 1rem; margin-top: 10px; opacity: 0.7;">Add your first payment below to get started!</p>
                </div>
                <% } %>
            </div>

            <div class="section add-payment-section">
                <h3>➕ Add New Salary Payment</h3>
                <form method="post" action="${pageContext.request.contextPath}/SalaryServlet" id="paymentForm">
                    <input type="hidden" name="employeeId" value="<%= employeeId %>" />
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="amount">💵 Amount:</label>
                            <input type="number" name="amount" id="amount" step="0.01" min="0.01" required placeholder="Enter amount">
                        </div>
                        
                        <div class="form-group">
                            <label for="paymentDate">📅 Payment Date:</label>
                            <input type="date" name="paymentDate" id="paymentDate" required>
                        </div>
                    </div>
                    
                    <input type="submit" value="💾 Add Salary Payment" class="submit-btn">
                </form>
            </div>

            <a href="${pageContext.request.contextPath}/employeeList.jsp" class="back-link">
                ⬅️ Back to Employee List
            </a>
        </div>
    </div>

    <script>
        // Set today's date as default
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById('paymentDate');
            const today = new Date().toISOString().split('T')[0];
            dateInput.value = today;
            
            // Add loading animation to submit button
            document.getElementById('paymentForm').addEventListener('submit', function() {
                const submitBtn = document.querySelector('.submit-btn');
                submitBtn.classList.add('loading');
            });
            
            // Add hover effects to table rows
            const rows = document.querySelectorAll('tbody tr:not(.total-row)');
            rows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateX(10px) scale(1.02)';
                });
                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateX(0) scale(1)';
                });
            });
            
            // Form validation with better UX
            const amountInput = document.getElementById('amount');
            amountInput.addEventListener('input', function() {
                if (this.value < 0) {
                    this.style.borderColor = '#e74c3c';
                    this.style.boxShadow = '0 0 0 3px rgba(231, 76, 60, 0.1)';
                } else {
                    this.style.borderColor = '#27ae60';
                    this.style.boxShadow = '0 0 0 3px rgba(39, 174, 96, 0.1)';
                }
            });
        });
        
        // Enhanced delete confirmation
        function confirmDelete(paymentId, amount) {
            const confirmation = confirm(
                `🚨 Delete Payment Confirmation\n\n` +
                `Payment ID: #${paymentId}\n` +
                `Amount: ₹${amount}\n\n` +
                `This action cannot be undone. Are you sure you want to proceed?`
            );
            return confirmation;
        }
        
        // Add smooth animations
        window.addEventListener('load', function() {
            document.querySelector('.container').classList.add('fade-in');
        });
    </script>
</body>
</html>