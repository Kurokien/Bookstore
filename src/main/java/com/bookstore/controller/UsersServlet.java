package com.bookstore.controller;

import java.io.IOException;

import com.bookstore.dao.UsersDAO;
import com.bookstore.model.Users;
import com.bookstore.tools.MD5;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="/users")
public class UsersServlet extends HttpServlet {
    
    UsersDAO usersDAO = new UsersDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        String command = request.getParameter("command");
        if("logout".equals(command)) {
            request.getSession().removeAttribute("user");
            response.sendRedirect("/shop/");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("UsersServlet doPost");
        String command = request.getParameter("command");
        String url = "";
        Users users = new Users();
        HttpSession session = request.getSession();
        if ("insert".equals(command)) {
                users.setUserID(new java.util.Date().getTime());
                users.setUserEmail(request.getParameter("email"));
                users.setUserPass(MD5.encryption(request.getParameter("pass")));
                users.setUserRole(false);
                usersDAO.insertUser(users);
                session.setAttribute("user", users);
                url = "/index.jsp";
        } else  {
                users = usersDAO.login(request.getParameter("email"), MD5.encryption(request.getParameter("pass")));
                if (users != null) {
                    session.setAttribute("user", users);
                    url = "/index.jsp";
                } else {
                    request.setAttribute("error", "Error email or password!");
                    url = "/login.jsp";
                }
        }
        RequestDispatcher rd = getServletContext().getRequestDispatcher(url);
        rd.forward(request, response);
    }
    
}
