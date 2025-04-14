function test1() {
    /** name:hoist1 */
    function f() {}

    /** calls:hoist1 */
    f();
}

function test2() {
    /** calls:hoist2 */
    f();

    /** name:hoist2 */
    function f() {}
}

function test3() {
    {
        /** calls:hoist3 */
        f();

        /** name:hoist3 */
        function f() {}
    }
}
