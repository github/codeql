`x`
var v = 'foo';
`${v}`;
`${v} ${v}`;

`x ${v}`;

`x ${v} x`;

`x ${v} x ${v}`;

function f() {
    return "bar";
}
`${f()}`;

`${"x"}`;
`${"x"} ${"x"}`;

`x ${"x"}`;

`x ${"x"} x`;

`x ${"x"} x ${"x"}`;
