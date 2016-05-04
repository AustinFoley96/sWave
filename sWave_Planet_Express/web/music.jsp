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
                response.sendRedirect("login.jsp?refer=music.jsp");
            else {
                currentUser   = (User)session.getAttribute("user");
                skin          = currentUser.getSkin();
                currentLocale = new Locale(currentUser.getLangPref());
            }

            final boolean DEBUG = sWave.Server.DEBUGGING;

            if (request.getParameter("addedToCart") != null && request.getParameter("addedToCart").equals("yes")) {
                %><script>alert("Added to Cart")</script><%
            }
            
            int pageNum = 1;

            if (request.getParameter("pageNum") != null) {
                pageNum = Integer.parseInt(request.getParameter("pageNum"));
            }

            ResourceBundle messages = ResourceBundle.getBundle("i18n.content", currentLocale);
        %>
        <link rel="icon" type="image/png" href="images/favicon.png">
        <title><%=messages.getString("libraryVar")%> - sWave</title>
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
    </head>
    <body lang="<%=currentLocale.getLanguage()%>" onload="<%if (currentUser != null) {%>loadUserPicture(<%=currentUser.getUserId()%>, $('userPic')); <%}%>resumePlay()">
        <header class="panel" id="topbar">
            <%=sWave.Graphics.getLogo()%>
            <nav>
                <!-- Bunching up the anchor tags removes the gaps between them caused by the tabbing and inline-block -->
                <a class="currentPageLink" href="playing.jsp"><%=messages.getString("musicNavVar")%></a><a href="shop.jsp"><%=messages.getString("shopNavVar")%></a><a href="account.jsp"><%=messages.getString("accountNavVar")%></a><a href="about.jsp"><%=messages.getString("aboutNavVar")%></a>
            </nav>
            <form id="searchBox" action="UserActionServlet" method="POST">
                <input type="hidden" name="action" value="search"/>
                <input type="search" class="text" name="searchterm" placeholder="<%=messages.getString("searchVar")%>"/>
            </form>
            <%=sWave.Graphics.s_cart%>
            <img id="userPic" onclick="showHideUserMenu()" width="50" height="50" src="images/test.png"/>

            <div id="userMenu" class="panel">
                <a id="userNameDisplay" href="account.jsp?view=profile"><%=currentUser.getUsername()%></a><br/><br/>
                <a href="account.jsp?view=friends"><%=messages.getString("friendsVar")%></a><br/>
                <a href="account.jsp?view=settings"><%=messages.getString("settingsVar")%></a><br/>
                <form id="langForm" action="UserActionServlet" method="POST">
                    <input type="hidden" name="action" value="updateDetails"/>
                    <input type="hidden" name="refPage" value="music.jsp"/>
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
            <a href="playing.jsp"><%=messages.getString("nowPlayingVar")%></a>
            <a class="currentPageLink" href="music.jsp"><%=messages.getString("libraryVar")%></a>
            <a href="playlists.jsp"><%=messages.getString("playlistsVar")%></a>
            <div id="visualizer"></div>
        </aside>
            <%
                SongDao dao = new SongDao();
                ArrayList<Song> songs = dao.getAllSongs();
                int numPages = (int)Math.ceil(songs.size() / 15.0);
                if (pageNum < 1 || pageNum > numPages) pageNum = 1;
            %>
        <div id="midSectionNoPadding">
            <div id="midUnderlayOmni" class="panel"></div>
            <div id="omniBar" class="panel">
                <span id="pageSwitcher">
                    <%=messages.getString("paginationVar")%>: 
                    <%for (int i = 1; i <= numPages; i++) {%>
                        <a href="music.jsp?pageNum=<%=i%>" class="pageNum <%if (i == pageNum) {%>currentPageNum<%}%>"><%=i%></a>
                    <%}%>
                </span>
            </div>
            <ul id="itemList">
            <%
                Song s;
                NumberFormat f = NumberFormat.getCurrencyInstance();
                for (int i = (pageNum * 15) - 15; (i < pageNum * 15) && i < songs.size(); i++) {
                    s = songs.get(i);
                    %>
                    <li class="panel listing songListing">
                        <div class="listingRight">
                            <span class="songPrice"><%=f.format(s.getPrice())%></span>
                            <form id="add<%=s.getSongId()%>ToCart" style="display:none;" action="UserActionServlet" method="POST">
                                <input type="hidden" name="action" value="addSongToCart"/>
                                <input type="hidden" name="songid" value="<%=s.getSongId()%>"/>
                                <input type="hidden" name="price" value="<%=s.getPrice()%>"/>
                            </form>
                            <svg style="cursor:pointer;" onclick="$('add<%=s.getSongId()%>ToCart').submit()" width="40" height="40" viewBox="0 0 100 100">
                                <mask id="mask2" x="0" y="0" width="100" height="100">
                                    <rect x="0" y="0" width="100" height="100" fill="#fff"/>
                                    <rect x="32" y="47" width="30" height="5" fill="#000"/>
                                    <rect x="44" y="35" width="5" height="30" fill="#000"/>
                                </mask>
                                <circle class="iconCircleFilled" cx="78" cy="24" r="4"/>
                                <rect class="iconRectFilled" x="76" y="22" width="4" height="8"/>
                                <polygon class="iconPolyFilled" points="15,30 25,70 70,70 80,30" mask="url(#mask2)"/>
                                <rect class="iconRectFilled" x="64" y="65" width="4" height="12"/>
                                <rect class="iconRectFilled" x="33" y="75" width="37" height="4"/>
                                <circle class="iconCircleFilled" cx="33" cy="78" r="5"/>
                                <circle class="iconCircleFilled" cx="67" cy="78" r="5"/>
                            </svg>
                            <svg width="40" height="40" viewBox="0 0 100 100" onclick="$('overlay').style.display='block'; $('songId').value='<%=s.getSongId()%>'; $('addToPlaylist').style.display='block';">
                                <mask id="mask3" x="0" y="0" width="100" height="100">
                                    <rect x="0" y="0" width="100" height="100" fill="#fff"/>
                                    <rect x="28.5" y="34.5" width="20" height="5" fill="#000"/>
                                    <rect x="35.5" y="27" width="5" height="20" fill="#000"/>
                                </mask>
                                <rect class="iconRectFilled" x="25" y="22.5" width="50" height="60" mask="url(#mask3)"/>
                            </svg>
                            <svg width="40" height="40" viewBox="0 0 100 100" onclick='stream(<%=s.getSongId()%>);'>
                                <polygon class="iconPolyFilled" points="33,25 33,75 80,50"/>
                            </svg>
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
        </div>
        <%=sWave.UI.footer%>
        <div id="overlay" onclick="this.style.display='none'; $('addToPlaylist').style.display='none';"></div>
        <div id="addToPlaylist" class="panel">
            <h3>Add to Playlist</h3>
            <form action="UserActionServlet" method="POST">
                <input type="hidden" name="action" value="addSongToPlaylist"/>
                <input id="songId" type="hidden" name="songId"/>
                <label>Playlist: </label> 
                <select style="margin-left:10px;" name="playlistId">
                    <%
                        PlaylistDao playDao = new PlaylistDao();
                        for (Playlist p : playDao.getUserPlaylists(currentUser.getUserId())) {%>
                            <option value="<%=p.getPlaylistId()%>"><%=p.getTitle()%></option>
                        <%}%>
                </select><br/><br/>
                <input style="float:right;" class="button" type="submit" value="Add"/>
            </form>
        </div>
        <div id="notifier" class="panel"></div>
        <div id="wallpaper"></div>
    </body>
</html>

