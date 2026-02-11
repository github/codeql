async function t1() {
    const promise = Promise.try(() => {
        return source('try.1');
    });
    sink(await promise); // $ hasValueFlow=try.1
}

async function t2() {
    const promise = Promise.try((x) => {
        return x
    }, source('try.2'));
    sink(await promise); // $ hasValueFlow=try.2
}

async function t3() {
    const promise = Promise.try((x) => {
        throw x;
    }, source('try.3'));
    promise.catch(err => {
        sink(err); // $ hasValueFlow=try.3
    });
}

async function t4() {
    const promise = Promise.try((x, y) => {
        return y;
    }, source('try.4.1'), source('try.4.2'));
    sink(await promise); //  $ hasValueFlow=try.4.2
}
