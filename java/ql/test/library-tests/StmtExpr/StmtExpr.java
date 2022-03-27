package StmtExpr;

import java.util.function.Supplier;

class StmtExpr {
    void test() {
        toString();

        // LocalVariableDeclarationStatement with init is not a StatementExpression
        String s = toString();

        int i;
        i = 0;
        i++;
        ++i;
        i--;
        --i;

        new Object();
        // ArrayCreationExpression cannot be a StatementExpression, but a method access
        // on it can be
        new int[] {}.clone();

        // for statement init can be StatementExpression
        for (System.out.println("init");;) {
            break;
        }

        // for statement update is StatementExpression
        for (;; System.out.println("update")) {
            break;
        }

        // variable declaration and condition are not StatementExpressions
        for (int i1 = 0; i1 < 10;) { }
        for (int i1, i2 = 0; i2 < 10;) { }
        for (;;) {
            break;
        }

        // Not a StatementExpression
        for (int i2 : new int[] {1}) { }

        switch(1) {
            default -> toString(); // StatementExpression
        }
        // SwitchExpression has no StatementExpression
        String s2 = switch(1) {
            default -> toString();
        };

        // Lambda with non-void return type has no StatementExpression
        Supplier<Object> supplier1 = () -> toString();
        Supplier<Object> supplier2 = () -> {
            return toString();
        };
        // Lambda with void return type has StatementExpression
        Runnable r = () -> toString();
        Runnable r2 = () -> {
            toString();
        };

        // Method reference with non-void return type has no StatementExpression
        Supplier<Object> supplier3 = StmtExpr::new;
        // Method reference with void return type has StatementExpression in implicit method body
        Runnable r3 = this::toString;
    }
}
