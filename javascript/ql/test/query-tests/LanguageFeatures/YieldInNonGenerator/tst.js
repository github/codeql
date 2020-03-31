function idMaker(){
    var index = 0;
    while(true)
        // NOT OK
        yield index++;
}
