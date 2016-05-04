/*
    Copyright 2015, 2016 Brian Millar
    This file is part of Macgril.
    Macgril is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Macgril is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with Macgril. If not, see <http://www.gnu.org/licenses/>
*/
/*
function $(name) {
    var id = document.getElementById(name);
    if ((id !== null) && (id !== undefined))
        return id;
    else {
        //switch these orders
        id = document.getElementsByTagName(name);
        if ((id[0] !== null) && (id[0] !== undefined))
            return id;
        else {
            id = [];
            var arr2 = document.body.childNodes;
            var j = 0;
            for (var i = 0; i < arr2.length; i++) {
                if (arr2[i].nodeType == 1) {
                    matcher = new RegExp("(" + x + ")"); //needs work
                    if (matcher.test(arr2[i].getAttribute("class"))) {
                        id[j] = arr2[i];
                        j++;
                    }
                }
            }
            if ((id[0] !== null) && (id[0] !== undefined))
                return id;
        }
    }
    return null;
}*/

function $(name) {
    var id = document.getElementById(name);
    if ((id !== null) && (id !== undefined))
        return id;
    else return undefined;
}

function generate(x, y, z) {
    var el = document.createElement(x);
    var id;
    if (z !== null) id = z;
    else id = "macgrilID" + (mgID++);
    el.setAttribute("id", id);
    $(y).appendChild(el);
    return id;
}

function genURL(x) {
    return URL.createObjectURL(x);
}

function elementIDToggle(id, element) {
    if ($(id) !== null && $(id) !== undefined)
        $(id).removeAttribute("id");
    element.id = id;
}

function switchTabs(id1, id2) {
    $(id1).style.display = "none";
    $(id2).style.display = "block";
}

function showHideIDs(idArray, x) {
    for (var i = 0; i < idArray.length; i++) {
        if (x === "show") $(idArray[i]).style.display = "block";
        else              $(idArray[i]).style.display = "none";
    }
}

function quickShake(element, passTwo) {
    $(element).style.transition       = "0.1s transform";
    $(element).style.MozTransition    = "0.1s transform";
    $(element).style.WebkitTransition = "0.1s transform";
    $(element).style.msTransition     = "0.1s transform";
    $(element).style.transform        = "translateX(-40px)";
    $(element).style.MozTransform     = "translateX(-40px)";
    $(element).style.WebkitTransform  = "translateX(-40px)";
    $(element).style.msTransform      = "translateX(-40px)";
    var timer1 = setTimeout(
        function() {
            $(element).style.transform       = "translateX(40px)";
            $(element).style.MozTransform    = "translateX(40px)";
            $(element).style.WebkitTransform = "translateX(40px)";
            $(element).style.msTransform     = "translateX(40px)";
            var timer2 = setTimeout(
                function() {
                    clearTimeout(timer1);
                    $(element).style.transform       = "translateX(0px)";
                    $(element).style.MozTransform    = "translateX(0px)";
                    $(element).style.WebkitTransform = "translateX(0px)";
                    $(element).style.msTransform     = "translateX(0px)";
                    clearTimeout(timer2);
                    if(!passTwo) quickShake(element, true);
                }, 100);
        }, 100);
}
