package com.project.dao;

import java.sql.*;
import java.util.*;
import com.project.model.Employee;
import com.project.util.DBUtil;

public class EmployeeDAO {

    // Insert new employee
    public static void insertEmployee(Employee e) throws Exception {
        Connection con = DBUtil.getConnection();
        String sql = "INSERT INTO employee (name, email, phone, department, designation, salary) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, e.getName());
        ps.setString(2, e.getEmail());
        ps.setString(3, e.getPhone());
        ps.setString(4, e.getDepartment());
        ps.setString(5, e.getDesignation());
        ps.setDouble(6, e.getSalary());
        ps.executeUpdate();
        con.close();
    }

    // Get employee by id
    public static Employee getEmployeeById(int id) throws Exception {
        Connection con = DBUtil.getConnection();
        String sql = "SELECT * FROM employee WHERE id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        Employee e = null;
        if (rs.next()) {
            e = new Employee();
            e.setId(rs.getInt("id"));
            e.setName(rs.getString("name"));
            e.setEmail(rs.getString("email"));
            e.setPhone(rs.getString("phone"));
            e.setDepartment(rs.getString("department"));
            e.setDesignation(rs.getString("designation"));
            e.setSalary(rs.getDouble("salary"));
        }
        con.close();
        return e;
    }

    // Update employee
    public static void updateEmployee(Employee e) throws Exception {
        Connection con = DBUtil.getConnection();
        String sql = "UPDATE employee SET name=?, email=?, phone=?, department=?, designation=?, salary=? WHERE id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, e.getName());
        ps.setString(2, e.getEmail());
        ps.setString(3, e.getPhone());
        ps.setString(4, e.getDepartment());
        ps.setString(5, e.getDesignation());
        ps.setDouble(6, e.getSalary());
        ps.setInt(7, e.getId());
        ps.executeUpdate();
        con.close();
    }

    // Delete employee
    public static void deleteEmployee(int id) throws Exception {
        Connection con = DBUtil.getConnection();
        String sql = "DELETE FROM employee WHERE id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        ps.executeUpdate();
        con.close();
    }

    // Get all employees
    public static List<Employee> getAllEmployees() throws Exception {
        Connection con = DBUtil.getConnection();
        String sql = "SELECT * FROM employee";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        List<Employee> list = new ArrayList<>();
        while (rs.next()) {
            Employee e = new Employee();
            e.setId(rs.getInt("id"));
            e.setName(rs.getString("name"));
            e.setEmail(rs.getString("email"));
            e.setPhone(rs.getString("phone"));
            e.setDepartment(rs.getString("department"));
            e.setDesignation(rs.getString("designation"));
            e.setSalary(rs.getDouble("salary"));
            list.add(e);
        }
        con.close();
        return list;
    }

    // Search employees by id or name (optional)
    public static List<Employee> searchEmployees(String keyword) throws Exception {
        Connection con = DBUtil.getConnection();
        String sql = "SELECT * FROM employee WHERE id LIKE ? OR name LIKE ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, "%" + keyword + "%");
        ps.setString(2, "%" + keyword + "%");
        ResultSet rs = ps.executeQuery();
        List<Employee> list = new ArrayList<>();
        while (rs.next()) {
            Employee e = new Employee();
            e.setId(rs.getInt("id"));
            e.setName(rs.getString("name"));
            e.setEmail(rs.getString("email"));
            e.setPhone(rs.getString("phone"));
            e.setDepartment(rs.getString("department"));
            e.setDesignation(rs.getString("designation"));
            e.setSalary(rs.getDouble("salary"));
            list.add(e);
        }
        con.close();
        return list;
    }
}
