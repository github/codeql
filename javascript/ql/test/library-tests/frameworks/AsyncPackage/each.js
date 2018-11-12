let async_ = require('async');

function source() {
    return 'TAINT'
}
function sink(x) {
    console.log(x)
}

async_.each(
    [1, source(), 2], 
    function (item, callback) {
      sink(item); // NOT OK
      callback(null, 'Hello ' + item);
    },
    function (err, result) {
      sink(err); // OK
      sink(result); // OK - 'each' does not propagate return value
    }
)
