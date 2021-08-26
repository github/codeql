function f() {
    let foo;
    if (bar) foo ||= [];
    if (foo);
};

function g() {
    let foo;
    if (bar) foo ??= [];
    if (foo);
};

function h() {
    let foo = true;
    if (bar) foo &&= false;
    if (foo);
}