function foo() {
    let taint = window.location.hash.substring(1);
    new RegExp(taint); // OK - we do not flag RegExp injection on the client side as the impact is too low
}
