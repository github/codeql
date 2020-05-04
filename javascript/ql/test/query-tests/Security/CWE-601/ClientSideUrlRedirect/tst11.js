// OK
function foo() {
    var urlParts = document.location.href.split('?');
    var loc = urlParts[0] + "?" + boxes.value;
    window.location = loc
}
