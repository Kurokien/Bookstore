package com.bookstore.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.List;

import org.apache.commons.fileupload2.core.DiskFileItemFactory;
import org.apache.commons.fileupload2.core.FileItem;
import org.apache.commons.fileupload2.jakarta.servlet6.JakartaServletFileUpload;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "/upload")
public class UploadServlet extends HttpServlet {
    private static final String UPLOAD_DIRECTORY = "upload";
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3; // 3MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if the request contains multipart content
        if (!JakartaServletFileUpload.isMultipartContent(request)) {
            response.setContentType("text/plain");
            try (PrintWriter writer = response.getWriter()) {
                writer.println("Error: Form must have enctype=multipart/form-data.");
            }
            return;
        }

        // Configure upload settings
        DiskFileItemFactory factory = DiskFileItemFactory.builder()
                .setBufferSize(MEMORY_THRESHOLD)
                .setPath(Paths.get(System.getProperty("java.io.tmpdir"))) // Use Path instead of File
                .get();

        JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
        upload.setFileSizeMax(MAX_FILE_SIZE);
        upload.setSizeMax(MAX_REQUEST_SIZE);

        // Construct the directory path to store uploaded files
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        try {
            @SuppressWarnings("unchecked")
            List<FileItem> formItems = (List<FileItem>) (List<?>) upload.parseRequest(request); // Type casting to resolve incompatibility

            if (formItems != null && !formItems.isEmpty()) {
                for (FileItem item : formItems) {
                    if (!item.isFormField() && item.getSize() > 0) {
                        String fileName = new File(item.getName()).getName();
                        String filePath = uploadPath + File.separator + fileName;
                        File storeFile = new File(filePath);
                        item.write(storeFile.toPath()); // Convert File to Path
                        request.setAttribute("msg", UPLOAD_DIRECTORY + "/" + fileName);
                        request.setAttribute("message", "Upload successful: " + UPLOAD_DIRECTORY + "/" + fileName);
                    }
                }
            }
        } catch (Exception ex) {
            request.setAttribute("message", "Error during upload: " + ex.getMessage());
        }

        getServletContext().getRequestDispatcher("/message.jsp").forward(request, response);
    }
}