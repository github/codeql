public class B {

    // Use this method to mark non-integer bounds
    // that should also be annotated.
    static void bound(int b) { }

    public int forloop() {
        int result = 0;
        for (int i = 0;
            i < 10; // $ bound="i in [0..10]"
            i++) { // $ bound="i in [0..9]"
            result = i; // $ bound="i in [0..9]"
        }
        return result; // $ bound="result in [0..9]"
    }

    public int forloopexit() {
        int result = 0;
        for (; result < 10;) { // $ bound="result in [0..10]"
            result += 1; // $ bound="result in [0..9]"
        }
        return result; // $ bound="result = 10"
    }

    public int forloopexitstep() {
        int result = 0;
        for (; result < 10;) { // $ bound="result in [0..12]"
            result += 3; // $ bound="result in [0..9]"
        }
        return result; // $ bound="result = 12"
    }

    public int forloopexitupd() {
        int result = 0;
        for (; result < 10; // $ bound="result in [0..10]"
            result++) { // $ bound="result in [0..9]"
        }
        return result; // $ bound="result = 10"
    }

    public int forloopexitnested() {
        int result = 0;
        for (; result < 10;) {
            int i = 0;
            for (; i < 3;) { // $ bound="i in [0..3]"
                i += 1; // $ bound="i in [0..2]"
            }
            result += i; // $ bound="result in [0..9]" bound="i = 3"
        }
        return result; // $ MISSING:bound="result = 12"
    }

    public int emptyforloop() {
        int result = 0;
        for (int i = 0; i < 0; // $ bound="i = 0"
            i++) { // $ bound="i in [0..-1]"
            result = i; // $ bound="i in [0..-1]"
        }
        return result; // $ bound="result = 0"
    }

    public int noloop() {
        int result = 0;
        result += 1; // $ bound="result = 0"
        return result; // $ bound="result = 1"
    }

    public int foreachloop() {
        int result = 0;
        for (int i : new int[] {1, 2, 3, 4, 5}) {
            result = i;
        }
        return result;
    }

    public int emptyforeachloop() {
        int result = 0;
        for (int i : new int[] {}) {
            result = i;
        }
        return result;
    }

    public int whileloop() {
        int result = 100;
        while (result > 5) { // $ bound="result in [4..100]"
            result = result - 2; // $ bound="result in [6..100]"
        }
        return result; // $ bound="result = 4"
    }

    public int oddwhileloop() {
        int result = 101;
        while (result > 5) { // $ bound="result in [5..101]"
            result = result - 2; // $ bound="result in [7..101]"
        }
        return result; // $ bound="result = 5"
    }

    static void arraylength(int[] arr) {
        bound(arr.length);
        for (int i = 0;
            i < arr.length;
            i++) { // $ bound="i <= arr.length - 1"
            arr[i]++; // $ bound="i <= arr.length - 1"
        }
    }

    static int varbound(int b) {
        bound(b);
        int result = 0;
        for (int i = 0;
            i < b;
            i++) { // $ bound="i <= b - 1"
            result = i; // $ bound="i <= b - 1"
        }
        return result; // $ MISSING: bound="result <= b - 1"
    }

}