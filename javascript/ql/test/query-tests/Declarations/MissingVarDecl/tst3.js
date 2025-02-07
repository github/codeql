function sc_alert(i) {
   for(;i;) ;
   foo;
}

function f(o) {
    for({x, ...rest} of o) // $ TODO-SPURIOUS: Alert
        console.log(x in rest);
}
