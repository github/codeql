function t1() {
    const { ...rest } = source('t1.1');
    rest; // $ getALocalSource=rest
}

function t2() {
    const [ ...rest ] = source('t2.1');
    rest; // $ getALocalSource=rest
}

function t3() {
    const { p1, ...rest } = source('t3.1');
    p1; // $ getALocalSource=p1
    rest; // $ getALocalSource=rest
}
