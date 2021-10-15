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
  elt.innerHTML = "<div>" + escapeAttr(tainted) + "</div>"; // NOT OK, but not flagged - [INCONSISTENCY]

  const regex = /[<>'"&]/;
  if (regex.test(tainted)) {
    elt.innerHTML = '<b>' + tainted + '</b>'; // NOT OK
  } else {
    elt.innerHTML = '<b>' + tainted + '</b>'; // OK
  }
  if (!regex.test(tainted)) {
    elt.innerHTML = '<b>' + tainted + '</b>'; // OK
  } else {
    elt.innerHTML = '<b>' + tainted + '</b>'; // NOT OK
  }
  if (regex.exec(tainted)) {
    elt.innerHTML = '<b>' + tainted + '</b>'; // NOT OK
  } else {
    elt.innerHTML = '<b>' + tainted + '</b>'; // OK
  }
  if (regex.exec(tainted) != null) {
    elt.innerHTML = '<b>' + tainted + '</b>'; // NOT OK
  } else {
    elt.innerHTML = '<b>' + tainted + '</b>'; // OK
  }
  if (regex.exec(tainted) == null) {
    elt.innerHTML = '<b>' + tainted + '</b>'; // OK
  } else {
    elt.innerHTML = '<b>' + tainted + '</b>'; // NOT OK
  }

  elt.innerHTML = tainted.replace(/<\w+/g, ''); // NOT OK
}
