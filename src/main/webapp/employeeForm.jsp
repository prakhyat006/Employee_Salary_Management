<%
com.project.model.Employee emp = (com.project.model.Employee) request.getAttribute("employee");
boolean isEdit = (emp != null);
%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Employee" : "Add Employee" %> - Employee Management</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            max-width: 600px;
            width: 100%;
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
            font-size: 2.2rem;
            font-weight: 300;
            position: relative;
            z-index: 1;
            margin: 0;
        }

        .form-container {
            padding: 50px 40px;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .form-group label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group input {
            padding: 15px 20px;
            border: 2px solid #e0e6ed;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: white;
            color: #2c3e50;
        }

        .form-group input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            transform: translateY(-2px);
        }

        .form-group input:hover {
            border-color: #bdc3c7;
        }

        /* Input type specific styling */
        .form-group input[type="email"] {
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='%233498db' viewBox='0 0 24 24' width='20' height='20'%3E%3Cpath d='M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.89 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 20px;
            padding-right: 50px;
        }

        .form-group input[type="number"] {
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='%2327ae60' viewBox='0 0 24 24' width='20' height='20'%3E%3Cpath d='M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 20px;
            padding-right: 50px;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 20px;
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
            flex: 1;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(52, 152, 219, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
            flex: 1;
        }

        .btn-secondary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(149, 165, 166, 0.4);
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
        }

        .back-link a:hover {
            color: #2980b9;
            transform: translateX(-5px);
        }

        .back-link a::before {
            content: "←";
            font-size: 1.2rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }

            .container {
                margin: 0;
            }

            .header {
                padding: 30px 20px;
            }

            .header h2 {
                font-size: 1.8rem;
            }

            .form-container {
                padding: 30px 20px;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }

        /* Form validation styling */
        .form-group input:invalid:not(:focus):not(:placeholder-shown) {
            border-color: #e74c3c;
            background-color: rgba(231, 76, 60, 0.05);
        }

        .form-group input:valid:not(:focus):not(:placeholder-shown) {
            border-color: #27ae60;
            background-color: rgba(39, 174, 96, 0.05);
        }

        /* Loading animation for form submission */
        .btn:active {
            transform: scale(0.98);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2><%= isEdit ? "Edit Employee" : "Add Employee" %></h2>
        </div>

        <div class="form-container">
            <form method="post" action="EmployeeServlet">
                <%
                String actionValue = isEdit ? "update" : "add";
                %>
                <input type="hidden" name="action" value="<%= actionValue %>" />
                <% if (isEdit) { %>
                    <% if (emp != null) { %>
                        <input type="hidden" name="id" value="<%= emp.getId() %>" />
                    <% } %>
                <% } %>

                <div class="form-group">
                    <label for="name">Employee Name</label>
                    <input type="text" id="name" name="name" value="<%= isEdit ? emp.getName() : "" %>" required placeholder="Enter full name">
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" value="<%= isEdit ? emp.getEmail() : "" %>" placeholder="Enter email address">
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone" value="<%= isEdit ? emp.getPhone() : "" %>" placeholder="Enter phone number">
                </div>

                <div class="form-group">
                    <label for="department">Department</label>
                    <input type="text" id="department" name="department" value="<%= isEdit ? emp.getDepartment() : "" %>" placeholder="Enter department">
                </div>

                <div class="form-group">
                    <label for="designation">Designation</label>
                    <input type="text" id="designation" name="designation" value="<%= isEdit ? emp.getDesignation() : "" %>" placeholder="Enter job designation">
                </div>

                <div class="form-group">
                    <label for="salary">Salary</label>
                    <input type="number" id="salary" name="salary" step="0.01" value="<%= isEdit ? emp.getSalary() : "" %>" placeholder="Enter salary amount">
                </div>

                <div class="button-group">
                    <input type="submit" class="btn btn-primary" value="<%= isEdit ? "Update Employee" : "Add Employee" %>">
                </div>
            </form>

            <div class="back-link">
                <a href="dashboard.jsp">Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>