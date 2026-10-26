(function extent(){
    function f0(){}

    function f1(){}
    f1();

    function f2(){}
    f2();
    f2();

    function f3(){}
    function f3(){}
    f3();

    var f4 = function(){}
    f4();

    function f5(){}
    f5 = function(){};
    f5();

    function f6(){}
    g(f6);
    f6();

    var f7 = function(){}
    f7();
    f7();
})();
(function types(){
    function f_zero() {
        return 0;
    }
    function f_null() {
        return null;
    }
    f_null() == f_zero();

    function f_id1(v) {
        return v;
    }
    function f_id2(v) {
        return v;
    }
    f_id1(0) == f_id2(null);
})();
export function foo() {

}
foo();
export default function bar() {

}
bar();

var foo1 = function foo1(){

}
foo1();
export {foo1};
