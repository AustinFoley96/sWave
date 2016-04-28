package Command;

import Daos.FriendDao;
import Daos.MessageDao;
import Dtos.Message;
import Dtos.User;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Brian Millar
 */
public class SendMessageCommand implements Command {

    @Override
    public String executeCommand(HttpServletRequest request, HttpServletResponse response) {
        MessageDao mdao = new MessageDao();
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("user");
        String friendId = request.getParameter("friendId");
        String msg      = request.getParameter("msg");
        
        if(u != null && friendId != null && !friendId.isEmpty() && msg != null && !msg.isEmpty()) {
            Message m = new Message(u.getUserId(), Integer.parseInt(friendId), msg);
            mdao.createMsg(m);
            return "/account.jsp?view=messages";
        }
        return "/error.jsp";
    }
    
}
