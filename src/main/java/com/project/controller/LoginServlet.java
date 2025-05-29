package com.project.controller;

import com.project.util.DBUtil;
import com.project.model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uname = request.getParameter("username");
        String pass = request.getParameter("password");

        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM users WHERE username=? AND password=?"
            );
            ps.setString(1, uname);
            ps.setString(2, pass);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("username", uname);
                session.setAttribute("role", rs.getString("role"));
                response.sendRedirect("dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid Credentials");
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                rd.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
