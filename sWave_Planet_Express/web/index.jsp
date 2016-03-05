<%@page import="Dtos.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%User currentUser = (User)session.getAttribute("user");%>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Welcome to sWave</title>
        <link rel="stylesheet" type="text/css" href="macgril/css/base.css"/>
        <%
            String skin = "flat";
            if (currentUser != null) {
                skin = currentUser.getSkin();
            }
        %>
        <link rel="stylesheet" type="text/css" href="macgril/css/skins/<%=skin%>/<%=skin%>.css"/>
        <style>
            #topbar {
                -moz-animation: slide_down 0.7s;
                position: fixed;
                top:      0px;
                left:     0px;
                width:    100%;
                height:   60px;
                padding:  0px;
                z-index:  2;
                box-shadow: 0px 0px 3px #000;
            }

            #base {
                -moz-animation: slide_up 0.7s;
                position: fixed;
                bottom:   0px;
                left:     0px;
                width:    100%;
                height:   90px;
                padding:  0px;
                z-index:  2;
                box-shadow: 0px 0px 3px #000;
            }

            #midsection {
                position: fixed;
                left:     200px;
                right:    200px;
                top:      60px;
                bottom:   90px;
                padding:  0px;
                z-index:  0;
            }

            #left_sidebar {
                -moz-animation: slide_right 0.7s;
                position: fixed;
                left:     0px;
                top:      60px;
                bottom:   90px;
                width:    200px;
                padding:  0px;
                z-index:  1;
                box-shadow: 0px 0px 3px #000;
            }

            #right_sidebar {
                -moz-animation: slide_left 0.7s;
                position: fixed;
                right:    0px;
                top:      60px;
                bottom:   90px;
                width:    200px;
                padding:  0px;
                z-index:  1;
                box-shadow: 0px 0px 3px #000;
            }

            #header_logo {
            }

            #header_right {
                position: fixed;
                top:      18px;
                right:    20px;
            }

            nav {
                position: fixed;
                top:      0px;
                left:     200px;
                height:   60px;
            }

            nav a {
                display:       inline-block;
                color:         #000;
                height:        24px;
                text-align:    center;
                padding-left:  10px;
                padding-right: 10px;
                margin:        0px;
                font-size:     24px;
                padding-top:    14px;
                padding-bottom: 22px;
            }

            nav a:hover {
                background-color: rgba(255, 255, 255, 0.5);
            }

            @-moz-keyframes slide_up {
                0% {-moz-transform: translateY(200px);}
                100% {-moz-transform: translateY(0px);}
            }

            @-moz-keyframes slide_down {
                0% {-moz-transform: translateY(-200px);}
                100% {-moz-transform: translateY(0px);}
            }

            @-moz-keyframes slide_left {
                0% {-moz-transform: translateX(200px);}
                100% {-moz-transform: translateX(0px);}
            }

            @-moz-keyframes slide_right {
                0% {-moz-transform: translateX(-200px);}
                100% {-moz-transform: translateX(0px);}
            }
        </style>
    </head>
    <body>
        <header class="panel" id="topbar">
            <img id="header_logo" src="images/logo_black.png" height="60"/>
            <nav>
                <a href="temp.html">Now Playing</a>
                <a href="temp.html">Library</a>
                <a href="temp.html">Music</a>
                <a href="temp.html">Shop</a>
                <a href="temp.html">Account</a>
                <a href="temp.html">About</a>
            </nav>
            <div id="header_right">
                <%if (currentUser != null) {%>
                    <a href="account.jsp"><%=currentUser.getUsername()%></a>
                    &#160;&#160;
                    <form style="display:inline;" action="UserActionServlet" method="POST">
                        <input type="hidden" name="action" value="logout"/>
                        <input type="submit" value="Log Out"/>
                    </form>
                <%} else {
                        response.sendRedirect("login.jsp");
                %>
                    <!-- In case the redirect fails for any reason provide a link -->
                    <a href="login.jsp">Log In</a>
                <%}%>
            </div>
        </header>
        <aside class="panel" id="left_sidebar">
        </aside>
        <div id="midsection">
        </div>
        <aside class="panel" id="right_sidebar">
        </aside>
        <footer class="panel" id="base">
        </footer>
        <div id="wallpaper"></div>
    </body>
</html>

