function g() {
    using stream = getResource();   
    
    let (test = 20); // <- I didn't know this was a thing
    
    for (using stream2 = getResource(); ; ) {
        // ...
        break;
    }
}

async function h() {
    await using stream = getResource();

    for (await using stream2 = getResource(); ; ) {
        // ...
        break;
    }

    console.log("end");
}

function usesUsing() {
    using("foo");
    function using(foo) {
        // ...
    }
    using(using);
}