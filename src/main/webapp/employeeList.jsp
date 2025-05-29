<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="com.project.model.Employee" %>
<%@ page import="com.project.dao.EmployeeDAO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
String search = request.getParameter("search");
List<Employee> employees = null;
try {
    if (search != null && !search.trim().isEmpty()) {
        employees = EmployeeDAO.searchEmployees(search);
    } else {
        employees = EmployeeDAO.getAllEmployees();
    }
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
    employees = new ArrayList<>(); // Empty list on error
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee List - Employee Management System</title>
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

        .search-section {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-form label {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1rem;
            white-space: nowrap;
        }

        .search-form input[type="text"] {
            flex: 1;
            min-width: 250px;
            padding: 12px 20px;
            border: 2px solid #e0e6ed;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .search-form input[type="text"]:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
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
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(52, 152, 219, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(39, 174, 96, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(149, 165, 166, 0.4);
        }

        .table-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95rem;
        }

        .table th {
            background: linear-gradient(135deg, #34495e, #2c3e50);
            color: white;
            padding: 20px 15px;
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.85rem;
        }

        .table td {
            padding: 18px 15px;
            border-bottom: 1px solid #ecf0f1;
            color: #2c3e50;
            vertical-align: middle;
        }

        .table tbody tr {
            transition: all 0.3s ease;
        }

        .table tbody tr:hover {
            background: rgba(52, 152, 219, 0.05);
            transform: scale(1.01);
        }

        .table tbody tr:nth-child(even) {
            background: rgba(0, 0, 0, 0.02);
        }

        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .action-btn-edit {
            background: linear-gradient(135deg, #f39c12, #e67e22);
            color: white;
        }

        .action-btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(243, 156, 18, 0.4);
        }

        .action-btn-delete {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }

        .action-btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.4);
        }

        .action-btn-salary {
            background: linear-gradient(135deg, #9b59b6, #8e44ad);
            color: white;
        }

        .action-btn-salary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(155, 89, 182, 0.4);
        }

        .action-btn-manage {
            background: linear-gradient(135deg, #1abc9c, #16a085);
            color: white;
        }

        .action-btn-manage:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(26, 188, 156, 0.4);
        }

        .bottom-actions {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px solid #ecf0f1;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #95a5a6;
        }

        .empty-state p {
            font-size: 1.1rem;
            margin-bottom: 20px;
        }

        .salary-amount {
            font-weight: 600;
            color: #27ae60;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .table-container {
                overflow-x: auto;
            }

            .table {
                min-width: 1000px;
            }
        }

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

            .search-form {
                flex-direction: column;
                align-items: stretch;
            }

            .search-form input[type="text"] {
                min-width: auto;
                width: 100%;
            }

            .actions {
                flex-direction: column;
            }

            .action-btn {
                justify-content: center;
            }

            .bottom-actions {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 300px;
            }
        }

        /* Loading animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Employee List</h2>
        </div>

        <div class="main-content">
            <div class="search-section">
                <form method="get" action="employeeList.jsp" class="search-form">
                    <label for="search">Search by ID or Name:</label>
                    <input type="text" id="search" name="search" value="<%= (search != null) ? search : "" %>" placeholder="Enter employee ID or name..."/>
                    <input type="submit" class="btn btn-primary" value="🔍 Search"/>
                </form>
            </div>

            <div class="table-container">
                <% if (employees != null && !employees.isEmpty()) { %>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Department</th>
                                <th>Designation</th>
                                <th>Salary</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            for (Employee e : employees) {
                            %>
                            <tr>
                                <td><strong>#<%= e.getId() %></strong></td>
                                <td><%= e.getName() %></td>
                                <td><%= e.getEmail() %></td>
                                <td><%= e.getPhone() %></td>
                                <td><%= e.getDepartment() %></td>
                                <td><%= e.getDesignation() %></td>
                                <td><span class="salary-amount">₹<%= String.format("%.2f", e.getSalary()) %></span></td>
                                <td>
                                    <div class="actions">
                                        <a href="EmployeeServlet?action=edit&id=<%= e.getId() %>" class="action-btn action-btn-edit">✏️ Edit</a>
                                        <a href="EmployeeServlet?action=delete&id=<%= e.getId() %>" class="action-btn action-btn-delete" onclick="return confirm('Are you sure you want to delete this employee?');">🗑️ Delete</a>
                                        <a href="salaryPayments.jsp?employeeId=<%= e.getId() %>" class="action-btn action-btn-salary">💰 Payments</a>
                                        <a href="SalaryServlet?action=list&employeeId=<%= e.getId() %>" class="action-btn action-btn-manage">⚙️ Manage</a>
                                    </div>
                                </td>
                            </tr>
                            <%
                            }
                            %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <h3>No Employees Found</h3>
                        <p>
                            <% if (search != null && !search.trim().isEmpty()) { %>
                                No employees match your search criteria "<%= search %>".
                            <% } else { %>
                                No employees have been added to the system yet.
                            <% } %>
                        </p>
                        <a href="employeeForm.jsp" class="btn btn-success">➕ Add First Employee</a>
                    </div>
                <% } %>
            </div>

            <div class="bottom-actions">
                <a href="allSalaryReport.jsp" class="btn btn-primary">📊 Manage All Salary Payments</a>
                <a href="employeeForm.jsp" class="btn btn-success">➕ Add New Employee</a>
                <a href="dashboard.jsp" class="btn btn-secondary">🏠 Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>