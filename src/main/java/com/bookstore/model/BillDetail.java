package com.bookstore.model;

import java.sql.Timestamp;

public class BillDetail {

    private long billDetailID;
    private long billID;
    private long productID;
    private double price;
    private int quantity;
    private Timestamp createdAt;

    public BillDetail() {
    }

    public BillDetail(long billDetailID, long billID, long productID, double price, int quantity) {
        this.billDetailID = billDetailID;
        this.billID = billID;
        this.productID = productID;
        this.price = price;
        this.quantity = quantity;
    }

    public long getBillDetailID() {
        return billDetailID;
    }

    public void setBillDetailID(long billDetailID) {
        this.billDetailID = billDetailID;
    }

    public long getBillID() {
        return billID;
    }

    public void setBillID(long billID) {
        this.billID = billID;
    }

    public long getProductID() {
        return productID;
    }

    public void setProductID(long productID) {
        this.productID = productID;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

}
