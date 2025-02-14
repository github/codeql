import 'dummy';

class Base {
    workInBase() {
        /** calls:methodInBase */
        this.methodInBase();

        /** calls:methodInSub1 calls:methodInSub2 */
        this.methodInSub();

        /** calls:overridenInSub0 calls:overridenInSub1 calls:overridenInSub2 */
        this.overridenInSub();
    }

    /** name:methodInBase */
    methodInBase() {
        /** calls:methodInSub1 calls:methodInSub2 */
        this.methodInSub();
    }

    /** name:overridenInSub0 */
    overridenInSub() {
    }
}

class Subclass1 extends Base {
    workInSub() {
        /** calls:methodInBase */
        this.methodInBase();

        /** calls:overridenInSub1 */
        this.overridenInSub();
    }

    /** name:methodInSub1 */
    methodInSub() {
    }

    /** name:overridenInSub1 */
    overridenInSub() {
    }
}

class Subclass2 extends Base {
    workInSub() {
        /** calls:methodInBase */
        this.methodInBase();

        /** calls:overridenInSub2 */
        this.overridenInSub();
    }

    /** name:methodInSub2 */
    methodInSub() {
    }

    /** name:overridenInSub2 */
    overridenInSub() {
    }
}
