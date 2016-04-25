package Command;

import Daos.SongDao;
import Dtos.Song;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *            session
 * @author Brian Millar
 */
public class StreamCommand implements Command {

    private static final boolean DEBUG = sWave.Server.DEBUGGING;

    @Override
    public String executeCommand(HttpServletRequest request, HttpServletResponse response) {
        try {
            SongDao dao = new SongDao();
            Song s = dao.getSongById(Integer.parseInt(request.getParameter("songid")));
            OutputStream out = response.getOutputStream();
            if (s != null) {
                out.write(s.getSongdata());
                out.flush();
            }
            out.close();
            return null; //We don't want to redirect
        } catch (IOException ex) {
            if (DEBUG)
                ex.printStackTrace();
        }
        return null;
    }
    
    /*
        Create a hash of the mp3 data and store it in database.
        Use a hashmap to store songdata on the heap.
        When starting new stream get song hash and see if its in the hashmap
        before reading from DB.
    */
    
}
