import 'dummy';

function t1() {
    function getInner() {
        return () => source('t1.1');
    }
    const x = getInner()();
    sink(x); // $ hasValueFlow=t1.1
}

function t2() {
    function getInner() {
        return (x) => sink(x); // $ hasValueFlow=t2.1
    }
    getInner()(source('t2.1'));
}
