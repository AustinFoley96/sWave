package Dtos;

import java.util.Objects;

/**
 * A friends object creates and manages friendships between two friends
 * @author Phillix
 */
public class Friend {
    
    private int userId;
    private int friendId;
    private String friendshipDate;
    private char status; // p = pending c = confirmed
    
    /**
     * Default Constructor for Friend
     */
    public Friend() {
        userId = -1;
        friendId = -2;
        friendshipDate = null;
        status = 'p';
    }

    /**
     * Overloaded Constructor for friend
     * @param userId
     * @param friendId 
     */
    public Friend(int userId, int friendId) {
        this.userId = userId;
        this.friendId = friendId;
        this.friendshipDate = null;
        this.status = 'p';
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
     * @param userId the new user id
     */
    public void setUserId(int userId) {
        this.userId = userId;
    }

    /**
     * Getting the friends user id
     * @return the friends user id
     */
    public int getFriendId() {
        return friendId;
    }

    /**
     * Setting the friends user id
     * @param friendId the new friends id
     */
    public void setFriendId(int friendId) {
        this.friendId = friendId;
    }

    /**
     * Getting the date the friendship was made
     * @return the date the friendship was made
     */
    public String getFriendshipDate() {
        return friendshipDate;
    }
    
    /**
     * Setting the date the friendship was made
     * @param friendshipDate the new friendship date for the users
     */
    public void setFriendshipDate(String friendshipDate) {
        this.friendshipDate = friendshipDate;
    }

    /**
     * Getting the status of the friends request
     * @return the status of the friends request
     */
    public char getStatus() {
        return status;
    }

    /**
     * Setting the status of the friend requests
     * @param status the new status of the friend request
     */
    public void setStatus(char status) {
        this.status = status;
    }

    /**
     * Used for hashing Friend Objects
     * @return the hash of this Friend
     */
    @Override
    public int hashCode() {
        int hash = 3;
        hash = 37 * hash + this.userId;
        hash = 37 * hash + this.friendId;
        hash = 37 * hash + Objects.hashCode(this.friendshipDate);
        hash = 37 * hash + this.status;
        return hash;
    }

    /**
     * Checking if two friendships are equals
     * @param obj The friendship to compare it to
     * @return if this friendship is equal to the argument
     */
    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Friend other = (Friend) obj;
        if (this.userId != other.userId) {
            return false;
        }
        if (this.friendId != other.friendId) {
            return false;
        }
        return true;
    }

    /**
     * A toString method easily provides a method for printing and viewing the contents of the Friend
     * @return a String containing the details of this friend
     */
    @Override
    public String toString() {
        return "Friend{" + "userId=" + userId + ", friendId=" + friendId + ", friendshipDate=" + friendshipDate + ", status=" + status + '}';
    }
    
    
}
