<%@page import="java.util.ResourceBundle"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Dtos.Playlist"%>
<%@page import="Daos.PlaylistDao"%>
<%@page import="java.text.NumberFormat"%>
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
                response.sendRedirect("login.jsp?refer=product.jsp");
            else {
                currentUser   = (User)session.getAttribute("user");
                skin          = currentUser.getSkin();
                currentLocale = new Locale(currentUser.getLangPref());
            }

            final boolean DEBUG = sWave.Server.DEBUGGING;

            PlaylistDao pdao = new PlaylistDao();
            Playlist p = null;
            if (request.getParameter("playlist") == null || pdao.getPlaylistById(Integer.parseInt(request.getParameter("playlist"))) == null) {
                response.sendRedirect("playlists.jsp");
            } else {
                p = pdao.getPlaylistById(Integer.parseInt(request.getParameter("playlist")));
            }
            
            ArrayList<Song> songs = p.getPlaylistContents();

            ResourceBundle messages = ResourceBundle.getBundle("i18n.content", currentLocale);
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="icon" type="image/png" href="images/favicon.png">
        <title><%if (p != null) {%><%=p.getTitle()%><%} else {%><%=messages.getString("playlistVar")%><%}%> - sWave</title>
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
        <script src="js/scripts.js"></script>
        <script src="js/image_loader.js"></script>
        <script src="js/streamer.js"></script>
        <script src="js/cover_flow.js"></script>
    </head>
    <body onkeypress="checkKey(event)" onload="<%if (currentUser != null) {%>loadUserPicture(<%=currentUser.getUserId()%>, $('userPic')); <%}%>resumePlay(); flow(<%=songs.size()%>);">
        <header class="panel" id="topbar">
            <%=sWave.Graphics.getLogo()%>
            <nav>
                <!-- Bunching up the anchor tags removes the gaps between them caused by the tabbing and inline-block -->
                <a class="currentPageLink" href="playing.jsp"><%=messages.getString("musicNavVar")%></a><a href="shop.jsp"><%=messages.getString("shopNavVar")%></a><a href="account.jsp"><%=messages.getString("accountNavVar")%></a><a href="about.jsp"><%=messages.getString("aboutNavVar")%></a>
            </nav>
            <form id="searchBox" action="UserActionServlet" method="POST">
                <input type="hidden" name="action" value="search"/>
                <input type="search" class="text" name="searchterm" placeholder="Search"/>
            </form>
            <%=sWave.Graphics.s_cart%>
            <img id="userPic" onclick="showHideUserMenu()" width="50" height="50" src="images/test.png"/>
            <div id="userMenu" class="panel">
                <a id="userNameDisplay" href="account.jsp?view=profile"><%=currentUser.getUsername()%></a><br/><br/>
                <a href="account.jsp?view=friends"><%=messages.getString("friendsVar")%></a><br/>
                <a href="account.jsp?view=settings"><%=messages.getString("settingsVar")%></a><br/>
                <form id="langForm" action="UserActionServlet" method="POST">
                    <input type="hidden" name="action" value="updateDetails"/>
                    <input type="hidden" name="refPage" value="playlists.jsp"/>
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
            <a href="playlists.jsp">Back to Playlists</a>
            <div id="visualizer"></div>
        </aside>
        <div id="midsection">
            <div id="midUnderlay" class="panel"></div>
            <%if (p != null) {
                NumberFormat f = NumberFormat.getCurrencyInstance();%>
                <h2><%=p.getTitle()%></h2>
                <%if (songs.size() >= 9) {%>
                        <div id="coverFlow">
                            <%for (int i = 1; i <= 9; i++) {%>
                                <img id="cover<%=i%>"/>
                                <script>
                                    loadArtwork(<%=songs.get(i - 1).getSongId()%>, $("cover<%=i%>"));
                                </script>
                            <%}%>
                        </div>
                    <%}%>
                <ul>
                    <%for (Song s : p.getPlaylistContents()) {%>
                    <li class="panel listing songListing">
                        <div class="listingRight">
                            <svg width="40" height="40" viewBox="0 0 100 100" onclick='stream(<%=s.getSongId()%>);'>
                                <polygon class="iconPolyFilled" points="33,25 33,75 80,50"/>
                            </svg>
                            <form action="UserActionServlet" method="POST">
                                <input type="hidden" name="action" value="deleteFromPlaylist"/>
                                <input type="hidden" name="songId" value="<%=s.getSongId()%>"/>
                                <input type="hidden" name="playlistId" value="<%=p.getPlaylistId()%>"/>
                                <input class="button danger" type="submit" value="Remove"/>
                            </form>
                        </div>
                        <img class="artwork" id="artwork<%=s.getSongId()%>" alt="Artwork for <%=s.getAlbum()%>" src="images/artwork.png"/>
                        <script>loadArtwork(<%=s.getSongId()%>, $("artwork<%=s.getSongId()%>"))</script>
                        <%if (s.getTitle() != null && !s.getTitle().isEmpty() && !s.getTitle().equalsIgnoreCase("Title")) {%>
                            <span class="songTitle"><%=s.getTitle()%>
                                <%if (s.getUploaded() != null && ((System.currentTimeMillis() - s.getUploaded().getTime()) < 172800000)) {%>
                                    <span class="newBadge"><%=messages.getString("newVar")%></span>
                                <%}%>

                            </span><br/>
                        <%}%>
                        <%if (s.getArtist() != null && !s.getArtist().isEmpty() && !s.getArtist().equalsIgnoreCase("Artist")) {%>
                            <span class="songArtist"><%=s.getArtist()%></span><br/>
                        <%}%>
                        <%if (s.getAlbum() != null && !s.getAlbum().isEmpty() && !s.getAlbum().equalsIgnoreCase("Album")) {%>
                            <span class="songAlbum"><%=s.getAlbum()%></span><br/>
                        <%}%>
                        <%boolean yearShown = false; if (s.getYear() != 0) { yearShown = true;%>
                            <span class="songYear"><%=s.getYear()%></span>
                        <%}%>
                        <%if (s.getGenre() != null && !s.getGenre().isEmpty() && !s.getGenre().equalsIgnoreCase("Genre")) {%>
                            <span <%if (yearShown) {%>class="songGenre">&#160;|&#160;<%} else {%>class="songYear"><%}%><%=s.getGenre()%></span>
                        <%}%>
                    </li>
                    <%}%>
                </ul>
            <%}%>
        </div>
        <%=sWave.UI.footer%>
        <div id="notifier" class="panel"></div>
        <div id="wallpaper"></div>
    </body>
</html>

