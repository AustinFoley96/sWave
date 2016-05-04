package sWave;

import java.util.Properties;

/**
 *
 * @author Brian Millar
 */
public class Server {
    
    public static boolean IS_SERVER = false;

    public static boolean DEBUGGING = false;
    public static boolean TESTING   = false;

    private static final boolean HAS_SSL  = false;

    public static final String DOMAIN         = IS_SERVER ? "139.59.166.250" : "localhost";
    public static final String MYSQL_USERNAME = "root";
    public static final String MYSQL_PASSWORD = IS_SERVER ? "rainbowdash" : "";
    public static final String DATABASE_NAME  = "SWAVE";
    public static final String TEST_DB_NAME   = "SWAVE_TEST";
    public static final String DB_NAME        = TESTING ? TEST_DB_NAME : DATABASE_NAME;
    public static final int    MYSQL_PORT     = 3306;
    public static final int    TOMCAT_PORT    = 8080;
    public static final String PROTOCOL       = HAS_SSL ? "https://" : "http://";
    public static final String DB_PROTOCOL    = "jdbc:mysql://";
    public static final String DB_DRIVER      = "com.mysql.jdbc.Driver";
    public static final int    SYSTEMUSERID   = -3;

    /*
        The system user id is the id of a special system user account. It cannot 
        be logged into, it is used for creating system playlists available to 
        everyone and other tasks.
    */

    public static Properties sysProp = System.getProperties();
    public static final int  CPUs    = Runtime.getRuntime().availableProcessors();
    public static final long JVMHEAP = Runtime.getRuntime().totalMemory();
    public static final long FREEMEM = Runtime.getRuntime().freeMemory();

    public static final String DEFAULT_SKIN = "swave";

    public static void shutdown() {
        Runtime.getRuntime().halt(0);
    }

    public static void garbageCollect() {
        Runtime.getRuntime().gc();
    }
}
