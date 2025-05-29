package com.project.dao;

import com.project.model.SalaryPayment;
import com.project.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SalaryDAO {

    public static List<SalaryPayment> getAllSalaryPayments() throws SQLException {
        List<SalaryPayment> list = new ArrayList<>();
        String sql = "SELECT * FROM salary_payments";

        try (Connection con = DBUtil.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                SalaryPayment sp = new SalaryPayment();
                sp.setId(rs.getInt("id"));
                sp.setEmployeeId(rs.getInt("employee_id"));
                sp.setAmount(rs.getDouble("amount"));
                sp.setPaymentDate(rs.getDate("payment_date"));
                list.add(sp);
            }
        }
        return list;
    }

    public static SalaryPayment getSalaryPaymentById(int id) throws SQLException {
        SalaryPayment sp = null;
        String sql = "SELECT * FROM salary_payments WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    sp = new SalaryPayment();
                    sp.setId(rs.getInt("id"));
                    sp.setEmployeeId(rs.getInt("employee_id"));
                    sp.setAmount(rs.getDouble("amount"));
                    sp.setPaymentDate(rs.getDate("payment_date"));
                }
            }
        }
        return sp;
    }

    public static void insertSalaryPayment(SalaryPayment sp) throws SQLException {
        String sql = "INSERT INTO salary_payments (employee_id, amount, payment_date) VALUES (?, ?, ?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sp.getEmployeeId());
            ps.setDouble(2, sp.getAmount());
            ps.setDate(3, sp.getPaymentDate());
            ps.executeUpdate();
        }
    }
    public static void insertSalary(SalaryPayment salary) throws Exception {
        Connection con = DBUtil.getConnection();
        String sql = "INSERT INTO salary_payments (employee_id, amount, payment_date) VALUES (?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, salary.getEmployeeId());
        ps.setDouble(2, salary.getAmount());
        ps.setDate(3, new java.sql.Date(salary.getPaymentDate().getTime()));
        ps.executeUpdate();
        ps.close();
        con.close();
    }

    public static List<SalaryPayment> getSalariesByEmployeeId(int employeeId) throws Exception {
        List<SalaryPayment> list = new ArrayList<>();
        Connection con = DBUtil.getConnection();
        String sql = "SELECT * FROM salary_payments WHERE employee_id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, employeeId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            SalaryPayment sp = new SalaryPayment();
            sp.setId(rs.getInt("id"));
            sp.setEmployeeId(rs.getInt("employee_id"));
            sp.setAmount(rs.getDouble("amount"));
            sp.setPaymentDate(rs.getDate("payment_date"));
            list.add(sp);
        }
        rs.close();
        ps.close();
        con.close();
        return list;
    }

    public static void deleteSalary(int id) throws Exception {
        Connection con = DBUtil.getConnection();
        String sql = "DELETE FROM salary_payments WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        ps.executeUpdate();
        ps.close();
        con.close();
    }
    public static void updateSalaryPayment(SalaryPayment sp) throws SQLException {
        String sql = "UPDATE salary_payments SET employee_id = ?, amount = ?, payment_date = ? WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sp.getEmployeeId());
            ps.setDouble(2, sp.getAmount());
            ps.setDate(3, sp.getPaymentDate());
            ps.setInt(4, sp.getId());
            ps.executeUpdate();
        }
    }

    public static void deleteSalaryPayment(int id) throws SQLException {
        String sql = "DELETE FROM salary_payments WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
