package Logging;

import java.io.FileWriter;
import java.io.IOException;
import java.io.File;
import java.util.logging.Level;

/**
 *
 * @author Brian Millar
 */
public class Logger {
    
    private static final boolean DEBUG = Debugging.Debug.debug;
    
    public static void writeLine(String text) {
        File file = new File("sWave.log");
        System.out.println(file.getAbsolutePath());
        FileWriter output = null;
        try {
            output = new FileWriter("sWave.log");
        } catch (IOException ex) {
            if (DEBUG)
                ex.printStackTrace();
        }
        try {
            output.append(System.currentTimeMillis() + " | " + text + "\n");
        } catch (IOException ex) {
            if (DEBUG)
                ex.printStackTrace();
        }
    }
}