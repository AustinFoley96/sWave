package Dtos;

import java.io.Serializable;
import java.util.Objects;

/**
 * This class is used for creating and managing User Objects
 * @author Phillix
 * @author Brian Millar
 */
public class User implements Serializable {
    
    /*
        The user picture is not used in this DTO as it is never loaded into the 
        object. Passing large binary data around with the object is too 
        inefficient, instead we use the userId to look up the picture through 
        the DAO when we need it rather than always carrying it around.
    */
    
    private int     userId;
    private String  email;
    private String  password;
    private String  username;
    private String  fname;
    private String  lname;
    private String  add1;
    private String  add2;
    private String  city;
    private String  county;
    private String  skin;
    private String  langPref = "en";
    private boolean isAdmin;

    /**
     * Default Constructor for User
     */
    public User() {
        email    = "email";
        password = "password";
        username = "username";
        fname    = "fname";
        lname    = "lname";
        add1     = "add1";
        add2     = "add2";
        city     = "city";
        county   = "CN";
        skin     = "swave";
        langPref = "en";
        isAdmin  = false;
    }

    /**
     * Overloaded Constructor for User
     * @param email the users email
     * @param password the users password
     * @param username the users username
     * @param fname the users first name
     * @param lname the users last name
     * @param add1 the users address1
     * @param add2 the users address2
     * @param city the users city
     * @param county the users county
     * @param skin the users skin preference
     * @param lang the users language
     * @param isAdmin whether the user is an admin or not
     */
    public User(String email, String password, String username, String fname, String lname, String add1, String add2, String city, String county, String skin, String lang, boolean isAdmin) {
        this.email    = email;
        this.password = password;
        this.username = username;
        this.fname    = fname;
        this.lname    = lname;
        this.add1     = add1;
        this.add2     = add2;
        this.city     = city;
        this.county   = county;
        this.skin     = skin;
        this.langPref = lang;
        this.isAdmin  = isAdmin;
    }

    /**
     * Getting the id of the user
     * @return the id of the user
     */
    public int getUserId() {
        return userId;
    }
    
    /**
     * Setting the id of the user
     * @param userId the new id of the user
     */
    public void setUserId(int userId) {
        this.userId = userId;
    }

    /**
     * Getting the email of the user
     * @return the email of the user
     */
    public String getEmail() {
        return email;
    }

    /**
     * Setting the users email
     * @param email the users new email
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Getting the Users password
     * @return the Users password
     */
    public String getPassword() {
        return password;
    }

    /**
     * Setting the users password
     * @param password the users new password
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * Getting the username of the user
     * @return the username of the user
     */
    public String getUsername() {
        return username;
    }

    /**
     * Setting the username of the user
     * @param username the users new username
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * Getting the first name of the user
     * @return the first name of the user
     */
    public String getFname() {
        return fname;
    }

    /**
     * Setting the first name of the user
     * @param fname the users new first name
     */
    public void setFname(String fname) {
        this.fname = fname;
    }

    /**
     * Getting the last name of the user
     * @return the last name of the user
     */
    public String getLname() {
        return lname;
    }

    /**
     * Setting the last name of the user
     * @param lname the users new last name
     */
    public void setLname(String lname) {
        this.lname = lname;
    }

    /**
     * Getting the Address1 of the user
     * @return the Address1 of the user
     */
    public String getAdd1() {
        return add1;
    }

    /**
     * Setting the Address1 of the user
     * @param add1 the Users new Address1
     */
    public void setAdd1(String add1) {
        this.add1 = add1;
    }

    /**
     * Getting the Users new Address2
     * @return the Users new Address2
     */
    public String getAdd2() {
        return add2;
    }

    /**
     * Setting the Address2 of the User
     * @param add2 the new Address2 of the Users
     */
    public void setAdd2(String add2) {
        this.add2 = add2;
    }

    /**
     * Getting the city of the User
     * @return the city of the User
     */
    public String getCity() {
        return city;
    }

    /**
     * Setting the city of the user
     * @param city the users new city
     */
    public void setCity(String city) {
        this.city = city;
    }

    /**
     * Getting the users county
     * @return the users county
     */
    public String getCounty() {
        return county;
    }

    /**
     * Setting the users county
     * @param county the users new county
     */
    public void setCounty(String county) {
        this.county = county;
    }

    /**
     * Getting the users skin
     * @return the users skin
     */
    public String getSkin() {
        return skin;
    }

    /**
     * Setting the Users skin
     * @param skin The users new skin
     */
    public void setSkin(String skin) {
        this.skin = skin;
    }

    /**
     * Getting the language preference of the User
     * @return the language preference of the User
     */
    public String getLangPref() {
        return langPref;
    }

    /**
     * Setting the language preference of the user
     * @param langPref the users new language preference
     */
    public void setLangPref(String langPref) {
        this.langPref = langPref;
    }

    /**
     * Getting if the user is an admin
     * @return if the user is an admin
     */
    public boolean isIsAdmin() {
        return isAdmin;
    }

    /**
     * Setting the users admin status
     * @param isAdmin the users new admin status
     */
    public void setIsAdmin(boolean isAdmin) {
        this.isAdmin = isAdmin;
    }

    /**
     * toString method for displaying all information within this class
     * @return a String containing all of the data within this class
     */
    @Override
    public String toString() {
        return "User{" + "userId=" + userId + ", email=" + email + ", password=" + password + ", username=" + username + ", fname=" + fname + ", lname=" + lname + ", add1=" + add1 + ", add2=" + add2 + ", city=" + city + ", county=" + county + ", skin=" + skin + ", langPref=" + langPref + ", isAdmin=" + isAdmin + '}';
    }

    /**
     * Used for hashing the user
     * @return the hash of this User
     */
    @Override
    public int hashCode() {
        int hash = 7 * userId;
        return hash;
    }

    /**
     * Checking if this User is equal to another Object
     * @param obj the object you wish to compare this User to
     * @return if this user is equal to the argument
     */
    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        final User other = (User) obj;
        if (getClass() != obj.getClass())
            return false;
        if (!Objects.equals(this.email, other.email))
            return false;
        return Objects.equals(this.username, other.username);
    }
}
