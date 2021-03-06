package Command;

import Daos.UsersDao;
import Dtos.User;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Austin
 */
public class LoginCommand implements Command {

    @Override
    public String executeCommand(HttpServletRequest request, HttpServletResponse response) {
        String forwardToJsp = null;
        UsersDao ud         = new UsersDao();
        String email        = request.getParameter("email");
        String password     = request.getParameter("password");

        //In case the textboxes were empty, should be checked by js but this is an extra check
        if (email != null && password != null) {
            //Make the user logging in
            User userLoggingIn = ud.logIn(email, password);

            //If the users credentials are correct
            if (userLoggingIn != null) {
                //Store the session id for this client...
                HttpSession session = request.getSession();
                String clientSessionId = session.getId();
                session.setAttribute("loggedSessionId", clientSessionId);

                //Store the user in the session
                session.setAttribute("user", userLoggingIn);

                /*
                    If the user was forced to the login page after trying to view 
                    some page the 'refer' parameter will contain the page they 
                    were trying to view and we will redirect them back there after 
                    login, otherwise we forward them to the home page.
                */
                if (request.getParameter("refer") != null)
                    forwardToJsp = "/" + request.getParameter("refer");
                else
                    forwardToJsp = "/index.jsp";
            } else
                forwardToJsp = "/login.jsp?failed=yes";
        } else
            forwardToJsp = "/login.jsp?failed=yes";
        return forwardToJsp;
    }
}
