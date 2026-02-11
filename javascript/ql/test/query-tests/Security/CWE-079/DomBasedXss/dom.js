function t1() {
    const elm = document.getElementById("foo");
    const e2 = elm.getElementsByTagName("bar")[0];
    e2.innerHTML = window.name; // $ Alert
}
