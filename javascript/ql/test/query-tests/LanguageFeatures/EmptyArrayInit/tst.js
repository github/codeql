var a = [],         // OK
    b = [1],        // OK
    c = [1, 2],     // OK
    d = [1, , 2],   // NOT OK
    e = [1,],       // OK
    f = [1, 2, ,],  // NOT OK
    g = [,1];       // NOT OK
