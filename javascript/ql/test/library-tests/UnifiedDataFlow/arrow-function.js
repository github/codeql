import 'dummy';

function t1() {
    class C {
        foo() {
            const fn = () => {
                sink(this.bar()); // $ hasValueFlow=t1.1
            }
        }
        bar() {
            return source('t1.1');
        }
    }
}
