(function(){
    let x = source();
    function nest1() {
        function nest2(){
            function nest3(v){
                sink(v);
            }
            return nest3;
        }
        return nest2;
    }
    nest1()()(x);
});
