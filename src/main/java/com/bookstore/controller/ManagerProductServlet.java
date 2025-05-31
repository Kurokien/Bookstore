// ManagerProductServlet.java - Sử dụng Jakarta Servlet built-in multipart
package com.bookstore.controller;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

import com.bookstore.dao.ProductDAO;
import com.bookstore.model.Product;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet(name="/products")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 3,  // 3 MB
    maxFileSize = 1024 * 1024 * 40,       // 40 MB
    maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class ManagerProductServlet extends HttpServlet {
    private static final String UPLOAD_DIRECTORY = "upload";
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String productIdStr = request.getParameter("product_id");
            if (productIdStr != null && !productIdStr.isEmpty()) {
                long productID = Long.parseLong(productIdStr);
                productDAO.deleteProduct(productID);
            }
        } catch (NumberFormatException | SQLException e) {
            request.setAttribute("error", "Error deleting product: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/manager_product.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String url = "/admin/manager_product.jsp";
        String productName = "";
        String productDescription = "";
        String fileName = "";
        double productPrice = 0.0;
        long categoryID = 0;
        long productID = 0;
        String command = "";

        try {
            // Lấy các field thông thường
            command = request.getParameter("command");
            productName = request.getParameter("productName");
            productDescription = request.getParameter("productDescription");
            
            String productPriceStr = request.getParameter("productPrice");
            if (productPriceStr != null && !productPriceStr.isEmpty()) {
                productPrice = Double.parseDouble(productPriceStr);
            }
            
            String categoryIDStr = request.getParameter("categoryID");
            if (categoryIDStr != null && !categoryIDStr.isEmpty()) {
                categoryID = Long.parseLong(categoryIDStr);
            }
            
            String productIDStr = request.getParameter("productID");
            if (productIDStr != null && !productIDStr.isEmpty()) {
                productID = Long.parseLong(productIDStr);
            }

            // Xử lý file upload
            Part filePart = request.getPart("productImage");
            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                
                fileName = getSubmittedFileName(filePart);
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                request.setAttribute("message", "Upload successful: " + UPLOAD_DIRECTORY + "/" + fileName);
            }

            // Tạo object Product
            Product p = new Product();
            p.setProductImage(fileName.isEmpty() ? null : UPLOAD_DIRECTORY + "/" + fileName);
            if (categoryID != 0) {
                p.setCategoryID(categoryID);
            }
            p.setProductName(productName);
            p.setProductDescription(productDescription);
            p.setProductPrice(productPrice);
            p.setProductID(productID);

            // Insert hoặc Update
            if ("update".equals(command)) {
                productDAO.updateProduct(p);
            } else {
                productDAO.insertProduct(p);
            }

        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        } catch (Exception e) {
            request.setAttribute("error", "Error processing request: " + e.getMessage());
        }

        RequestDispatcher rd = getServletContext().getRequestDispatcher(url);
        rd.forward(request, response);
    }

    // Helper method để lấy tên file
    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}