let async_ = require('async');

function source() {
    return 'TAINT'
}
function sink(x) {
    console.log(x)
}

async_.map([source()],
    (item, cb) => {
        sink(item), // NOT OK
        cb(null, 'safe');
    },
    (err, result) => sink(result) // OK
);

async_.map(['safe'],
    (item, cb) => {
        let src = source();
        cb(null, src);
    },
    (err, result) => sink(result) // NOT OK
);

async_.map([source()],
    (item, cb) => cb(null, item.substring(1)),
    (err, result) => sink(result) // NOT OK
);

async_.map(['safe'],
    (item, cb) => cb(null, item),
    (err, result) => sink(result) // OK
);
