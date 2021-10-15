// OK
function foo() {
    var urlParts = document.location.href.split('?');
    var loc = urlParts[0] + "?" + boxes.value;
    window.location = loc

    // Also OK.
    window.location.replace(window.location.href.split("#")[0] + "#mappage");
}
