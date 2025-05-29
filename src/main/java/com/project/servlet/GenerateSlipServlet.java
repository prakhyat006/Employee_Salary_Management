package com.project.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet("/GenerateSlipServlet")
public class GenerateSlipServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Example: get employeeId from request
        String empIdStr = request.getParameter("employeeId");
        int empId = 0;
        try {
            empId = Integer.parseInt(empIdStr);
        } catch (Exception e) {
            empId = 0; // handle invalid input gracefully
        }

        // Set response headers
        response.setContentType("application/pdf");
        // The filename for download
        response.setHeader("Content-Disposition", "attachment; filename=SalarySlip_" + empId + ".pdf");

        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Generate content for PDF, e.g., employee info and salary details
            document.add(new Paragraph("Salary Slip for Employee ID: " + empId));
            document.add(new Paragraph("Generated on: " + new java.util.Date()));

            // You can fetch actual data from DB here and add to the PDF

            document.close();

        } catch (DocumentException de) {
            throw new IOException(de.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect GET to POST or handle accordingly
        doPost(request, response);
    }
}
