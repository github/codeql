abstract class AbstractStack implements Cloneable {
    public AbstractStack clone() {
        try {
            return (AbstractStack) super.clone();
        } catch (CloneNotSupportedException e) {
            throw new AssertionError("Should not happen");
        }
    }
}

class WrongStack extends AbstractStack {
    private static final int MAX_STACK = 10;
    int[] elements = new int[MAX_STACK];
    int top = -1;

    void push(int newInt) {
        elements[++top] = newInt;
    }
    int pop() {
        return elements[top--];
    }
    // BAD: No 'clone' method to create a copy of the elements.
    // Therefore, the default 'clone' implementation (shallow copy) is used, which
    // is equivalent to:
    //
    //  public WrongStack clone() {
    //      WrongStack cloned = (WrongStack) super.clone();
    //      cloned.elements = elements;  // Both 'this' and 'cloned' now use the same elements.
    //      return cloned;
    //  }
}

public class MissingMethodClone {
    public static void main(String[] args) {
        WrongStack ws1 = new WrongStack();              // ws1: {}
        ws1.push(1);                                    // ws1: {1}
        ws1.push(2);                                    // ws1: {1,2}
        WrongStack ws1clone = (WrongStack) ws1.clone(); // ws1clone: {1,2}
        ws1clone.pop();                                 // ws1clone: {1}
        ws1clone.push(3);                               // ws1clone: {1,3}
        System.out.println(ws1.pop());                  // Because ws1 and ws1clone have the same
                                                        // elements, this prints 3 instead of 2
    }
}


