abstract class AbstractStack implements Cloneable {
    public AbstractStack clone() {
        try {
            return (AbstractStack) super.clone();
        } catch (CloneNotSupportedException e) {
            throw new AssertionError("Should not happen");
        }
    }
}

class RightStack extends AbstractStack {
    private static final int MAX_STACK = 10;
    int[] elements = new int[MAX_STACK];
    int top = -1;

    void push(int newInt) {
        elements[++top] = newInt;
    }
    int pop() {
        return elements[top--];
    }

    // GOOD: 'clone' method to create a copy of the elements.
    public RightStack clone() {
        RightStack cloned = (RightStack) super.clone();
        cloned.elements = elements.clone();  // 'cloned' has its own elements.
        return cloned;
    }
}

public class MissingMethodClone {
    public static void main(String[] args) {
        RightStack rs1 = new RightStack();              // rs1: {}
        rs1.push(1);                                    // rs1: {1}
        rs1.push(2);                                    // rs1: {1,2}
        RightStack rs1clone = rs1.clone();              // rs1clone: {1,2}
        rs1clone.pop();                                 // rs1clone: {1}
        rs1clone.push(3);                               // rs1clone: {1,3}
        System.out.println(rs1.pop());                  // Correctly prints 2
    }
}


