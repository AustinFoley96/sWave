<%@page import="Dtos.Merch"%>
<%@page import="Daos.MerchDao"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="Dtos.Song"%>
<%@page import="Daos.SongDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Dtos.CartItem"%>
<%@page import="Dtos.User"%>
<%@page import="Dtos.UltimateOrder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="icon" type="image/png" href="images/favicon.png">
        <title>Thank You - sWave</title>
        <%
            User currentUser = (User)session.getAttribute("user");
            final boolean DEBUG = sWave.Server.DEBUGGING;
        %>
    </head>
    <body>
        <%
        if (session.getAttribute("user") != null) {
            currentUser = ((User)session.getAttribute("user"));
        } else {
            response.sendRedirect("login.jsp");
        }
        if (session.getAttribute("wasActuallyBought") != null && (boolean)session.getAttribute("wasActuallyBought")) {
            if (session.getAttribute("theUltimateOrder") != null) {
                UltimateOrder theUltimateOrder = (UltimateOrder)session.getAttribute("theUltimateOrder");
                NumberFormat f = NumberFormat.getCurrencyInstance();%>
                <h1>Thank You <%=currentUser.getFname()%></h1>
                <hr/>
                <h5>You bought <%=theUltimateOrder.getMerchSize()%> Unique Merch items and <%=theUltimateOrder.getSongSize()%> Unique Songs worth a total of <%=f.format(theUltimateOrder.getTotal())%></h5>
                <%
                SongDao dao = new SongDao();
                for (CartItem c : (ArrayList<CartItem>)session.getAttribute("cart")) {
                    if (c.getType()) {
                        Song s = dao.getSongById(c.getProdId());
                    
                %>
                    <form action="UserActionServlet" method="POST">
                        <input type="hidden" name="action" value="stream"/>
                        <input type="hidden" name="download" value="yes"/>
                        <input type="hidden" name="songid" value="<%=s.getSongId()%>"/>
                        <input type="submit" value="Download <%=s.getTitle()%>"/>
                    </form>
                <%}}%>
                <hr/>
                <h5>Please find below your receipt</h5>
                <hr/>
                <h2><u>Receipt</u></h2>
                <h5>User: <%=currentUser.getUsername()%></h5>
                <h5>Full Name: <%=currentUser.getFname() + " " + currentUser.getLname()%></h5>
                <h5>Date: <%=theUltimateOrder.getDateOrdered()%></h5>
                <h5>Total: <%=f.format(theUltimateOrder.getTotal())%></h5>
                <ul>
                <%
                ArrayList<CartItem> cart = (ArrayList<CartItem>)session.getAttribute("cart");
                for (CartItem c : cart) {
                    Object x;
                    
                    if (c.getType()) {
                        SongDao sdao = new SongDao();
                        x = sdao.getSongById(c.getProdId());
                    }
                    else {
                        MerchDao mdao = new MerchDao();
                        x = mdao.getMerchById(c.getProdId());
                    }
                %>
                    <li>
                        <%if (x instanceof Song) {%>
                        <span>Song - </span>
                        <span>Title: <%=((Song)x).getTitle()%></span><br/>
                        <span>Artist: <%=((Song)x).getArtist()%></span><br/>
                        <%} else {%>
                            <span>Merch Item - </span>
                            <span>Name: <%=((Merch)x).getTitle()%></span><br/>
                            <span>Quantity: <%=c.getQty()%></span><br/>
                        <%}%>
                        <span>Price: <%=f.format(c.getPrice())%></span>
                        <hr/>
                    </li>
            <%}%>
        </ul>
                <hr/>
                <form action="UserActionServlet" method="POST">
                    <input type="hidden" value="logout" name="action"/>
                    <label>The button below complete your transaction and will log you out.</label><br/>
                    <input type="submit" value="Finish Transaction"/>
                </form>
                <hr/>
            <%}
        %>
            
        
        <%}%>
    </body>
</html>
