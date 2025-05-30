package com.bookstore.controller;

import com.bookstore.dao.UsersDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CheckEmailServlet extends HttpServlet {

    UsersDAO usersDAO = new UsersDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (usersDAO.checkEmail(request.getParameter("username"))) {
            response.getWriter().write("<img src=\"img/not-available.png\" />");
        } else {
            response.getWriter().write("<img src=\"img/available.png\" />");
        }
    }

}
