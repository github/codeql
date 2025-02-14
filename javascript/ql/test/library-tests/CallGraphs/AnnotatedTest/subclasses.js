import 'dummy';

class Base {
    workInBase() {
        /** calls:methodInBase */
        this.methodInBase();

        /** calls:NONE */
        this.methodInSub();

        /** calls:overridenInSub0 */
        this.overridenInSub();
    }

    /** name:methodInBase */
    methodInBase() {
        /** calls:NONE */
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
