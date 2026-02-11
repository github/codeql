function foo() {
    var urlParts = window.location.hash.split('?');
    var loc = urlParts[0] + "?" + boxes.value;
    window.location = loc; // OK - always starts with '#'
}
