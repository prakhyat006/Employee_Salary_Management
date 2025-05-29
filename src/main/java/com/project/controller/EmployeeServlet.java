package com.project.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import com.project.model.Employee;
import com.project.dao.EmployeeDAO;

public class EmployeeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            try {
                EmployeeDAO.deleteEmployee(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("employeeList.jsp");
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            try {
                Employee emp = EmployeeDAO.getEmployeeById(id);
                request.setAttribute("employee", emp);
                request.getRequestDispatcher("employeeForm.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // Default action if any or redirect
            response.sendRedirect("employeeList.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String dept = request.getParameter("department");
            String desig = request.getParameter("designation");
            double salary = Double.parseDouble(request.getParameter("salary"));

            Employee emp = new Employee();
            emp.setName(name);
            emp.setEmail(email);
            emp.setPhone(phone);
            emp.setDepartment(dept);
            emp.setDesignation(desig);
            emp.setSalary(salary);

            try {
                EmployeeDAO.insertEmployee(emp);
                response.sendRedirect("employeeList.jsp");
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Employee emp = new Employee();
            emp.setId(id);
            emp.setName(request.getParameter("name"));
            emp.setEmail(request.getParameter("email"));
            emp.setPhone(request.getParameter("phone"));
            emp.setDepartment(request.getParameter("department"));
            emp.setDesignation(request.getParameter("designation"));
            emp.setSalary(Double.parseDouble(request.getParameter("salary")));

            try {
                EmployeeDAO.updateEmployee(emp);
                response.sendRedirect("employeeList.jsp");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
