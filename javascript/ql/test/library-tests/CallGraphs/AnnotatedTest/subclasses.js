import 'dummy';

class Base {
    workInBase() {
        /** calls:methodInBase */
        this.methodInBase();

        /** calls:methodInSub1 calls:methodInSub2 */
        this.methodInSub();

        /** calls:overriddenInSub0 calls:overriddenInSub1 calls:overriddenInSub2 */
        this.overriddenInSub();
    }

    /** name:methodInBase */
    methodInBase() {
        /** calls:methodInSub1 calls:methodInSub2 */
        this.methodInSub();
    }

    /** name:overriddenInSub0 */
    overriddenInSub() {
    }
}

class Subclass1 extends Base {
    workInSub() {
        /** calls:methodInBase */
        this.methodInBase();

        /** calls:overriddenInSub1 */
        this.overriddenInSub();
    }

    /** name:methodInSub1 */
    methodInSub() {
    }

    /** name:overriddenInSub1 */
    overriddenInSub() {
    }
}

class Subclass2 extends Base {
    workInSub() {
        /** calls:methodInBase */
        this.methodInBase();

        /** calls:overriddenInSub2 */
        this.overriddenInSub();
    }

    /** name:methodInSub2 */
    methodInSub() {
    }

    /** name:overriddenInSub2 */
    overriddenInSub() {
    }
}
