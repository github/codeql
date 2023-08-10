function g() {
    using stream = getResource();   
    
    let (test = 20); // <- I didn't know this was a thing
    
    for (using stream2 = getResource(); ; ) {
        // ...
    }
}