(function(){
    var x = SOURCE();

    SINK(x);

    if (BARRIER(x)) {
        SINK(x); // NOT FLAGGED
    } else {
        SINK(x);
    }

    SINK(x);
});
