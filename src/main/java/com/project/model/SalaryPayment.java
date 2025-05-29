package com.project.model;

import java.sql.Date;

public class SalaryPayment {
	
    private int id;
    private int employeeId;
    private double amount;
 

    // Getters and setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getEmployeeId() {
        return employeeId;
    }
    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public double getAmount() {
        return amount;
    }
    public void setAmount(double amount) {
        this.amount = amount;
    }

    private java.sql.Date paymentDate;

    public void setPaymentDate(java.sql.Date paymentDate) {
        this.paymentDate = paymentDate;
    }  // Date type from java.util.Date

    // getter
    public Date getPaymentDate() {
        return paymentDate;
    }
    private String employeeName;

    public String getEmployeeName() {
        return employeeName;
    }
    private Employee employee;

    
    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }
    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }


    // setter
   
    
}
