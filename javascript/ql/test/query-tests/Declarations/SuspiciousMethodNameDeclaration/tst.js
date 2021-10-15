 // OK: don't report anything in .js files.
function getStuff(number) {
    return {
        "new": function() {
            
        },
        "constructor": 123,
        "function": "this is a string!"
    }
}

class Foobar {
    new() {
        return 123;
    }
    function() {
        return "string";
    }
}
