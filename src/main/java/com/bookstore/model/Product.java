package com.bookstore.model;

public class Product {

    private long productID;
    private long categoryID;
    private String productName;
    private String productImage;
    private double productPrice;
    private String productDescription;
    private int quantity; // Thêm field quantity

    public Product() {
    }

    public Product(long productID, long categoryID, String productName, String productImage, 
                   double productPrice, String productDescription, int quantity) {
        this.productID = productID;
        this.categoryID = categoryID;
        this.productName = productName;
        this.productImage = productImage;
        this.productPrice = productPrice;
        this.productDescription = productDescription;
        this.quantity = quantity;
    }

    // Getters and Setters
    public long getProductID() {
        return productID;
    }

    public void setProductID(long productID) {
        this.productID = productID;
    }

    public long getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(long categoryID) {
        this.categoryID = categoryID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    public double getProductPrice() {
        return productPrice;
    }

    public void setProductPrice(double productPrice) {
        this.productPrice = productPrice;
    }

    public String getProductDescription() {
        return productDescription;
    }

    public void setProductDescription(String productDescription) {
        this.productDescription = productDescription;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // Utility methods for stock management
    public boolean isInStock() {
        return quantity > 0;
    }

    public boolean isInStock(int requestedQuantity) {
        return quantity >= requestedQuantity;
    }

    public boolean hasLowStock() {
        return quantity > 0 && quantity <= 10;
    }

    public boolean isOutOfStock() {
        return quantity <= 0;
    }

    public String getStockStatus() {
        if (isOutOfStock()) {
            return "Out of Stock";
        } else if (hasLowStock()) {
            return "Low Stock";
        } else {
            return "In Stock";
        }
    }

    public String getStockStatusClass() {
        if (isOutOfStock()) {
            return "out-of-stock";
        } else if (hasLowStock()) {
            return "low-stock";
        } else {
            return "in-stock";
        }
    }

    @Override
    public String toString() {
        return "Product{" +
                "productID=" + productID +
                ", categoryID=" + categoryID +
                ", productName='" + productName + '\'' +
                ", productImage='" + productImage + '\'' +
                ", productPrice=" + productPrice +
                ", productDescription='" + productDescription + '\'' +
                ", quantity=" + quantity +
                '}';
    }
}