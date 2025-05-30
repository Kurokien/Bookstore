package com.bookstore.controller;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.List;

import org.apache.commons.fileupload2.core.DiskFileItemFactory;
import org.apache.commons.fileupload2.core.FileItem;
import org.apache.commons.fileupload2.jakarta.servlet6.JakartaServletFileUpload;

import com.bookstore.dao.ProductDAO;
import com.bookstore.model.Product;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="/products")
public class ManagerProductServlet extends HttpServlet {
    private static final String UPLOAD_DIRECTORY = "upload";
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3; // 3MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

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

        response.sendRedirect(request.getContextPath() + "/shop/admin/manager_product.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Configure upload settings
        DiskFileItemFactory factory = DiskFileItemFactory.builder()
                .setBufferSize(MEMORY_THRESHOLD)
                .setPath(Paths.get(System.getProperty("java.io.tmpdir"))) // Use setPath with Path
                .get();

        JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
        upload.setFileSizeMax(MAX_FILE_SIZE);
        upload.setSizeMax(MAX_REQUEST_SIZE);

        String url = "/admin/manager_product.jsp";
        String productName = "";
        String productDescription = "";
        String fileName = "";
        double productPrice = 0.0;
        long categoryID = 0;
        long productID = 0;
        String command = "";

        try {
            List<FileItem> formItems = upload.parseRequest(request);

            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString(StandardCharsets.UTF_8);
                    switch (fieldName) {
                        case "command":
                            command = fieldValue;
                            break;
                        case "productName":
                            productName = fieldValue;
                            break;
                        case "productDescription":
                            productDescription = fieldValue;
                            break;
                        case "productID":
                            try {
                                productID = Long.parseLong(fieldValue);
                            } catch (NumberFormatException e) {
                                // Ignore invalid productID
                            }
                            break;
                        case "productPrice":
                            try {
                                productPrice = Double.parseDouble(fieldValue);
                            } catch (NumberFormatException e) {
                                // Ignore invalid price
                            }
                            break;
                        case "categoryID":
                            try {
                                categoryID = Long.parseLong(fieldValue);
                            } catch (NumberFormatException e) {
                                // Ignore invalid categoryID
                            }
                            break;
                    }
                } else {
                    if (item.getSize() > 0) {
                        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdir();
                        }
                        fileName = new File(item.getName()).getName();
                        String filePath = uploadPath + File.separator + fileName;
                        File storeFile = new File(filePath);
                        item.write(storeFile.toPath()); // Convert File to Path
                        request.setAttribute("msg", UPLOAD_DIRECTORY + "/" + fileName);
                        request.setAttribute("message", "Upload successful: " + UPLOAD_DIRECTORY + "/" + fileName);
                    }
                }
            }

            Product p = new Product();
            p.setProductImage(fileName.isEmpty() ? null : UPLOAD_DIRECTORY + "/" + fileName);
            if (categoryID != 0) {
                p.setCategoryID(categoryID);
            }
            p.setProductName(productName);
            p.setProductDescription(productDescription);
            p.setProductPrice(productPrice);
            p.setProductID(productID);

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
}