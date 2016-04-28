<%@page import="java.util.ResourceBundle"%>
<%@page import="java.util.Locale"%>
<%@page import="Dtos.Friend"%>
<%@page import="Daos.FriendDao"%>
<%@page import="Dtos.Merch"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="Dtos.Ad"%>
<%@page import="Daos.AdDao"%>
<%@page import="Dtos.Song"%>
<%@page import="Daos.SongDao"%>
<%@page import="Dtos.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            User currentUser     = null;
            String skin          = sWave.Server.DEFAULT_SKIN;
            Locale currentLocale = new Locale("en");

            if (session == null || (User)session.getAttribute("user") == null)
                response.sendRedirect("login.jsp?refer=search.jsp");
            else {
                currentUser   = (User)session.getAttribute("user");
                skin          = currentUser.getSkin();
                currentLocale = new Locale(currentUser.getLangPref());
            }

            final boolean DEBUG = sWave.Server.DEBUGGING;

            if (request.getParameter("addedToCart") != null && request.getParameter("addedToCart").equals("yes")) {
                %><script>alert("Added to Cart")</script><%
            }

            String term            = null;
            ArrayList<Song>  songs = null;
            ArrayList<Merch> merch = null;
            ArrayList<User>  users = null;
            if (request.getParameter("noResults") == null) {
                term  = (String)session.getAttribute("searchTerm");
                songs = (ArrayList<Song>)session.getAttribute("searchResults");
                merch = (ArrayList<Merch>)session.getAttribute("searchMerchResults");
                users = (ArrayList<User>)session.getAttribute("searchUserResults");
            }

            ResourceBundle messages = ResourceBundle.getBundle("i18n.content", currentLocale);
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="icon" type="image/png" href="images/favicon.png">
        <title>
            <%if (term != null) {%>
                Results for <%=term%> - sWave
            <%} else {%>
                No Results Found - sWave
            <%}%>
        </title>
        <!-- Import base Macgril CSS rules -->
        <link rel="stylesheet" type="text/css" href="macgril/css/base.css"/>
        <!-- Import Macgril's set of CSS animations -->
        <link rel="stylesheet" type="text/css" href="macgril/css/animation.css"/>
        <!-- Import Macgril skin to apply -->
        <link rel="stylesheet" type="text/css" href="macgril/css/skins/<%=skin%>/<%=skin%>.css"/>
        <!-- Import sWave site specific CSS -->
        <link rel="stylesheet" type="text/css" href="layout/base.css"/>
        <!-- Import sWave site specific Macgril skin overrides -->
        <link rel="stylesheet" type="text/css" href="layout/skins/<%=skin%>/base.css"/>
        <script src="macgril/js/dom.js"></script>
        <script src="macgril/js/io.js"></script>
        <script src="macgril/js/audio.js"></script>
        <script src="macgril/js/datetime.js"></script>
        <script src="macgril/js/notifications.js"></script>
        <script src="js/three.min.js"></script>
        <script src="js/audio_system.js"></script>
        <script src="js/streamer.js"></script>
        <script src="js/scripts.js"></script>
        <script src="js/image_loader.js"></script>
    </head>
    <body onload="loadUserPicture(<%=currentUser.getUserId()%>, $('userPic')); resumePlay()">
        <header class="panel" id="topbar">
            <%=sWave.Graphics.getLogo()%>
            <nav>
                <!-- Bunching up the anchor tags removes the gaps between them caused by the tabbing and inline-block -->
                <a href="playing.jsp"><%=messages.getString("musicNavVar")%></a><a href="shop.jsp"><%=messages.getString("shopNavVar")%></a><a href="account.jsp"><%=messages.getString("accountNavVar")%></a><a href="about.jsp"><%=messages.getString("aboutNavVar")%></a>
            </nav>
            <form id="searchBox" action="UserActionServlet" method="POST">
                <input type="hidden" name="action" value="search"/>
                <input type="search" class="text" name="searchterm" placeholder="<%=messages.getString("searchVar")%>"/>
            </form>
            <%=sWave.Graphics.s_cart%>
            <img id="userPic" onclick="showHideUserMenu()" width="50" height="50" src="images/test.png"/>
            
            <div id="userMenu" class="panel">
                <%if (currentUser != null) {%>
                    <a id="userNameDisplay" href="account.jsp?view=profile"><%=currentUser.getUsername()%></a><br/><br/>
                <%}%>
                <a href="account.jsp?view=friends"><%=messages.getString("friendsVar")%></a><br/>
                <a href="account.jsp?view=settings"><%=messages.getString("settingsVar")%></a><br/>
                <form id="langForm" action="UserActionServlet" method="POST">
                    <input type="hidden" name="action" value="updateDetails"/>
                    <input type="hidden" name="refPage" value="search.jsp"/>
                    <select name="lang" onchange="$('langForm').submit()">
                        <option value="en" <%if (currentLocale.getLanguage().equals("en")) {%>selected<%}%>>English</option>
                        <option value="fr" <%if (currentLocale.getLanguage().equals("fr")) {%>selected<%}%>>French</option>
                        <option value="de" <%if (currentLocale.getLanguage().equals("de")) {%>selected<%}%>>German</option>
                        <option value="it" <%if (currentLocale.getLanguage().equals("it")) {%>selected<%}%>>Italian</option>
                        <option value="jp" <%if (currentLocale.getLanguage().equals("jp")) {%>selected<%}%>>Japanese</option>
                        <option value="ru" <%if (currentLocale.getLanguage().equals("ru")) {%>selected<%}%>>Russian</option>
                    </select>
                </form>
                <form id="logOutButton" action="UserActionServlet" method="POST">
                    <input type="hidden" name="action" value="logout"/>
                    <input class="button" type="submit" value="<%=messages.getString("logoutVar")%>"/>
                </form>
            </div>
            
        </header>
        <aside class="panel" id="left_sidebar">
            <div id="visualizer"></div>
        </aside>
        <div id="midsection" class="noPadding">
            <div id="midUnderlay" class="panel"></div>
            <h2 id="numResultsDisplay"><%if (term == null && songs == null && merch == null && users == null) {%>
                No Results<%} else {%>
                Showing <%=songs.size() + merch.size() + users.size()%> Results for "<%=term%>"</h2>
                <table>
                <%
                    NumberFormat f = NumberFormat.getCurrencyInstance();
                    for (Song s : songs) {%>
                    <tr <%if (session.getAttribute("currentSong") != null && ((Song)session.getAttribute("currentSong")).getSongId() == s.getSongId()) {%>class="playing"<%}%>>
                            <%if (DEBUG) {%>
                                <td><%=s.getSongId()%></td>
                            <%}%>
                            <td><%=s.getTitle()%></td>
                            <td><%=s.getArtist()%></td>
                            <td><%=s.getGenre()%></td>
                            <td><%=s.getYear()%></td>
                            <td><%=f.format(s.getPrice())%></td>
                            <td><form action="UserActionServlet" method="POST">
                                    <input type="hidden" name="action" value="addSongToCart"/>
                                    <input type="hidden" name="songid" value="<%=s.getSongId()%>"/>
                                    <input type="hidden" name="price" value="<%=s.getPrice()%>"/>
                                    <input class="button" type="submit" value="Add to Cart"/>
                                </form>
                            </td>
                        </tr>
                <%} for (Merch m : merch) {%>
                        <tr>
                            <%if (DEBUG) {%>
                                <td><%=m.getMerchId()%></td>
                            <%}%>
                            <td><%=m.getTitle()%></td>
                            <td><%=f.format(m.getPrice())%></td>
                            <td><form action="UserActionServlet" method="POST">
                                    <input type="hidden" name="action" value="addMerchToCart"/>
                                    <input type="hidden" name="merchid" value="<%=m.getMerchId()%>"/>
                                    <input type="hidden" name="price" value="<%=m.getPrice()%>"/>
                                    <input type="number" value="1" min="1" name="qty"/>
                                    <input class="button" type="submit" value="Add to Cart"/>
                                </form>
                            </td>
                        </tr>
                <%}
                Friend fnd = null;
                FriendDao fdao = new FriendDao();
                ArrayList<Friend> friends = fdao.getUserFriends(currentUser.getUserId());
                ArrayList<Friend> pending = fdao.getPendingFriendRequests(currentUser.getUserId());

                for (User u : users) {%>
                    <tr>
                        <%if (DEBUG) {%>
                            <td><%=u.getUserId()%></td>
                        <%}%>
                        <td><%=u.getUsername()%></td>
                        <td>
                        <%
                            fnd = new Friend(currentUser.getUserId(), u.getUserId());
                            if (friends.contains(fnd) && !pending.contains(fnd)) {%>
                                <form action="UserActionServlet" method="POST">
                                    <input type="hidden" name="action" value="removeFriend"/>
                                    <input type="hidden" name="friendId" value="<%=u.getUserId()%>"/>
                                    <input class="button danger" type="submit" value="Unfriend"/>
                                </form>
                            <%} else if (!pending.contains(fnd)) {%>
                                <form action="UserActionServlet" method="POST">
                                    <input type="hidden" name="action" value="requestFriend"/>
                                    <input type="hidden" name="friendId" value="<%=u.getUserId()%>"/>
                                    <input class="button" type="submit" value="Befriend"/>
                                </form>
                            <%} else if (friends.contains(fnd) && friends.get(friends.indexOf(fnd)).getFriendId() == currentUser.getUserId()) {%>
                                <form action="UserActionServlet" method="POST">
                                    <input type="hidden" name="action" value="confirmFriend"/>
                                    <input type="hidden" name="friendId" value="<%=u.getUserId()%>"/>
                                    <input class="button" type="submit" value="Accept"/>
                                </form>
                            <%} else {%>
                                Pending
                            <%}%>
                        </td>
                    </tr>
                <%}%>
                </table>
            <%}%>
        </div>
        <%=sWave.UI.footer%>
        <div id="notifier" class="panel"></div>
        <div id="wallpaper"></div>
    </body>
</html>

