package com.project.servlet;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.project.dao.EmployeeDAO;
import com.project.dao.SalaryPaymentDAO;
import com.project.model.Employee;
import com.project.model.SalaryPayment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/ExportSalaryPDF")
public class ExportSalaryPDF extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String empIdStr = request.getParameter("employeeId");
        if (empIdStr == null || empIdStr.isEmpty()) {
            response.getWriter().println("Invalid employee ID");
            return;
        }

        int empId = Integer.parseInt(empIdStr);
        Employee emp = null;
        List<SalaryPayment> payments = null;
        try {
            emp = EmployeeDAO.getEmployeeById(empId);
            payments = SalaryPaymentDAO.getSalaryPaymentsByEmployeeId(empId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Salary_Report_" + emp.getName() + ".pdf");

        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Title
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
            Paragraph title = new Paragraph("Salary Report for " + emp.getName() + " (ID: " + emp.getId() + ")", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            document.add(Chunk.NEWLINE);

            // Table
            PdfPTable table = new PdfPTable(3);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{2, 2, 3});

            addTableHeader(table, "Payment ID", "Amount (₹)", "Payment Date");

            double total = 0;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            for (SalaryPayment sp : payments) {
                table.addCell(String.valueOf(sp.getId()));
                table.addCell(String.format("%.2f", sp.getAmount()));
                table.addCell(sdf.format(sp.getPaymentDate()));
                total += sp.getAmount();
            }

            PdfPCell totalCell = new PdfPCell(new Phrase("Total Paid: ₹" + String.format("%.2f", total)));
            totalCell.setColspan(3);
            totalCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            totalCell.setPaddingTop(10);
            totalCell.setBorder(Rectangle.TOP);
            table.addCell(totalCell);

            document.add(table);
            document.close();

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void addTableHeader(PdfPTable table, String... headers) {
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header));
            cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }
    }
}
