<%@page import="java.util.ResourceBundle"%>
<%@page import="java.util.Locale"%>
<%@page import="Dtos.Merch"%>
<%@page import="Daos.MerchDao"%>
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

            MerchDao mdao = new MerchDao();
            Merch m = null;
            if (request.getParameter("item") == null || mdao.getMerchById(Integer.parseInt(request.getParameter("item"))) == null) {
                response.sendRedirect("shop.jsp");
            } else {
                m = mdao.getMerchById(Integer.parseInt(request.getParameter("item")));
            }

            ResourceBundle messages = ResourceBundle.getBundle("i18n.content", currentLocale);
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="icon" type="image/png" href="images/favicon.png">
        <title>
            <%if (m != null) {%><%=m.getTitle()%><%} else {%>Product<%}%> - sWave</title>
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
        <script src="js/three_js/MTLLoader.js"></script>
        <script src="js/three_js/OBJMTLLoader.js"></script>
        <script src="js/audio_system.js"></script>
        <script src="js/scripts.js"></script>
        <script src="js/image_loader.js"></script>
        <script src="js/streamer.js"></script>
    </head>
    <body onload="<%if (currentUser != null) {%>loadUserPicture(<%=currentUser.getUserId()%>, $('userPic')); <%}%>resumePlay()">
        <header class="panel" id="topbar">
            <%=sWave.Graphics.getLogo()%>
            <nav>
                <!-- Bunching up the anchor tags removes the gaps between them caused by the tabbing and inline-block -->
                <a href="playing.jsp">Music</a><a class="currentPageLink" href="shop.jsp">Shop</a><a href="account.jsp">Account</a><a href="about.jsp">About</a>
            </nav>
            <form id="searchBox" action="UserActionServlet" method="POST">
                <input type="hidden" name="action" value="search"/>
                <input type="search" class="text" name="searchterm" placeholder="Search"/>
            </form>
            <%=sWave.Graphics.s_cart%>
            <div id="userMenu" class="panel">
                <%if (currentUser != null) {%>
                    <a id="userNameDisplay" href="account.jsp?view=profile"><%=currentUser.getUsername()%></a><br/><br/>
                <%}%>
                <a href="account.jsp?view=friends"><%=messages.getString("friendsVar")%></a><br/>
                <a href="account.jsp?view=settings"><%=messages.getString("settingsVar")%></a><br/>
                <form id="langForm" action="UserActionServlet" method="POST">
                    <input type="hidden" name="action" value="updateDetails"/>
                    <input type="hidden" name="refPage" value="product.jsp"/>
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
            <a href="shop.jsp">Back to Shop</a>
            <a href="cart.jsp">Go to Cart</a>
            <div id="visualizer"></div>
        </aside>
        <div id="midsection">
            <div id="midUnderlay" class="panel"></div>
            <%if (m != null) {
                NumberFormat f = NumberFormat.getCurrencyInstance();%>
                <%if (m.getTitle().equals("Mug")) {%>
                <div id="inlineRenderer"></div>
                <script>
                function renderInline() {
				scene	  = new THREE.Scene();
				container = $("inlineRenderer");

				camera    = new THREE.PerspectiveCamera(45, 1, 1, 100);
							camera.position.set(10, 8, 10);
							camera.lookAt(scene.position);
							scene.add(camera);

				renderer  = new THREE.WebGLRenderer({alpha:true, antialias:true});
							renderer.setSize(400, 400);
							renderer.domElement.setAttribute("id","renderCanvas");
							container.appendChild(renderer.domElement);

				ThreeClock     = new THREE.Clock();

				var loader = new THREE.OBJMTLLoader();
				model = null;
				loader.load("models/mug.obj", "models/mug.mtl", function(object) {object.position.set(3,0,2.2); object.scale.y = 2; object.scale.x = 2; object.scale.z = 2; model = object; addLighting();});
                            }
                            
                            function addLighting() {
                            light     = new THREE.DirectionalLight(0xFFFFFF, 0.75);
                                        light.position.set(300, 300, 300);
                                        scene.add(light);

                            light2    = new THREE.DirectionalLight(0xFFFFFF, 0.8);
                                        light2.position.set(-300, 300, -300);
                                        scene.add(light2);
                            
                            scene.add(model);
                            inlineAnimate();
                        }

			function inlineAnimate() {
					delta           =  ThreeClock.getDelta();
					model.rotation.y -= 0.02;
					//OBJECT.rotation.y += 0.01;
					setTimeout(requestAnimationFrame(inlineAnimate));
					renderer.render(scene, camera);
			}
                            renderInline();
                </script>
                <%} else {%>
                    <img style="float:left;" width="200" height="200" src="images/merch/<%=m.getMerchId()%>.jpg" alt="Picture of <%=m.getTitle()%>"/>
                <%}%>
                <div id="inlineRenderer">
                </div>
                <div id="productInfo">
                    <h2><%=m.getTitle()%></h2>
                    <span><%=messages.getString("priceVar")%>: <%=f.format(m.getPrice())%></span>
                    <form action="UserActionServlet" method="POST">
                        <input type="hidden" name="action" value="addMerchToCart"/>
                        <input type="hidden" name="merchid" value="<%=m.getMerchId()%>"/><br/>
                        <input type="hidden" name="price" value="<%=m.getPrice()%>"/>
                        <input class="number" type="number" value="1" min="1" name="qty"/>
                        <input class="button" type="submit" value="<%=messages.getString("addToCartVar")%>"/>
                    </form>
                </div>
            <%}%>
        </div>
        <%=sWave.UI.footer%>
        <div id="notifier" class="panel"></div>
        <div id="wallpaper"></div>
    </body>
</html>

