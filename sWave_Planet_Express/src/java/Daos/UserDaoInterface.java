package Daos;

import Dtos.User;
import java.util.ArrayList;

/**
 *
 * @author Austin
 */
public interface UserDaoInterface {
    public int checkUname(String username);
    public int register(User u);
    public User logIn(String email, String password);
    public int checkDetails(String email, String username);
    public int getUserId(String email, String username);
    public User getUserById(int id);
    public int deleteUser(String email);
    public int changeSkin(String skin, int userid);
    public int updateUser(User u);
    public ArrayList<User> searchUsers(String searchWord);
    public int addUserPicture(int id, byte[] buffer);
    public byte[] getUserPicture(int id);
}
