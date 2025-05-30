package com.bookstore.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Map;

import com.bookstore.dao.BillDAO;
import com.bookstore.dao.BillDetailDAO;
import com.bookstore.dao.UsersDAO;
import com.bookstore.model.Bill;
import com.bookstore.model.BillDetail;
import com.bookstore.model.Cart;
import com.bookstore.model.Item;
import com.bookstore.model.Users;
import com.bookstore.tools.SendMail;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CheckOutServlet extends HttpServlet {

    private final BillDAO billDAO = new BillDAO();
    private final BillDetailDAO billDetailDAO = new BillDetailDAO();
    private final UsersDAO usersDAO = new UsersDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        Users users = (Users) session.getAttribute("user");
        
        if (users == null ||usersDAO.getUser(users.getUserID()) == null) {
            response.sendRedirect(request.getContextPath() +"/login.jsp");
        }

        if (cart == null || cart.getCartItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }

        request.setAttribute("cart", cart);
        request.setAttribute("total", cart.totalCart());

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String payment = request.getParameter("payment");
        String address = request.getParameter("address");
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        Users users = (Users) session.getAttribute("user");
        try {
            long ID = new Date().getTime();
            Bill bill = new Bill();
            bill.setBillID(ID);
            bill.setAddress(address);
            bill.setPayment(payment);
            bill.setUserID(users.getUserID());
            bill.setDate(new Timestamp(new Date().getTime()));
            bill.setTotal(cart.totalCart());
            billDAO.insertBill(bill);
            for (Map.Entry<Long, Item> list : cart.getCartItems().entrySet()) {
                billDetailDAO.insertBillDetail(new BillDetail(0, ID,
                        list.getValue().getProduct().getProductID(),
                        list.getValue().getProduct().getProductPrice(),
                        list.getValue().getQuantity()));
            }
            SendMail sm = new SendMail();
            sm.sendMail(users.getUserEmail(), "Kenh Lap Trinh", "Hello, "+users.getUserEmail()+"\nTotal: "+cart.totalCart());
            cart = new Cart();
            session.setAttribute("cart", cart);
        } catch (Exception e) {
        }
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
