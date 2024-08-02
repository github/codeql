import 'dummy';

function Foo() {
    this.foo = source();
    var obj = {
        bar: function() {
            sink(this.foo); // NOT OK
        }
    };
    Object.assign(this, obj);
}
