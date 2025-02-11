function selectElements(ids) {
    for (var i=0, length=ids.length; i<lenght; ++i) { // $ TODO-SPURIOUS: Alert
        var id = ids[i];
        if (id) {
            var element = document.getElementById(id);
            element.className += " selected";
        }
    }
}
