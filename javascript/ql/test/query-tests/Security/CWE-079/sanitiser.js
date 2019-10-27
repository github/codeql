function escapeHtml(s) {
    var amp = /&/g, lt = /</g, gt = />/g;
    return s.toString()
        .replace(amp, '&amp;')
        .replace(lt, '&lt;')
        .replace(gt, '&gt;');
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
