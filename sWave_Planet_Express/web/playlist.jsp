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
        <title><%if (p != null) {%><%=p.getTitle()%><%} else {%>Playlist<%}%> - sWave</title>
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
        <script src="js/sWaveAudioSystem.js"></script>
        <script src="js/sWaveScripts.js"></script>
        <script src="js/ajax_image_loader.js"></script>
        <script src="js/ajax_streamer.js"></script>
        <script src="js/cover_flow.js"></script>
    </head>
    <body onkeypress="checkKey(event)" onload="<%if (currentUser != null) {%>loadUserPicture(<%=currentUser.getUserId()%>, $('userPic')); <%}%>resumePlay(); flow(<%=songs.size()%>);">
        <header class="panel" id="topbar">
            <%=sWave.Graphics.getLogo()%>
            <nav>
                <!-- Bunching up the anchor tags removes the gaps between them caused by the tabbing and inline-block -->
                <a href="playing.jsp">Music</a><a class="currentPageLink" href="shop.jsp">Shop</a><a href="account.jsp">Account</a><a href="about.jsp">About</a>
            </nav>
            <form id="searchBox" action="UserActionServlet" method="POST">
                <input type="hidden" name="action" value="search"/>
                <input type="search" name="searchterm" placeholder="Search"/>
            </form>
            <%=sWave.Graphics.s_cart%>
            <img id="userPic" onclick="showHideUserMenu()" width="50" height="50" src="images/test.png"/>
            <div id="userMenu" class="panel">
                <a id="userNameDisplay" href="account.jsp?view=profile"><%=currentUser.getUsername()%></a>
                <form id="logOutButton" action="UserActionServlet" method="POST">
                    <input type="hidden" name="action" value="logout"/>
                    <input type="submit" value="Log Out"/>
                </form>
            </div>
        </header>
        <aside class="panel" id="left_sidebar">
            <a href="playlists.jsp">Back to Playlists</a>
            <div id="visualizer"></div>
        </aside>
        <div id="midsection">
            <div id="midUnderlay" class="panel"></div>
            <div id="coverFlow">
                <%
                for (int i = 1; i <= songs.size(); i++) {%>
                    <img id="cover<%=i%>"/>
                    <script>
                        loadArtwork(<%=songs.get(i - 1).getSongId()%>, $("cover<%=i%>"));
                    </script>
                <%}%>
            </div>
            <%if (p != null) {
                NumberFormat f = NumberFormat.getCurrencyInstance();%>
                <h2><%=p.getTitle()%></h2>
                <ul>
                    <%for (Song s : p.getPlaylistContents()) {%>
                    <li>
                        <%=s.getArtist()%> : <%=s.getTitle()%>
                        <form action="UserActionServlet" method="POST">
                            <input type="hidden" name="action" value="moveSongInPlaylist"/>
                            <input type="hidden" name="songid" value="<%=s.getSongId()%>"/>
                            <input type="hidden" name="playlistid" value="<%=p.getPlaylistId()%>"/>
                            <input type="hidden" name="direction" value="up"/>
                            <input type="submit" value="Move Up"/>
                        </form>
                        <form action="UserActionServlet" method="POST">
                            <input type="hidden" name="action" value="moveSongInPlaylist"/>
                            <input type="hidden" name="songid" value="<%=s.getSongId()%>"/>
                            <input type="hidden" name="playlistid" value="<%=p.getPlaylistId()%>"/>
                            <input type="hidden" name="direction" value="down"/>
                            <input type="submit" value="Move Down"/>
                        </form>
                        <form action="UserActionServlet" method="POST">
                            <input type="hidden" name="action" value="deleteFromPlaylist"/>
                            <input type="hidden" name="songId" value="<%=s.getSongId()%>"/>
                            <input type="hidden" name="playlistId" value="<%=p.getPlaylistId()%>"/>
                            <input type="submit" value="Remove"/>
                        </form>
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

