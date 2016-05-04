<%@page import="Dtos.Message"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="java.util.Locale"%>
<%@page import="Daos.MessageDao"%>
<%@page import="Daos.SongDao"%>
<%@page import="Dtos.Song"%>
<%@page import="Daos.FriendDao"%>
<%@page import="Dtos.Friend"%>
<%@page import="Dtos.Order"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="Dtos.UltimateOrder"%>
<%@page import="Daos.OrderDao"%>
<%@page import="Daos.UsersDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Daos.TicketDao"%>
<%@page import="Dtos.Ticket"%>
<%@page import="Dtos.Ticket"%>
<%@page import="Dtos.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            if (request.getParameter("view") == null) {
                response.sendRedirect("account.jsp?view=profile");
            }
            
            User currentUser     = null;
            String skin          = sWave.Server.DEFAULT_SKIN;
            Locale currentLocale = new Locale("en");

            if (session == null || (User)session.getAttribute("user") == null)
                response.sendRedirect("login.jsp?refer=account.jsp&view=" + request.getParameter("view"));
            else {
                currentUser   = (User)session.getAttribute("user");
                skin          = currentUser.getSkin();
                currentLocale = new Locale(currentUser.getLangPref());
            }

            final boolean DEBUG = sWave.Server.DEBUGGING;
            
            FriendDao fdao = new FriendDao();
            UsersDao  udao = new UsersDao();
            ArrayList<Friend> pending = fdao.getPendingFriendRequests(currentUser.getUserId());
            ArrayList<Friend> friends = fdao.getUserFriends(currentUser.getUserId());
            MessageDao mdao = new MessageDao();
            ArrayList<Message> conversation = null;

            ResourceBundle messages = ResourceBundle.getBundle("i18n.content", currentLocale);
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="icon" type="image/png" href="images/favicon.png">
        <title><%=messages.getString("accountNavVar")%> - sWave</title>
        <link rel="stylesheet" type="text/css" href="macgril/css/animation.css"/>
        <!-- Import base Macgril CSS rules -->
        <link rel="stylesheet" type="text/css" href="macgril/css/base.css"/>
        <!-- Import Macgril's set of CSS animations -->
        <link rel="stylesheet" type="text/css" href="macgril/css/animation.css"/>
        <!-- Import Macgril skin to apply -->
        <link id="skin1" rel="stylesheet" type="text/css" href="macgril/css/skins/<%=skin%>/<%=skin%>.css"/>
        <!-- Import sWave site specific CSS -->
        <link rel="stylesheet" type="text/css" href="layout/base.css"/>
        <!-- Import sWave site specific Macgril skin overrides -->
        <link id="skin2" rel="stylesheet" type="text/css" href="layout/skins/<%=skin%>/base.css"/>
        <script src="macgril/js/dom.js"></script>
        <script src="macgril/js/io.js"></script>
        <script src="macgril/js/datetime.js"></script>
        <script src="macgril/js/audio.js"></script>
        <script src="macgril/js/notifications.js"></script>
        <script src="js/three.min.js"></script>
        <script src="js/audio_system.js"></script>
        <script src="js/scripts.js"></script>
        <script src="js/image_loader.js"></script>
        <script src="js/uploader.js"></script>
        <script src="js/streamer.js"></script>
        <script src="js/chat.js"></script>
    </head>
    <body onload="loadUserPicture(<%=currentUser.getUserId()%>, $('userPic') <%if (request.getParameter("view") != null && request.getParameter("view").equals("profile")) {%>, $('largeUserPic')<%}%>); resumePlay()">
        <header class="panel" id="topbar">
            <%=sWave.Graphics.getLogo()%>
            <nav>
                <!-- Bunching up the anchor tags removes the gaps between them caused by the tabbing and inline-block -->
                <a href="playing.jsp"><%=messages.getString("musicNavVar")%></a><a href="shop.jsp"><%=messages.getString("shopNavVar")%></a><a class="currentPageLink" href="account.jsp"><%=messages.getString("accountNavVar")%></a><a href="about.jsp"><%=messages.getString("aboutNavVar")%></a>
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
                    <input type="hidden" name="refPage" value="account.jsp<%if (request.getParameter("view") != null) {%>?view=<%=request.getParameter("view")%><%}%>"/>
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
            <a href="account.jsp?view=profile" <%if (request.getParameter("view") != null && request.getParameter("view").equals("profile")) {%>class="currentPageLink"<%}%>><%=messages.getString("profileVar")%></a>
            <a href="account.jsp?view=friends" <%if (request.getParameter("view") != null && request.getParameter("view").equals("friends")) {%>class="currentPageLink"<%}%>><%=messages.getString("friendsVar")%></a>
            <a href="account.jsp?view=messages" <%if (request.getParameter("view") != null && request.getParameter("view").equals("messages")) {%>class="currentPageLink"<%}%>><%=messages.getString("messagesVar")%></a>
            <a href="account.jsp?view=orders" <%if (request.getParameter("view") != null && request.getParameter("view").equals("orders")) {%>class="currentPageLink"<%}%>><%=messages.getString("ordersVar")%></a>
            <a href="account.jsp?view=tickets" <%if (request.getParameter("view") != null && request.getParameter("view").equals("tickets")) {%>class="currentPageLink"<%}%>><%=messages.getString("ticketsVar")%></a>
            <a href="account.jsp?view=settings" <%if (request.getParameter("view") != null && request.getParameter("view").equals("settings")) {%>class="currentPageLink"<%}%>><%=messages.getString("settingsVar")%></a>
            <%if (currentUser != null && currentUser.isIsAdmin()) {%>
            <a href="account.jsp?view=admin" <%if (request.getParameter("view") != null && request.getParameter("view").equals("admin")) {%>class="currentPageLink"<%}%>><%=messages.getString("adminVar")%></a>
            <%}%>
            <div id="visualizer"></div>
        </aside>
        <div id="midsection">
            <%if (request.getParameter("view") != null && currentUser != null) {
                if (request.getParameter("view").equals("profile")) {%>
                    <div id="midUnderlay" class="panel"></div>
                    <div id="profileSidebar">
                        <img onclick="$('userPicField').click()" id="largeUserPic" src="images/test.png" width="200" height="200"/>
                        <progress id="uploadProgress2" max="100" value="0"></progress><br/>
                        <span id="progressInfo2"></span><br/>
                        <h5><u><%=messages.getString("clickPicVar")%> (<%=messages.getString("maxVar")%> 64kb)</u></h5>
                        <input id="userPicField" onchange="uploadUserPicture(<%=currentUser.getUserId()%>)" type="file" accept="image/*" name="userPicField"/>
                        <h2 id="nameDisplay"><%=(currentUser.getFname() + " " + currentUser.getLname())%></h2>
                    </div>
                    <h1><%=currentUser.getFname()%>'s <%=messages.getString("profileVar")%></h1>
                    <form action="UserActionServlet" method="POST" id="profileDetailsForm">
                        <input type="hidden" name="action" value="updateDetails"/>
                        <label><%=messages.getString("usernameVar")%>: </label><input class="text" name="username" type="text" placeholder="<%=messages.getString("usernameVar")%>" value="<%=currentUser.getUsername()%>"/><br/><br/>
                        <label><%=messages.getString("emailVar")%>: </label><input class="text" name="email" type="text" placeholder="<%=messages.getString("emailVar")%>" pattern="(.*)(\@)(.*)[.][a-z]{2,3}$" value="<%=currentUser.getEmail()%>"/><br/><br/>
                        <label><%=messages.getString("firstNameVar")%>: </label><input class="text" pattern="^[A-Z]{1}[a-z]{2,19}$" name="fname" type="text" placeholder="<%=messages.getString("firstNameVar")%>" value="<%=currentUser.getFname()%>"/><br/><br/>
                        <label><%=messages.getString("lastNameVar")%>: </label><input class="text" pattern="^[A-Z]{1}[a-z]{2,19}$" name="lname" type="text" placeholder="<%=messages.getString("lastNameVar")%>" value="<%=currentUser.getLname()%>"/><br/><br/>
                        <label><%=messages.getString("addressLine1Var")%>: </label><input class="text" type="text" name="add1" placeholder="Address Line 1" value="<%=currentUser.getAdd1()%>"/><br/><br/>
                        <label><%=messages.getString("addressLine2Var")%>: </label><input class="text" type="text" name="add2" placeholder="Address Line 2" value="<%=currentUser.getAdd2()%>"/><br/><br/>
                        <label><%=messages.getString("cityVar")%>: </label><input class="text" type="text" name="city" placeholder="<%=messages.getString("cityVar")%>" value="<%=currentUser.getCity()%>"/><br/><br/>
                        <label><%=messages.getString("countyVar")%>: </label>
                        <select name="county">
                            <option value="CW" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("CW")) {%>selected<%}%>>Carlow</option>
                            <option value="CN" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("CN")) {%>selected<%}%>>Cavan</option>
                            <option value="CL" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("CL")) {%>selected<%}%>>Clare</option>
                            <option value="C" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("C")) {%>selected<%}%>>Cork</option>
                            <option value="DL" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("DL")) {%>selected<%}%>>Donegal</option>
                            <option value="D" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("D")) {%>selected<%}%>>Dublin</option>
                            <option value="G" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("G")) {%>selected<%}%>>Galway</option>
                            <option value="K" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("K")) {%>selected<%}%>>Kerry</option>
                            <option value="KD" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("KD")) {%>selected<%}%>>Kildare</option>
                            <option value="KK" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("KK")) {%>selected<%}%>>Kilkenny</option>
                            <option value="LS" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("LS")) {%>selected<%}%>>Laois</option>
                            <option value="LM" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("LM")) {%>selected<%}%>>Leitrim</option>
                            <option value="LK" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("LK")) {%>selected<%}%>>Limerick</option>
                            <option value="LF" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("LF")) {%>selected<%}%>>Longford</option>
                            <option value="L" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("L")) {%>selected<%}%>>Louth</option>
                            <option value="M" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("M")) {%>selected<%}%>>Mayo</option>
                            <option value="MH" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("MH")) {%>selected<%}%>>Meath</option>
                            <option value="MO" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("MO")) {%>selected<%}%>>Monaghan</option>
                            <option value="O" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("O")) {%>selected<%}%>>Offaly</option>
                            <option value="R" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("R")) {%>selected<%}%>>Roscommon</option>
                            <option value="S" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("S")) {%>selected<%}%>>Sligo</option>
                            <option value="T" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("T")) {%>selected<%}%>>Tipperary</option>
                            <option value="WF" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("WF")) {%>selected<%}%>>Waterford</option>
                            <option value="WM" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("WM")) {%>selected<%}%>>Westmeath</option>
                            <option value="WX" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("WX")) {%>selected<%}%>>Wexford</option>
                            <option value="W" <%if (currentUser.getCounty() != null && currentUser.getCounty().equals("W")) {%>selected<%}%>>Wicklow</option>
                        </select>
                        <br/><br/>
                        <input class="button" type="submit" value="<%=messages.getString("updateDetailsVar")%>"/>
                    </form>
                <%} else if (request.getParameter("view").equals("orders")) {%>
                    <div id="midUnderlay" class="panel"></div>
                    <h1><%=messages.getString("myOrdersVar")%></h1>
                    <ul>
                        <%OrderDao orders = new OrderDao();
                        SongDao songs = new SongDao();
                        int count = 1;
                        NumberFormat f = NumberFormat.getCurrencyInstance();
                        for (UltimateOrder theOrder : orders.getFullOrders(currentUser.getUserId())) {%>
                        <li class="listing <%if (count % 2 == 0) {%>listingEven<%}%>">
                            <br/>
                            <table style="padding:10px;" width="100%">
                                <tr>
                                    <td><strong>Date:</strong> <%=theOrder.getDateOrdered()%></td>
                                    <td><strong>Songs:</strong> <%=theOrder.getSongSize()%></td>
                                    <td><strong>Merch:</strong> <%=theOrder.getMerchSize()%></td>
                                </tr>
                                <tr>
                                    <td>&#160;</td>
                                    <td>&#160;</td>
                                    <td>&#160;</td>
                                </tr>
                                <%for(int i = 0; i < theOrder.getSongSize(); i++) {
                                    Song s = songs.getSongById(theOrder.getSongId(i));%>
                                    <tr>
                                        <td><%=s.getTitle()%></td>
                                        <td><%=s.getArtist()%></td>
                                        <td><%=f.format(theOrder.getSongPrice(i))%></td>
                                    </tr>
                                <%}%>
                                <tr>
                                    <td>&#160;</td>
                                    <td>&#160;</td>
                                    <td>&#160;</td>
                                </tr>
                                <%for(int i = 0; i < theOrder.getMerchSize(); i++) {%>
                                    <tr>
                                        <td><%=theOrder.getTitle(i)%></td>
                                        <td><%=theOrder.getQty(i)%></td>
                                        <td><%=f.format(theOrder.getMerchPrice(i))%></td>
                                    </tr>
                                <%}%>
                                <tr>
                                    <td>&#160;</td>
                                    <td>&#160;</td>
                                    <td><%=f.format(theOrder.calcTotal())%> <strong>Total</strong></td>
                                </tr>
                            </table>
                        </li>
                <% count++;}%></ul><%
                } else if (request.getParameter("view").equals("messages")) {%>
                <div id="midUnderlay" class="panel"></div>
                <h1><%=messages.getString("messagesVar")%></h1>
                <form action="UserActionServlet" method="POST">
                    <input type="hidden" name="action" value="sendMessage"/>
                    <select name="friendId">
                        <%for (Friend f : friends) {%>
                        <option value="<%=f.getUserId()%>"><%=udao.getUserById(f.getUserId()).getUsername()%></option>
                        <%}%>
                    </select>
                    <textarea style="height:100px;" name="msg" placeholder="Type your Message Here"></textarea>
                    <br/><br/>
                    <input type="submit" value="Send"/>
                </form><br/>
                <ul id="itemList">
                <% 
                    for(Friend f : friends) {

                    if(f.getUserId() != currentUser.getUserId())
                        conversation = mdao.getConversation(f.getUserId());

                    else
                        conversation = mdao.getConversation(f.getFriendId());
                    
                    for(Message m : conversation) {
                        if(m.getSender() != currentUser.getUserId()) {
                            User u = udao.getUserById(m.getSender());
                    %>
                        <li class="panel listing listingEven">
                            <span class="songTitle"><%=messages.getString("sentFromVar")%> <%=u.getUsername()%></span><br/>
                            <span class="songArtist"><u><%=m.getDate()%></u></span><br/><br/>
                            <div class="msg">
                                <%=m.getContent()%>
                            </div>
                        </li>
                  <%} else {
                        User u = udao.getUserById(m.getReceiver());%>
                           <li class="panel listing">
                                <span class="songTitle"><%=messages.getString("sentToVar")%> <%=u.getUsername()%></span><br/>
                                <span class="songArtist"><u><%=m.getDate()%></u></span><br/><br/>
                                <div class="msg">
                                    <%=m.getContent()%>
                                </div>
                            </li>
                    <%}
                     }
                    }%>
                </ul>
                <%} else if (request.getParameter("view").equals("tickets")) {
                    if (request.getParameter("ticketView") != null && request.getParameter("ticketView").equals("closed")) {%>
                        <h1><%=messages.getString("closedTicketsVar")%></h1>
                        <a href="account.jsp?view=tickets"><%=messages.getString("openTicketsVar")%></a>
                    <%} else {%>
                        <h1><%=messages.getString("openTicketsVar")%></h1>
                        <a href="account.jsp?view=tickets&ticketView=closed"><%=messages.getString("closedTicketsVar")%></a>
                    <%}%>
                    <div id="midUnderlay" class="panel"></div>
                    <button id="cancelNewTicketButton" style="display:none;" onclick="$('newTicketForm').style.display='none'; $('cancelNewTicketButton').style.display='none'; $('newTicketButton').style.display='block'">Cancel</button>
                    <button id="newTicketButton" onclick="$('newTicketForm').style.display='block'; $('newTicketButton').style.display='none'; $('cancelNewTicketButton').style.display='block'"><%=messages.getString("openTicketButtonVar")%></button><br/>
                    <form id="newTicketForm" action="UserActionServlet" method="POST">
                        <input type="hidden" name="action" value="createTicket"/>
                        <input type="hidden" name="userId" value="<%=currentUser.getUserId()%>"/>
                        <textarea id="ticketIssue" name="issue" placeholder="Use this area to describe your issue"></textarea><br/><br/>
                        <input class="button" type="submit" value="Open"/>
                    </form>
                    <%
                        TicketDao tickDao = new TicketDao();
                        UsersDao   userDao = new UsersDao();
                        for (Ticket t : tickDao.getAllTickets()) {
                            if (!t.isResolved() ^ (request.getParameter("ticketView") != null && request.getParameter("ticketView").equals("closed"))) {
                            if (currentUser.isIsAdmin()) {%>
                                <br/>
                                <ul class="ticketList">
                                    <li class="panel listing songListing">
                                        <h3 class="ticketHeader"><%=messages.getString("ticketVar")%> <%=t.getTicketId()%><span class="ticketHeaderRight"><a href="mailto:<%=userDao.getUserById(t.getUserId()).getEmail()%>" target="_blank"><u><%=userDao.getUserById(t.getUserId()).getUsername()%></u></a>&#160;&#160;&#160;<u><%=t.getDateRaised()%></u></span></h3>
                                        <br/>
                                        <p class="ticketIssue">
                                            <%=t.getIssue()%>
                                        </p>
                                        <br/>
                                        <%if (!t.isResolved()) {%>
                                            <div class="listingRight">
                                                <form style="margin-left:10px;" method="POST" action="UserActionServlet">
                                                    <input type="hidden" name="action" value="closeTicket"/>
                                                    <input type="hidden" name="ticketId" value="<%=t.getTicketId()%>"/>
                                                    <input class="button" type="submit" value="Close"/>
                                                </form>
                                            </div>
                                        <%}%>
                                        <br/>
                                    </li>
                                </ul>
                            <%} else {
                                if (t.getUserId() == currentUser.getUserId()) {%>
                                    <ul class="ticketList">
                                        <li class="panel ticket">
                                            <h3 class="ticketHeader">Ticket <%=t.getTicketId()%><span class="ticketHeaderRight"><u><%=t.getDateRaised()%></u></span></h3>
                                            <br/>
                                            <span class="ticketIssue">
                                                <%=t.getIssue()%>
                                            </span>
                                            <br/><br/>
                                        </li>
                                    </ul>
                                <%}
                                }
                              }
                        }
                   } else if (request.getParameter("view").equals("friends")) {%>
                        <div id="midUnderlay" class="panel"></div>
                        <h1>Friends</h1>
                        <h3>Requests</h3>
                        <%if (pending.size() == 0) {%>
                            <h3>Nobody wants to be your Friend :^(</h3>
                        <%} else {%>
                            <ul>
                                <%for (Friend f : pending) {%>
                                    <%if (f.getFriendId() == currentUser.getUserId()) {%>
                                        <li>
                                            <img id="face<%=f.getFriendId()%>" src="images/test.png" width="100" height="100"/>
                                            <script>loadUserPicture(<%=f.getUserId()%>, $('face<%=f.getUserId()%>'));</script>
                                            <%=udao.getUserById(f.getUserId()).getFname()%>&#160;
                                            <%=udao.getUserById(f.getUserId()).getLname()%>&#160;
                                            (<%=udao.getUserById(f.getUserId()).getUsername()%>)<br/>
                                            <form action="UserActionServlet" method="POST">
                                                <input type="hidden" name="action" value="confirmFriend"/>
                                                <input type="hidden" name="friendId" value="<%=f.getUserId()%>"/>
                                                <input class="button" type="submit" value="Accept"/>
                                            </form>
                                        </li>
                                    <%}%>
                                  <%}%>
                            </ul>
                        <%}%>
                        <hr/>
                        <%if (friends.size() == 0) {%>
                                <h3>You have yet to discover the magic of friendship :^(</h3>
                        <%} else {%>
                        <h3>Current m9s</h3>
                        <ul style="padding-bottom:40px;">
                            <%for (Friend f : friends) {%>
                                <%if (f.getStatus() == 'c') {%>
                                    <li class="panel listing songListing">
                                        <div class="listingRight">
                                            <form action="UserActionServlet" method="POST">
                                                <input type="hidden" name="action" value="removeFriend"/>
                                                <input type="hidden" name="friendId" value="<%if (f.getUserId() == currentUser.getUserId()) {%><%=f.getFriendId()%><%} else {%><%=f.getUserId()%><%}%>"/>
                                                <input type="submit" class="button danger" value="Unfriend"/>
                                            </form>
                                        </div>
                                        <img class="artwork" id="face<%if (f.getUserId() == currentUser.getUserId()) {%><%=f.getFriendId()%><%} else {%><%=f.getUserId()%><%}%>2" src="images/test.png" width="100" height="100"/>
                                        <script>loadUserPicture(<%if (f.getUserId() == currentUser.getUserId()) {%><%=f.getFriendId()%><%} else {%><%=f.getUserId()%><%}%>, $('face<%if (f.getUserId() == currentUser.getUserId()) {%><%=f.getFriendId()%><%} else {%><%=f.getUserId()%><%}%>2'))</script>
                                        <span class="songTitle"><%=udao.getUserById(f.getUserId() == currentUser.getUserId() ? f.getFriendId() : f.getUserId()).getFname()%>&#160;<%=udao.getUserById(f.getUserId() == currentUser.getUserId() ? f.getFriendId() : f.getUserId()).getLname()%></span><br/>
                                        <span class="songArtist"><%=udao.getUserById(f.getUserId() == currentUser.getUserId() ? f.getFriendId() : f.getUserId()).getUsername()%></span>
                                    </li>
                                <%} else if (f.getStatus() == 'p' && f.getUserId() == currentUser.getUserId()) {%>
                                    <li class="panel listing songListing">
                                        <div class="listingRight">
                                            Pending
                                        </div>
                                        <img class="artwork" id="face<%if (f.getUserId() == currentUser.getUserId()) {%><%=f.getFriendId()%><%} else {%><%=f.getUserId()%><%}%>2" src="images/test.png" width="100" height="100"/>
                                        <script>loadUserPicture(<%if (f.getUserId() == currentUser.getUserId()) {%><%=f.getFriendId()%><%} else {%><%=f.getUserId()%><%}%>, $('face<%if (f.getUserId() == currentUser.getUserId()) {%><%=f.getFriendId()%><%} else {%><%=f.getUserId()%><%}%>2'))</script>
                                        <span class="songTitle"><%=udao.getUserById(f.getUserId() == currentUser.getUserId() ? f.getFriendId() : f.getUserId()).getFname()%>&#160;<%=udao.getUserById(f.getUserId() == currentUser.getUserId() ? f.getFriendId() : f.getUserId()).getLname()%></span><br/>
                                        <span class="songArtist"><%=udao.getUserById(f.getUserId() == currentUser.getUserId() ? f.getFriendId() : f.getUserId()).getUsername()%></span>
                                    </li>
                              <%}
                            }%>
                        </ul>
                        <%}%>
                   <%} else if (request.getParameter("view").equals("settings")) {%>
                        <div id="midUnderlay" class="panel"></div>
                        <form action="UserActionServlet" method="POST">
                            <input type="hidden" name="action" value="changeSkin"/>
                            <!--
                                The skin field must have custom inline CSS as we 
                                don't want it to be affected by differences in 
                                skin due to previews otherwise when previewing 
                                skins the selector might move around and create 
                                a horrible experience.
                            -->
                            <select name="skin" style="position:fixed; width:150px; height:30px; top: 80px; left: 220px;">
                                <option onmouseover="previewSkin('swave')" <%if (currentUser.getSkin().toLowerCase().equals("swave")) {%>selected="selected"<%}%>>sWave</option>
                                <option onmouseover="previewSkin('flat')" <%if (currentUser.getSkin().toLowerCase().equals("flat")) {%>selected="selected"<%}%>>Flat</option>
                            </select>
                                <br/><br/>
                            <input class="button" type="submit" value="Apply"/><br/><br/>
                        </form>
                        <em>Your Skin Preference will stored in our database and maintained across machines.</em>
                        <br/><br/>
                        <button onclick="clearlStore()">Clear Local Data</button>
                        <br/>
                    <%} else if (request.getParameter("view").equals("admin")) {
                            if (currentUser.isIsAdmin()) {%>
                                <div id="midUnderlay" class="panel"></div>
                                <h1><%=messages.getString("adminPanelVar")%></h1>
                                <h3><u>sWave <%=messages.getString("systemServerVar")%></u></h3>
                                <strong>CPUs:</strong> <%=sWave.Server.CPUs%><br/>
                                <strong>JVM <%=messages.getString("heapVar")%>:</strong> <%=sWave.Server.JVMHEAP%><br/><br/>
                                <h3><u><%=messages.getString("uploadTracksVar")%></u></h3>
                                <u><%=messages.getString("note2Var")%>)</u><br/>
                                <u><%=messages.getString("note3Var")%></u><br/><br/>
                                <input id="fileSelector" type="file" name="songBlob" accept="audio/mpeg" onchange="showSizes()" multiple/><br/>
                                <span id="fileSizes"></span><br/><br/>
                                <progress id="uploadProgress" max="100" value="0"></progress><span id="fileSizes"></span><br/>
                                <span id="progressInfo"></span><br/>
                                <button onclick="uploadSongs()">Upload</button>
                            <%} else {
                                response.sendRedirect("noperm.jsp");
                              }
                    }
            }%>
        </div>
        <%=sWave.UI.footer%>
        <div id="notifier" class="panel"></div>
        <div id="wallpaper"></div>
    </body>
</html>
