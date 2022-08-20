this.addEventListener('message', function(event) {
    document.write(event.data); // NOT OK
})

this.addEventListener('message', function({data}) {
    document.write(data); // NOT OK
})

function test() {
    function foo(x, event, y) {
        document.write(x.data);     // OK
        document.write(event.data); // NOT OK
        document.write(y.data);     // OK
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
