function escapeHtml(s) {
    return s.toString()
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;');
}

function escapeAttr(s) {
    return s.toString()
         .replace(/'/g, '%22')
         .replace(/"/g, '%27');
}

function test() {
  var tainted = window.name;
  var elt = document.createElement();
  elt.innerHTML = "<a href=\"" + escapeAttr(tainted) + "\">" + escapeHtml(tainted) + "</a>"; // OK
  elt.innerHTML = "<div>" + escapeAttr(tainted) + "</div>"; // NOT OK, but not flagged
}
