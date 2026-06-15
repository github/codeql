this.addEventListener('message', function(event) { // $ Source
    document.write(event.data); // $ Alert
})

this.addEventListener('message', function({data}) { // $ Source
    document.write(data); // $ Alert
})

function test() {
    function foo(x, event, y) { // $ Source
        document.write(x.data);
        document.write(event.data); // $ Alert
        document.write(y.data);
    }

    window.addEventListener("message", foo.bind(null, {data: 'items'}));

    window.onmessage = e => {
        if (e.origin !== "https://foobar.com") {
            return;
        }
        document.write(e.data); // OK - there is an origin check
    }

    window.onmessage = e => {
        if (mySet.includes(e.origin)) {
            document.write(e.data); // OK - there is an origin check
        }
    }
}
