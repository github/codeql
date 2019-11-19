function f1() {}
function g1(x) {}
function h1(x, y) {}
f1();
g1(23);
h1(23, 42);
new f1;
new f1();
new g1(23);
new h1(23, 42);

function g2(x,) {}
function h2(x,y,) {}
g2(23);
h2(23, 42);
g2(23,);
h2(23, 42,);
new g2(23,);
new h2(23, 42,);

(function(x,) {});
(function(x, y,) {});
(function g3(x,) {});
(function h3(x,y,) {});

(x) => x;
(x,) => x;
(x,y) => x;
(x,y,) => x;
() => 42;
x => x;

function f4(x = 42,) {}
