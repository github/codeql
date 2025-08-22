class C {
    method() {}
}

module.exports = function() {
    return new C();
}

module.exports.PublicClass = C;
