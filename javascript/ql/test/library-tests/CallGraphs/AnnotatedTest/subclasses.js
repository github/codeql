import 'dummy';

class Base {
    workInBase() {
        /** calls:methodInBase */
        this.methodInBase();

        /** calls:NONE */
        this.methodInSub();
    }

    /** name:methodInBase */
    methodInBase() {
        /** calls:NONE */
        this.methodInSub();
    }
}

class Subclass1 extends Base {
    workInSub() {
        /** calls:methodInBase */
        this.methodInBase();
    }

    methodInSub() {
    }
}

class Subclass2 extends Base {
    workInSub() {
        /** calls:methodInBase */
        this.methodInBase();
    }

    methodInSub() {
    }
}
