(function(){
    var used_by_eval = f();
    eval(src);
});
(function(){
    eval(src);
    var used_by_eval = f();
});
(function(){
    var not_used_by_eval = f();
    (function(){
        eval(src);
    })
});
(function(){
    (function(){
        eval(src);
    })
    var not_used_by_eval = f();
});
