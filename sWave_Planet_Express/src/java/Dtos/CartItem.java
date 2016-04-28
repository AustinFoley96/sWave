package Dtos;

import java.io.Serializable;

/**
 * This CartItem class is used for looping through Items in the Cart
 * @author Austin
 */
public class CartItem implements Serializable {
    private boolean type; //True for song, false for merch
    private int prodId;
    private int qty;
    private double price;
    private byte[] custimg;

    /**
     * Constructs a new CartItem
     * @param type The type of cart item, true for song, false for merch
     * @param prodId The id of the song or merch
     * @param qty The amount they want to order
     * @param price The price of the product
     */
    public CartItem(boolean type, int prodId, int qty, double price, byte[] custimg) {
        this.type = type;
        this.prodId = prodId;
        this.qty = qty;
        this.price = price;
        this.custimg = custimg;
    }
    
    /**
     * Constructs a default CartItem
     */
    public CartItem() {
        type = false;
        prodId = 0;
        qty = 0;
        price = 10.0;
        custimg = null;
    }

    /**
     * Returns the type of CartItem
     * @return True if song, false if merch
     */
    public boolean getType() {
        return type;
    }

    /**
     * Sets the type of type
     * @param type The type you want to set the type to
     */
    public void setType(boolean type) {
        this.type = type;
    }

    /**
     * Gets the product id
     * @return 
     */
    public int getProdId() {
        return prodId;
    }

    /**
     * Setting the song or merch id
     * @param prodId The "product" id you wish to change it to
     */
    public void setProdId(int prodId) {
        this.prodId = prodId;
    }

    /**
     * Getting the quantity of merch in the cart
     * @return The quantity of merch
     */
    public int getQty() {
        return qty;
    }

    /**
     * Setting the quantity of merch
     * @param qty The number you wish to change the quantity to
     */
    public void setQty(int qty) {
        this.qty = qty;
    }
    
    /**
     * Getting the price of merch or songs in the cart
     * @return The price of the merch
     */
    public double getPrice() {
        return price;
    }
    
    /**
     * Setting the price of the cart item
     * @param price The price you wish to change it to
     */
    public void setPrice(double price) {
        this.price = price;
    }

    /**
     * Getting the custom image for the cart item
     * @return the custom image for the cart item
     */
    public byte[] getCustImg() {
        return custimg;
    }

    /**
     * Setting the custom image for the cart item
     * @param custimg The new custom image of the cart item
     */
    public void setCustImg(byte[] custimg) {
        this.custimg = custimg;
    }

}
