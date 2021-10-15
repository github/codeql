for (var i=1; i<ids.lenght; ++i) {
    var id = ids[i];
    if (id) {
        var element = document.getElementById(id);
        element.className += " selected";
    }
}