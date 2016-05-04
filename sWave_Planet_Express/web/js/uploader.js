function uploadSongs() {
    var request  = new XMLHttpRequest();
    var formdata = new FormData();
    var files    = $("fileSelector").files;

    request.open("POST", "UserActionServlet", true);

    formdata.append("action", "upload");

    for (var i = 0; i < files.length; i++)
        formdata.append(files[i].name, files[i]);

    request.send(formdata);

    request.upload.onprogress = function(event) {
        $("uploadProgress").value = (100 / event.total) * event.loaded;
        if (!(event.loaded === event.total))
            $("progressInfo").innerHTML = "Uploaded " + (event.loaded / (1024 * 1024)).toFixed(2) + " of " + (event.total / (1024 * 1024)).toFixed(2) + " MB.";
        else
            $("progressInfo").innerHTML = "Processing...";
    };

    request.upload.onload = function(event) {
        $("progressInfo").innerHTML = "Done";
        notify($("notifier"), "Upload Complete", 3000);
    };
}

function uploadUserPicture(userid) {
    var request  = new XMLHttpRequest();
    var formdata = new FormData();
    var picture  = $("userPicField").files[0];

    request.open("POST", "UserActionServlet", true);
    formdata.append("action", "uploadUserPicture");
    formdata.append("userPicture", picture);
    request.send(formdata);

    request.upload.onprogress = function(event) {
        $("uploadProgress2").value = (100 / event.total) * event.loaded;
    };


    request.upload.onload = function(event) {
        notify($("notifier"), "Upload Complete", 3000);
        loadUserPicture(userid, $("userPic"));
        loadUserPicture(userid, $("largeUserPic"));
    };
}
