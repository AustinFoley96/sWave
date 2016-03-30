/*
 * This file contains small scripts and code snippets needed throughout the 
 * website that don't fall into any specific subsystem like the audio system 
 * and are too specific to this project to be included in the Macgril framework.
 */

function previewSkin(skin) {
    $("skin1").href = "macgril/css/skins/" + skin + "/" + skin + ".css";
    $("skin2").href = "layout/skins/"      + skin + "/base.css";
    $("skin3").href = "layout/skins/"      + skin + "/account.css";
}

function showSizes() {
    var count = 0;
    var theFiles = $("fileSelector").files;
    for (var i = 0; i < theFiles.length; i++)
        count += theFiles[i].size;
    $("fileSizes").innerHTML = "Size of Upload: " + Math.round(count/1024/1024) + "MB (MAX 100MB)";
}