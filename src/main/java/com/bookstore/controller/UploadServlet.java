package com.bookstore.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet(name = "/upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 3,  // 3 MB
    maxFileSize = 1024 * 1024 * 40,       // 40 MB
    maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class UploadServlet extends HttpServlet {
    private static final String UPLOAD_DIRECTORY = "upload";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra content type
        String contentType = request.getContentType();
        if (contentType == null || !contentType.toLowerCase().startsWith("multipart/")) {
            response.setContentType("text/plain");
            try (PrintWriter writer = response.getWriter()) {
                writer.println("Error: Form must have enctype=multipart/form-data.");
            }
            return;
        }

        // Tạo thư mục upload nếu chưa tồn tại
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        try {
            // Lấy tất cả parts từ request
            for (Part part : request.getParts()) {
                // Chỉ xử lý file parts (không phải form fields)
                if (part.getSubmittedFileName() != null && part.getSize() > 0) {
                    String fileName = getSubmittedFileName(part);
                    if (fileName != null && !fileName.isEmpty()) {
                        String filePath = uploadPath + File.separator + fileName;
                        part.write(filePath);
                        
                        request.setAttribute("msg", UPLOAD_DIRECTORY + "/" + fileName);
                        request.setAttribute("message", "Upload successful: " + UPLOAD_DIRECTORY + "/" + fileName);
                        break; // Chỉ xử lý file đầu tiên
                    }
                }
            }
            
            // Nếu không có file nào được upload
            if (request.getAttribute("message") == null) {
                request.setAttribute("message", "No file was uploaded.");
            }
            
        } catch (Exception ex) {
            request.setAttribute("message", "Error during upload: " + ex.getMessage());
            ex.printStackTrace();
        }

        getServletContext().getRequestDispatcher("/message.jsp").forward(request, response);
    }

    /**
     * Helper method để lấy tên file từ Part header
     */
    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            String[] tokens = contentDisp.split(";");
            for (String token : tokens) {
                if (token.trim().startsWith("filename")) {
                    String fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                    // Lấy chỉ tên file, bỏ đường dẫn
                    return new File(fileName).getName();
                }
            }
        }
        return "";
    }
}