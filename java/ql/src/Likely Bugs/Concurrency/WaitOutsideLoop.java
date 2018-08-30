synchronized (obj) {
    while (<condition is false>) obj.wait();
    // condition is true, perform appropriate action ...
}