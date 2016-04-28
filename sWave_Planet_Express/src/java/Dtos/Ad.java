package Dtos;

/**
 * This class is used for creating and managing Ads
 * @author Phillix
 */
public class Ad {

    private int    adId;
    private String adUrl;

    /**
     * Default Constructor for Ads
     */
    public Ad() {
        adId  = 0;
        adUrl = "/notFound";
    }

    /**
     * Overloaded constructor for Ads
     * @param adUrl the url of the ad
     */
    public Ad(String adUrl) {
        this.adUrl = adUrl;
    }

    /**
     * Getting the id of the Ad
     * @return the id of the Ad
     */
    public int getAdId() {
        return adId;
    }

    /**
     * Setting the id of the Ad
     * @param adId the new id of the Ad
     */
    public void setAdId(int adId) {
        this.adId = adId;
    }

    /**
     * Getting the URL of the Ad
     * @return the URL of the Ad
     */
    public String getAdUrl() {
        return adUrl;
    }

    /**
     * Setting the URL of the ad
     * @param adUrl the new URL of the ad
     */
    public void setAdUrl(String adUrl) {
        this.adUrl = adUrl;
    }

    /**
     * toString method for easily displaying the details of this Ad
     * @return a String with the details of the Ad
     */
    @Override
    public String toString() {
        return "Ad{" + "adId=" + adId + ", adUrl=" + adUrl + '}';
    }
}
