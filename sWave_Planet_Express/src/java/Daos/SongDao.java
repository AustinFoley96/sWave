package Daos;

import Dtos.Song;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author Austin
 * @author Brian Millar
 */
public class SongDao extends Dao implements SongDaoInterface {
    private final boolean DEBUG = sWave.Server.DEBUGGING;

    private final String TABLE_NAME = "SONGS";
    private final String SONGID     = "SONGID";
    private final String TITLE      = "TITLE";
    private final String ARTIST     = "ARTIST";
    private final String ALBUM      = "ALBUM";
    private final String GENRE      = "GENRE";
    private final String YEAR       = "RELYEAR";
    private final String PRICE      = "PRICE";
    private final String LICENSE    = "LICENSE";
    private final String PLAYCOUNT  = "PLAYCOUNT";
    private final String ARTWORK    = "ARTWORK";
    private final String SONGDATA   = "SONGDATA";

    /**
     * This method returns an ArrayList of all of the songs in the songs table
     * @return Return an ArrayList of all of the songs, or else null if the table is empty
     */
    @Override
    public ArrayList<Song> getAllSongs() {
        Connection con        = null;
        PreparedStatement ps  = null;
        ResultSet rs          = null;
        ArrayList<Song> songs = new ArrayList<>();

        try {
            con          = getConnection();
            String query = "SELECT * FROM " + TABLE_NAME;
            ps           = con.prepareStatement(query);
            rs           = ps.executeQuery();

            while (rs.next()) {
                Blob artworkBlob = rs.getBlob(SONGDATA);
                byte art[]       = null;
                if (artworkBlob != null)
                    art = artworkBlob.getBytes(1, (int)artworkBlob.length());

                Song s = new Song(rs.getInt(SONGID),
                                    rs.getString(TITLE),
                                    rs.getString(ARTIST),
                                    rs.getString(ALBUM),
                                    rs.getString(GENRE),
                                    rs.getInt(YEAR),
                                    rs.getDouble(PRICE),
                                    rs.getString(LICENSE),
                                    rs.getInt(PLAYCOUNT),
                                    art
                                    ); //We don't want the songdata here
                songs.add(s);
            }
            return songs;
        }
        catch (ClassNotFoundException | SQLException ex) {
            if (DEBUG)
                ex.printStackTrace();
        }
        finally {
            try {
                if(rs  != null)
                    rs.close();
                if(ps  != null)
                    ps.close();
                if(con != null)
                    freeConnection(con);
            }
            catch(SQLException e) {
                if (DEBUG)
                    e.printStackTrace();
            }
        }
        return null;
    }

    /**
     * This method is used for adding a new song to the database
     * @param s The song you wish to add to the database
     * @return SUCCESS if it successfully inserted, otherwise OTHER
     */
    @Override
    public int addNewSong(Song s) {
        Connection con       = null;
        PreparedStatement ps = null;
        ResultSet rs         = null;

        try {
            con       = getConnection();
            Blob data = con.createBlob();
            Blob art  = con.createBlob();
            try {
                if (s.getSongdata() != null)
                    data.setBytes(1, s.getSongdata());
                if (s.getArtwork() != null)
                    art.setBytes(1, s.getArtwork());
            }
            catch (Exception e) {
                if (DEBUG)
                    e.printStackTrace();
            }
            String query = "INSERT INTO " +
                           TABLE_NAME     + " (" +
                           TITLE          + ", " +
                           ARTIST         + ", " +
                           ALBUM          + ", " +
                           GENRE          + ", " +
                           YEAR           + ", " +
                           PRICE          + ", " +
                           LICENSE        + ", " +
                           PLAYCOUNT      + ", " +
                           ARTWORK        + ", " +
                           SONGDATA       + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(query);
            ps.setString(1, s.getTitle());
            ps.setString(2, s.getArtist());
            ps.setString(3, s.getAlbum());
            ps.setString(4, s.getGenre());
            ps.setInt(5, s.getYear());
            ps.setDouble(6, s.getPrice());
            ps.setString(7, s.getLicense());
            ps.setInt(8, s.getPlayCount());
            ps.setBlob(9, art);
            ps.setBlob(10, data);
            if (ps.executeUpdate() > 0)
                return SUCCESS; //It successfully inserted into the database
        }
        catch(ClassNotFoundException | SQLException e) {
            if (DEBUG)
                e.printStackTrace();
        }
        finally {
            try {
                if(rs != null)
                    rs.close();
                if(ps != null)
                    ps.close();
                if(con != null)
                    freeConnection(con);
            }
            catch(SQLException e) {
                if (DEBUG)
                    e.printStackTrace();
                return SQLEX;
            }
        }
        return OTHER;
    }

