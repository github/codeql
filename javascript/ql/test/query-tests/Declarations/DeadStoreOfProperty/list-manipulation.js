(function(){
    var first = f();

    function flush() {
        var flushed = first;

        var next = g();
        first = next;
        next.prev = 42;

        flushed.prev = 42;
    }
});
