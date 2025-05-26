function f(){
    a.clientTop && a.clientTop, a.clientTop === !0; // $Alert
    a && a.clientTop; // $SPURIOUS:Alert
    a.clientTop, a.clientTop; // $SPURIOUS:Alert
    if(a) return a.clientTop && a.clientTop, a.clientTop === !0 // $SPURIOUS:Alert
    if(b) return b && (b.clientTop, b.clientTop && b.clientTop), null // $SPURIOUS:Alert
}
