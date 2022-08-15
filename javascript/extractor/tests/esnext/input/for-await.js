async function foo() {
    for await (const call of calls) {
        call();    
    }
}

for await (const call of calls) {
    call();
}