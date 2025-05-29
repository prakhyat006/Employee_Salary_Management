package com.project.dao;

import java.sql.*;
import java.util.*;

import com.project.model.Employee;
import com.project.model.SalaryPayment;
import com.project.util.DBUtil;

public class SalaryPaymentDAO {

    public static void addSalaryPayment(SalaryPayment sp) throws Exception {
        String sql = "INSERT INTO salary_payments (employee_id, amount, payment_date) VALUES (?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sp.getEmployeeId());
            ps.setDouble(2, sp.getAmount());
            ps.setDate(3, new java.sql.Date(sp.getPaymentDate().getTime()));
            ps.executeUpdate();
        }
    }

    public static List<SalaryPayment> getSalaryPaymentsByEmployeeId(int employeeId) throws Exception {
        String sql = "SELECT * FROM salary_payments WHERE employee_id = ? ORDER BY payment_date DESC";
        List<SalaryPayment> list = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalaryPayment sp = new SalaryPayment();
                    sp.setId(rs.getInt("id"));
                    sp.setEmployeeId(rs.getInt("employee_id"));
                    sp.setAmount(rs.getDouble("amount"));
                    sp.setPaymentDate(rs.getDate("payment_date"));
                    list.add(sp);
                }
            }
        }
        return list;
    }
    public static List<SalaryPayment> getAllSalaryPaymentsWithEmployee() {
        List<SalaryPayment> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT sp.*, e.id as empId, e.name FROM salary_payments sp JOIN employees e ON sp.employee_id = e.id ORDER BY e.name, sp.payment_date";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SalaryPayment sp = new SalaryPayment();
                sp.setId(rs.getInt("id"));
                sp.setAmount(rs.getDouble("amount"));
                sp.setPaymentDate(rs.getDate("payment_date"));

                Employee emp = new Employee();
                emp.setId(rs.getInt("empId"));
                emp.setName(rs.getString("name"));
                sp.setEmployee(emp); // Add employee reference to SalaryPayment

                list.add(sp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }



    public static void deleteSalaryPayment(int id) throws Exception {
        String sql = "DELETE FROM salary_payments WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // Optionally, add update method
    public static void updateSalaryPayment(SalaryPayment sp) throws Exception {
        String sql = "UPDATE salary_payments SET amount = ?, payment_date = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, sp.getAmount());
            ps.setDate(2, new java.sql.Date(sp.getPaymentDate().getTime()));
            ps.setInt(3, sp.getId());
            ps.executeUpdate();
        }
    }
}
