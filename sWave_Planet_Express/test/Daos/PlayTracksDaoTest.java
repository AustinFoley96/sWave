package Daos;

import Dtos.PlayTrack;
import java.util.ArrayList;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Class for testing PlayTracksDao methods, for valid and invalid
 * @author Austin
 * @author Phillix
 */
public class PlayTracksDaoTest {
    static MyDataSource ds = new MyDataSource();
    static PlayTracksDao instance;
    static PlayTrack p1;
    static PlayTrack p2;
    public PlayTracksDaoTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
        instance = new PlayTracksDao(ds);
    }
    
    @Before
    public void setUp() {
        p1 = new PlayTrack(-1, -1, 1);
        p2 = new PlayTrack(-2, -1, 2);
        instance.createPlayTrack(p1);
        instance.createPlayTrack(p2);
    }
    
    @After
    public void tearDown() {
        instance.deletePlayTracksInPlaylist(-1);
    }

    /**
     * Test of cascadeOrderOnDelete being valid, of class PlayTracksDao.
     */
    @Test
    public void testCascadeOrderOnDeleteValid() {
        instance.cascadeOrderOnDelete(p1);
        int result = instance.getPlayTracksInPlaylist(-1).get(0).getPlaylistOrder();
        int expResult = 1;
        assertEquals(expResult, result);
    }
    
    /**
     * Test of cascadeOrderOnDelete being invalid, of class PlayTracksDao.
     */
    @Test
    public void testCascadeOrderOnDeleteInvalid() {
        instance.cascadeOrderOnDelete(p2);
        int result = instance.getPlayTracksInPlaylist(-1).get(0).getPlaylistOrder();
        int expResult = 1;
        assertEquals(expResult, result);
    }
    
    /**
     * Test of createPlayTrack being valid, of class PlayTracksDao.
     */
    @Test
    public void testCreatePlayTrackValid() {
        ArrayList<PlayTrack> tracks = instance.getPlayTracksInPlaylist(-1);
        boolean result = tracks.size() == 2;
        boolean expResult = true;
        assertEquals(expResult, result);
    }
    
    /**
     * Test of createPlayTrack being invalid, of class PlayTracksDao.
     */
    @Test
    public void testCreatePlayTrackInvalid() {
        ArrayList<PlayTrack> tracks = instance.getPlayTracksInPlaylist(-2);
        boolean result = tracks.size() == 2;
        boolean expResult = false;
        assertEquals(expResult, result);
    }
    
    /**
     * Test of deletePlayTrack being valid, of class PlayTracksDao.
     */
    @Test
    public void testDeletePlayTrackValid() {
        int result = instance.deletePlayTrack(p1);
        int expResult = 0;
        assertEquals(expResult, result);
    }
    
    /**
     * Test of deletePlayTrack being invalid, of class PlayTracksDao.
     */
    @Test
    public void testDeletePlayTrackInvalid() {
        int result = instance.deletePlayTrack(new PlayTrack(-2, -2, 1));
        int expResult = -5;
        assertEquals(expResult, result);
    }
    
    /**
     * Test of deletePlayTracksInPlaylist being valid, of class PlayTracksDao.
     */
    @Test
    public void testDeletePlayTracksInPlaylistValid() {
        int result = instance.deletePlayTracksInPlaylist(-1);
        int expResult = 0;
        assertEquals(expResult, result);
    }
    
    /**
     * Test of deletePlayTracksInPlaylist being invalid, of class PlayTracksDao.
     */
    @Test
    public void testDeletePlayTracksInPlaylistInvalid() {
        int result = instance.deletePlayTracksInPlaylist(-3);
        int expResult = -5;
        assertEquals(expResult, result);
    }
    
    /**
     * Test of getMaxPlaylistOrder being valid, of class PlayTracksDao.
     */
    @Test
    public void testGetMaxPlaylistOrderValid() {
        int result = instance.getMaxPlaylistOrder(-1);
        int expResult = 2;
        assertEquals(expResult, result);
    }
    
    /**
     * Test of getMaxPlaylistOrder being invalid, of class PlayTracksDao.
     */
    @Test
    public void testGetMaxPlaylistOrderInvalid() {
        int result = instance.getMaxPlaylistOrder(-2);
        int expResult = 0;
        assertEquals(expResult, result);
    }
    
    /**
     * Test of getPlayTracksInPlaylist being valid, of class PlayTracksDao.
     */
    @Test
    public void testGetPlayTracksInPlaylistValid() {
        int result = instance.getPlayTracksInPlaylist(-1).size();
        int expResult = 2;
        assertEquals(expResult, result);
    }
    
    /**
     * Test of getPlayTracksInPlaylist being invalid, of class PlayTracksDao.
     */
    @Test
    public void testGetPlayTracksInPlaylistInvalid() {
        int result = instance.getPlayTracksInPlaylist(-4).size();
        int expResult = 2;
        assertNotEquals(expResult, result);
    }
    
    /**
     * Test of moveOrderUp being valid, of class PlayTracksDao.
     */
    @Test
    public void testMoveOrderUpValid() {
        instance.moveOrderUp(p1);
        int result = p1.getPlaylistOrder();
        int expResult = 2;
        assertNotEquals(expResult, result);
    }
    
    /**
     * Test of moveOrderUp being invalid, of class PlayTracksDao.
     */
    @Test
    public void testMoveOrderUpInvalid() {
        instance.moveOrderUp(p1);
        int result = p1.getPlaylistOrder();
        int expResult = 2;
        assertNotEquals(expResult, result);
    }
    
    /**
     * Test of moveOrderDown being valid, of class PlayTracksDao.
     */
//    @Test
//    public void testMoveOrderDownValid() {
//        instance.moveOrderDown(p2);
//        int result = p2.getPlaylistOrder();
//        int expResult = 1;
//        assertEquals(expResult, result);
//    }
    
    /**
     * Test of cascadeOrderOnDown being invalid, of class PlayTracksDao.
     */
//    @Test
//    public void testMoveOrderDownInvalid() {
//        instance.moveOrderDown(p2);
//        int result = p2.getPlaylistOrder();
//        int expResult = 2;
//        assertNotEquals(expResult, result);
//    }
}
