let async_ = require('async');

function source() {
    return 'TAINT'
}
function sink(x) {
    console.log(x)
}

async_.sortBy(['zz', source()],
    (x, cb) => cb(x.length),
    (err, result) => sink(result)); // NOT OK