    /**
     * This method is used to get a song by its id
     * @param songid The id of the song we want to return
     * @return Returns a song if the id exists, or else null if it doesn't exist
     */
    @Override
    public Song getSongById(int songid) {
        Connection con        = null;
        PreparedStatement ps  = null;
        ResultSet rs          = null;

        try {
            con          = getConnection();
            String query = "SELECT * FROM " + TABLE_NAME + " WHERE " + SONGID + " = ?";
            ps           = con.prepareStatement(query);
            ps.setInt(1, songid);
            rs = ps.executeQuery();

            if (rs.next()) {
                Blob songDataBlob = rs.getBlob(SONGDATA);
                byte songdata[]   = null;
                if (songDataBlob != null)
                    songdata = songDataBlob.getBytes(1, (int)songDataBlob.length());
                
                Blob artworkBlob = rs.getBlob(SONGDATA);
                byte art[]       = null;
                if (artworkBlob != null)
                    art = artworkBlob.getBytes(1, (int)artworkBlob.length());
                
                return new Song(rs.getInt(SONGID),
                                rs.getString(TITLE),
                                rs.getString(ARTIST),
                                rs.getString(ALBUM),
                                rs.getString(GENRE),
                                rs.getInt(YEAR),
                                rs.getDouble(PRICE),
                                rs.getString(LICENSE),
                                rs.getInt(PLAYCOUNT),
                                art,
                                songdata);
            }
        }
        catch (ClassNotFoundException | SQLException ex1) {
            if (DEBUG)
                ex1.printStackTrace();
        }
        finally {
            try {
                if(rs  != null)
                    rs.close();
                if(ps  != null)
                    ps.close();
                if(con != null)
                    freeConnection(con);
            }
            catch(SQLException e) {
                if (DEBUG)
                    e.printStackTrace();
            }
        }
        return null;
    }

    /**
     * A search method for searching the songs in the database
     * @param term The search term to be searched
     * @return An ArrayList of all of the songs that matched the search term
     */
    @Override
    public ArrayList<Song> search(String term) {
        Connection con        = null;
        PreparedStatement ps  = null;
        ResultSet rs          = null;
        ArrayList<Song> songs = new ArrayList();

        try {
            con          = getConnection();
            String query = "SELECT * FROM " + TABLE_NAME + " WHERE " + TITLE + " LIKE ? OR " + ARTIST + " LIKE ? OR " + GENRE + " LIKE ?";
            ps           = con.prepareStatement(query);
            ps.setString(1, "%" + term + "%");
            ps.setString(2, "%" + term + "%");
            ps.setString(3, "%" + term + "%");
            rs = ps.executeQuery();

            while (rs.next()) {
                Blob songDataBlob = rs.getBlob(SONGDATA);
                byte songdata[]   = null;
                if (songDataBlob != null)
                    songdata = songDataBlob.getBytes(1, (int)songDataBlob.length());
                
                Blob artworkBlob = rs.getBlob(SONGDATA);
                byte art[]       = null;
                if (artworkBlob != null)
                    art = artworkBlob.getBytes(1, (int)artworkBlob.length());
                
                Song s = new Song(rs.getInt(SONGID),
                                  rs.getString(TITLE),
                                  rs.getString(ARTIST),
                                  rs.getString(ALBUM),
                                  rs.getString(GENRE),
                                  rs.getInt(YEAR),
                                  rs.getDouble(PRICE),
                                  rs.getString(LICENSE),
                                  rs.getInt(PLAYCOUNT),
                                  art,
                                  songdata);
                songs.add(s);
            }
        }
        catch (ClassNotFoundException | SQLException ex1) {
            if (DEBUG)
                ex1.printStackTrace();
        }
        finally {
            try {
                if(rs  != null)
                    rs.close();
                if(ps  != null)
                    ps.close();
                if(con != null)
                    freeConnection(con);
            }
            catch(SQLException e) {
                if (DEBUG)
                    e.printStackTrace();
            }
        }
        return songs;
    }
    
    /**
     * This method is used for deleting songs from the database
     * @param songId The id of the song we want to delete
     * @return Success(0) if the song was deleted or OTHER(-5) if not
     */
    @Override
    public int deleteSong(int songId) {
        Connection con        = null;
        PreparedStatement ps  = null;

        try {
            con          = getConnection();
            String query = "DELETE FROM " + TABLE_NAME + " WHERE " + SONGID + " = ?";
            ps           = con.prepareStatement(query);
            ps.setInt(1, songId);
            int result = ps.executeUpdate();

            if (result > 0) return SUCCESS;
        }
        catch (ClassNotFoundException ex1) {
            if (DEBUG)
                ex1.printStackTrace();
        }
        catch (SQLException ex2) {
            if (DEBUG)
                ex2.printStackTrace();
        }
        finally {
            try {
                if(ps  != null)
                    ps.close();
                if(con != null)
                    freeConnection(con);
            }
            catch(SQLException e) {
                if (DEBUG)
                    e.printStackTrace();
            }
        }
        return OTHER;
    }
}
