(function(){
    var v;
    (function(){
        if(typeof v === "undefined"){ // NOT OK
            v = 42;
        }
        for(var v in x){
        }
    });
});
