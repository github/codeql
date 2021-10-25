import 'dummy';

/** name:curry1 */
function curry1() {
    /** name:curry2 */
    function curry2(x) {
        /** name:curry3 */
        function curry3(y) {

        }
        return curry3;
    }
    return curry2;
};

/** calls:curry1 */
let r1 = curry1();

/** calls:curry2 */
let r2 = r1();

/** calls:curry3 */
r2();

function callback(f) {
    // Call graph should not include callback invocations.
    /** calls:NONE */
    f();
}

let w1 = callback(curry1);
callback(() => {});
