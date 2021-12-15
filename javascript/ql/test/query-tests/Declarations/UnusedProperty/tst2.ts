(function(){
    var o1: { p: int, q: int } = { p: 42, q: 42 };
    o1.q;

    var o2 = <{ p: int, q: int }>{ p: 42, q: 42 };
    o2.q;

    var o3: { p: int, q: int } = f();
    o3 = o3 || { p: 42, q: 42 };
    o3.q;

});

class C {
    private o: { p: int, q: int };

    constructor() {
        this.o = { p: 42, q: 42 };
        this.o.q;
    }
}

(function(){
    var o1: any = { p: 42, q: 42 };
    o1.q;
    var o2: any = { p: 42, q: 42 };
    var o3: { p: int, q: int } = o2;
})
