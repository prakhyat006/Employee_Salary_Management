package com.project.servlet;

import com.project.dao.SalaryDAO;
import com.project.model.SalaryPayment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
@WebServlet("/SalaryServlet")
public class SalaryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("list".equals(action)) {
                int employeeId = Integer.parseInt(request.getParameter("employeeId"));
                List<SalaryPayment> salaries = SalaryDAO.getSalariesByEmployeeId(employeeId);
                request.setAttribute("salaries", salaries);
                request.setAttribute("employeeId", employeeId);
                request.getRequestDispatcher("salaryPayments.jsp").forward(request, response);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int employeeId = Integer.parseInt(request.getParameter("employeeId"));
                SalaryDAO.deleteSalary(id);
                response.sendRedirect("SalaryServlet?action=list&employeeId=" + employeeId);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int employeeId = Integer.parseInt(request.getParameter("employeeId"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            String paymentDateStr = request.getParameter("paymentDate");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date utilDate = sdf.parse(paymentDateStr);
            java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());

            SalaryPayment sp = new SalaryPayment();
            sp.setEmployeeId(employeeId);
            sp.setAmount(amount);
            sp.setPaymentDate(sqlDate);

            SalaryDAO.insertSalary(sp);

            response.sendRedirect("SalaryServlet?action=list&employeeId=" + employeeId);
        } catch (Exception e) {
            e.printStackTrace(); 
            throw new ServletException(e);
        }
    }
}
