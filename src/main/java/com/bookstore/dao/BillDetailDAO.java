package com.bookstore.dao;

import com.bookstore.connect.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.bookstore.model.BillDetail;

public class BillDetailDAO {

    public void insertBillDetail(BillDetail bd) throws SQLException {
        Connection connection = DBConnect.getConnection();
        String sql = "INSERT INTO bill_detail VALUES(?,?,?,?,?)";
        PreparedStatement ps = connection.prepareCall(sql);
        ps.setLong(1, bd.getBillDetailID());
        ps.setLong(2, bd.getBillID());
        ps.setLong(3, bd.getProductID());
        ps.setDouble(4, bd.getPrice());
        ps.setInt(5, bd.getQuantity());
        ps.executeUpdate();
    }
    
    public static void main(String[] args) throws SQLException {
        new BillDetailDAO().insertBillDetail(new BillDetail(0, 0, 0, 0, 0));
    }

}
