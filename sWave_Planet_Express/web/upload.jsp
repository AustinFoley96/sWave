<%@page import="Dtos.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%User currentUser = (User)session.getAttribute("user");
          if (currentUser == null) {
              response.sendRedirect("login.jsp");
          }
          else {
              if (!currentUser.isIsAdmin()) {
                  response.sendRedirect("noperm.jsp");
              }
          }
            String skin = "swave";
            if (currentUser != null) {
                skin = currentUser.getSkin();
            }
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="macgril/css/skins/<%=skin%>/<%=skin%>.css"/>
        <title>Upload</title>
        <script src="macgril/js/dom.js"></script>
        <script>
            function showSizes() {
                var count = 0;
                var theFiles = $("fileSelector").files;
                for (var i = 0; i < theFiles.length; i++)
                    count += theFiles[i].size;
                $("fileSizes").innerHTML = "Size of Upload: " + Math.round(count/1024/1024) + "MB (MAX 100MB)";
            }
        </script>
    </head>
    <body style="color:#e3e3e3; text-shadow: 0px 0px 10px #000;">
        <h1>Admin Panel</h1>
        <form action="UserActionServlet" method="POST" enctype="multipart/form-data">
            <h3>Upload Tracks</h3>
            <h5><u>Note: Only MP3 format files under 16MB can be uploaded.</u></h5>
            <h5><u>Note: To prevent overloading the server only 100MB of uploading is allowed at a time</u></h5>
            <input type="hidden" name="action" value="upload"/>
            <div>
                <p>Drag & Drop Files Here
            </div>
            <input id="fileSelector" type="file" name="songBlob" accept="audio/mpeg" onchange="showSizes()" multiple/><br/>
            <span id="fileSizes"></span>
            <input type="submit" value="Upload"/>
        </form>
    </body>
</html>
