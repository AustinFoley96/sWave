package Dtos;

import java.util.ArrayList;

/**
 * This is used for handling an entire order, ie an 'Ultimate Order'
 * @author Phillix
 */
public class UltimateOrder {

    private final int MERCH_SIZE;
    private final int SONG_SIZE;
    private double total;
    private String dateOrdered;
    private int[] qty;
    private double[] merchPrice;
    private String[] title;
    private int[] songId;
    private double[] songPrice;

    /**
     * Default constructor for UltimateOrder
     */
    public UltimateOrder() {
        MERCH_SIZE = 0;
        SONG_SIZE  = 0;
        total = 50.0;
        dateOrdered = "date";
        qty = new int[]{0};
        merchPrice = new double[]{20.0};
        title = new String[]{"testcase"};
        songId = new int[]{-1};
        songPrice = new double[]{15.50};
    }

    /**
     * used for when user has only merch in order
     * @param o single order object
     * @param om Collection of orderMerch belonging to the given order
     * @param m Collection of Merch belonging to the given order
     */
    public UltimateOrder(Order o, ArrayList<OrderMerch> om, ArrayList<Merch> m) {

        MERCH_SIZE = m.size();
        SONG_SIZE = 0;
        qty = new int[MERCH_SIZE];
        merchPrice = new double[MERCH_SIZE];
        title = new String[MERCH_SIZE];
        total = 0;
        dateOrdered = o.getDateOrdered();

        for(int i = 0; i < MERCH_SIZE; i++) {
            title[i] = m.get(i).getTitle();
            qty[i] = om.get(i).getQty();
            merchPrice[i] = om.get(i).getPricePaid();
        }
    }
    
    /**
     * used for when user has only songs in order
     * @param o order the songs belong to
     * @param os the OrderSong list to get data from
     */
    public UltimateOrder(Order o, ArrayList<OrderSong> os) {

        SONG_SIZE = os.size();
        MERCH_SIZE = 0;
        songId = new int[SONG_SIZE];
        songPrice = new double[SONG_SIZE];
        total = 0;
        dateOrdered = o.getDateOrdered();

        for(int i = 0; i < SONG_SIZE; i++) {
            songId[i] = os.get(i).getSongId();
            songPrice[i] = os.get(i).getPricePaid();
        }
    }
    
    /**
     * used for when user has both songs and merch in order
     * @param o order items belong to
     * @param om Collection of orderMerch belonging to the given order
     * @param m Collection of Merch belonging to the given order
     * @param os Collection of orderSong belonging to the given order
     */
    public UltimateOrder(Order o, ArrayList<OrderMerch> om, ArrayList<Merch> m, ArrayList<OrderSong> os) {

        MERCH_SIZE = m.size();
        SONG_SIZE = os.size();
        qty = new int[MERCH_SIZE];
        merchPrice = new double[MERCH_SIZE];
        title = new String[MERCH_SIZE];
        songId = new int[SONG_SIZE];
        songPrice = new double[SONG_SIZE];
        total = 0;
        dateOrdered = o.getDateOrdered();
        
        if(SONG_SIZE > MERCH_SIZE) {
            
            for(int i = 0; i < SONG_SIZE; i++) {
                
                songId[i] = os.get(i).getSongId();
                songPrice[i] = os.get(i).getPricePaid();
                
                if(i < MERCH_SIZE) {
                    title[i] = m.get(i).getTitle();
                    qty[i] = om.get(i).getQty();
                    merchPrice[i] = om.get(i).getPricePaid();
                }
            }
        } else if(SONG_SIZE < MERCH_SIZE) {
            
            for(int i = 0; i < MERCH_SIZE; i++) {
                
                title[i] = m.get(i).getTitle();
                qty[i] = om.get(i).getQty();
                merchPrice[i] = om.get(i).getPricePaid();
                
                if(i < SONG_SIZE) {
                    songId[i] = os.get(i).getSongId();
                    songPrice[i] = os.get(i).getPricePaid();
                }
            }
        } else {
            for(int i = 0; i < SONG_SIZE; i++) {
                songId[i] = os.get(i).getSongId();
                songPrice[i] = os.get(i).getPricePaid();
                title[i] = m.get(i).getTitle();
                qty[i] = om.get(i).getQty();
                merchPrice[i] = om.get(i).getPricePaid();
            }
        }
    }

    /**
     * Calculating the total cost of the order
     * @return a double with the total cost
     */
    public double calcTotal() {
        total = 0;
        for(int i = 0; i < MERCH_SIZE; i++) total += merchPrice[i];
        for(int j = 0; j < SONG_SIZE; j++) total += songPrice[j];
        return total;
    }
    
    /**
     * Getting how much Merch is in the order
     * @return an int for how much Merch is in the Order
     */
    public int getMerchSize() {
        return MERCH_SIZE;
    }
    
    /**
     * Getting how much Songs are in the Order
     * @return the amount of songs in the order
     */
    public int getSongSize() {
        return SONG_SIZE;
    }

    /**
     * the total cost of the entire Order(Warning may not be up to date, use calcTotal())
     * @return the total cost of the order
     * @deprecated use calcTotal() instead
     */
    public double getTotal() {
        return total;
    }

    /**
     * Setting the total cost of the order
     * @param total the new total cost of the order
     */
    public void setTotal(double total) {
        this.total = total;
    }

    /**
     * Get the date the order was made
     * @return the date the order was made
     */
    public String getDateOrdered() {
        return dateOrdered;
    }

    /**
     * Setting the date the order was made
     * @param dateOrdered the new date the order was made
     */
    public void setDateOrdered(String dateOrdered) {
        this.dateOrdered = dateOrdered;
    }

    /**
     * Getting the quantity of a particular merch in an order
     * @param i the index of the merch in the order
     * @return the quantity of a particular merch in an order
     */
    public int getQty(int i) {
        return qty[i];
    }

    /**
     * Setting the quantity of specific merch in the order
     * @param qty the new quantity you want to set it to
     */
    public void setQty(int[] qty) {
        this.qty = qty;
    }

    /**
     * Getting the price of a specific merch
     * @param i the index of merch you want the price of
     * @return the price of the merch
     */
    public double getMerchPrice(int i) {
        return merchPrice[i];
    }

    /**
     * Setting the price of the merch
     * @param merchPrice an array of merch prices
     */
    public void setMerchPrice(double[] merchPrice) {
        this.merchPrice = merchPrice;
    }
    
    /**
     * Getting the id of a specific song
     * @param i the index you want the id of the song for
     * @return the id of the song
     */
    public int getSongId(int i) {
        return songId[i];
    }

    /**
     * Setting the ids of all songs
     * @param songId the new ids of the songs
     */
    public void setSongId(int[] songId) {
        this.songId = songId;
    }

    /**
     * Getting the price of a song
     * @param i the index of the song you want
     * @return the price of that song
     */
    public double getSongPrice(int i) {
        return songPrice[i];
    }

    /**
     * Setting the price of the songs
     * @param songPrice an array of new song prices
     */
    public void setSongPrice(double[] songPrice) {
        this.songPrice = songPrice;
    }

    /**
     * Getting the title of a song
     * @param i the index of the song you want
     * @return the title of said song
     */
    public String getTitle(int i) {
        return title[i];
    }

    /**
     * Setting the titles of the songs
     * @param title an array of titles for the songs
     */
    public void setTitle(String[] title) {
        this.title = title;
    }
}