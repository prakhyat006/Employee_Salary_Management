<%@ page import="com.project.dao.EmployeeDAO" %>
<%@ page import="com.project.model.Employee" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>

<%
if (session == null || session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");
// Fetch dashboard statistics
int totalEmployees = 0;
double totalSalaryExpense = 0;
double averageSalary = 0;
String topDepartment = "N/A";
Map<String, Integer> departmentCounts = new HashMap<>();
DecimalFormat df = new DecimalFormat("#,##0.00");

try {
    List<Employee> employees = EmployeeDAO.getAllEmployees();
    totalEmployees = employees.size();
    
    // Calculate statistics
    for (Employee emp : employees) {
        totalSalaryExpense += emp.getSalary();
        
        // Count employees by department
        String dept = emp.getDepartment();
        departmentCounts.put(dept, departmentCounts.getOrDefault(dept, 0) + 1);
    }
    
    if (totalEmployees > 0) {
        averageSalary = totalSalaryExpense / totalEmployees;
    }
    
    // Find department with most employees
    int maxCount = 0;
    for (Map.Entry<String, Integer> entry : departmentCounts.entrySet()) {
        if (entry.getValue() > maxCount) {
            maxCount = entry.getValue();
            topDepartment = entry.getKey();
        }
    }
} catch (Exception e) {
    // Handle any database errors silently for dashboard display
}
%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Employee Salary Management</title>
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
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            backdrop-filter: blur(10px);
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

        .header h1 {
            font-size: 2.5rem;
            font-weight: 300;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .role-badge {
            display: inline-block;
            background: rgba(255, 255, 255, 0.2);
            padding: 8px 20px;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
            z-index: 1;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .main-content {
            padding: 60px 40px;
        }

        /* NEW: Statistics Cards */
        .stats-section {
            margin-bottom: 50px;
        }

        .stats-title {
            text-align: center;
            color: #2c3e50;
            font-size: 1.8rem;
            font-weight: 300;
            margin-bottom: 30px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 30px 25px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #3498db, #2980b9);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .stat-card.employees::before {
            background: linear-gradient(90deg, #3498db, #2980b9);
        }

        .stat-card.salary::before {
            background: linear-gradient(90deg, #e74c3c, #c0392b);
        }

        .stat-card.average::before {
            background: linear-gradient(90deg, #f39c12, #e67e22);
        }

        .stat-card.department::before {
            background: linear-gradient(90deg, #27ae60, #229954);
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            opacity: 0.8;
        }

        .stat-number {
            font-size: 2.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
        }

        .stat-label {
            font-size: 0.95rem;
            color: #7f8c8d;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* NEW: Quick Actions Section */
        .quick-actions {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 40px;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .quick-actions h3 {
            color: #2c3e50;
            font-size: 1.5rem;
            font-weight: 400;
            margin-bottom: 20px;
            text-align: center;
        }

        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .quick-action-btn {
            display: block;
            padding: 15px 20px;
            background: white;
            border-radius: 10px;
            text-decoration: none;
            color: #2c3e50;
            font-weight: 500;
            text-align: center;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .quick-action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            background: #3498db;
            color: white;
        }

        /* NEW: Search Section */
        .search-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .search-section h3 {
            color: #2c3e50;
            font-size: 1.5rem;
            font-weight: 400;
            margin-bottom: 20px;
            text-align: center;
        }

        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
            justify-content: center;
            flex-wrap: wrap;
        }

        .search-input {
            padding: 12px 20px;
            border: 2px solid #e9ecef;
            border-radius: 25px;
            font-size: 1rem;
            min-width: 250px;
            transition: border-color 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #3498db;
        }

        .search-btn {
            padding: 12px 25px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.4);
        }

        .menu {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }

        .menu ul {
            list-style-type: none;
            display: contents;
        }

        .menu li {
            margin: 0;
        }

        .menu a {
            display: block;
            padding: 30px;
            background: white;
            border-radius: 15px;
            text-decoration: none;
            color: #2c3e50;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(0, 0, 0, 0.05);
            position: relative;
            overflow: hidden;
        }

        .menu a::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.6), transparent);
            transition: left 0.6s;
        }

        .menu a:hover::before {
            left: 100%;
        }

        .menu a:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        /* Menu item icons */
        .menu a[href*="employeeList"]::after {
            content: "👥";
            position: absolute;
            right: 25px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.5rem;
            opacity: 0.7;
        }

        .menu a[href*="employeeForm"]::after {
            content: "➕";
            position: absolute;
            right: 25px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.5rem;
            opacity: 0.7;
        }

        .menu a[href*="salaryReport"]::after {
            content: "📊";
            position: absolute;
            right: 25px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.5rem;
            opacity: 0.7;
        }

        .menu a[href*="logout"]::after {
            content: "🚪";
            position: absolute;
            right: 25px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.5rem;
            opacity: 0.7;
        }

        .welcome-section {
            text-align: center;
            margin-bottom: 20px;
        }

        .welcome-section h2 {
            color: #2c3e50;
            font-size: 2rem;
            font-weight: 300;
            margin-bottom: 15px;
        }

        .welcome-section p {
            color: #7f8c8d;
            font-size: 1.1rem;
            line-height: 1.6;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }

            .header {
                padding: 30px 20px;
            }

            .header h1 {
                font-size: 2rem;
            }

            .main-content {
                padding: 40px 20px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .quick-actions-grid {
                grid-template-columns: 1fr;
            }

            .search-form {
                flex-direction: column;
            }

            .search-input {
                min-width: 100%;
            }

            .menu {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .menu a {
                padding: 25px 20px;
                font-size: 1rem;
            }

            .welcome-section h2 {
                font-size: 1.5rem;
            }
        }

        /* Animation for page load */
        .container {
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

        .menu a, .stat-card {
            animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
            opacity: 0;
        }

        .menu a:nth-child(1), .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .menu a:nth-child(2), .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .menu a:nth-child(3), .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .menu a:nth-child(4), .stat-card:nth-child(4) { animation-delay: 0.4s; }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Welcome, <%= username %>!</h1>
            <div class="role-badge">
                Your role: <%= role %>
            </div>
        </div>

        <div class="main-content">
            <div class="welcome-section">
                <h2>Employee Salary Management System</h2>
                <p>Comprehensive dashboard with real-time statistics and quick access to management tools</p>
            </div>

            <!-- NEW: Statistics Section -->
            <div class="stats-section">
                <h3 class="stats-title">System Overview</h3>
                <div class="stats-grid">
                    <div class="stat-card employees">
                        <div class="stat-icon">👥</div>
                        <div class="stat-number"><%= totalEmployees %></div>
                        <div class="stat-label">Total Employees</div>
                    </div>
                    <div class="stat-card salary">
                        <div class="stat-icon">💰</div>
                        <div class="stat-number">₹<%= df.format(totalSalaryExpense) %></div>
                        <div class="stat-label">Total Salary Expense</div>
                    </div>
                    <div class="stat-card average">
                        <div class="stat-icon">📈</div>
                        <div class="stat-number">₹<%= df.format(averageSalary) %></div>
                        <div class="stat-label">Average Salary</div>
                    </div>
                    <div class="stat-card department">
                        <div class="stat-icon">🏢</div>
                        <div class="stat-number"><%= topDepartment %></div>
                        <div class="stat-label">Top Department</div>
                    </div>
                </div>
            </div>

            <!-- NEW: Quick Actions Section -->
          

            <!-- NEW: Quick Search Section -->
            <div class="search-section">
                <h3>Quick Employee Search</h3>
                <form class="search-form" action="employeeList.jsp" method="get">
                    <input type="text" name="search" class="search-input" placeholder="Search by ID or Name..." />
                    <button type="submit" class="search-btn">🔍 Search</button>
                </form>
            </div>

            <div class="menu">
                <ul>
                    <li><a href="employeeList.jsp">View Employee List</a></li>
                    <li><a href="employeeForm.jsp">Add New Employee</a></li>
                    <li><a href="salaryReport.jsp">Generate Reports</a></li>
                    <li><a href="logout.jsp">Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</body>
</html>