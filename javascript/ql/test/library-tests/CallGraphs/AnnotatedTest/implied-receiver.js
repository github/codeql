import 'dummy';

function fooFactoryFactory() {
    return function fooFactory() {
        return function foo() {
            /** calls:F.member */
            this.member();
        }
    }
}

function F() {
    this.foo = fooFactoryFactory()();
}

/** name:F.member */
F.prototype.member = function() {
    return 42;
};
