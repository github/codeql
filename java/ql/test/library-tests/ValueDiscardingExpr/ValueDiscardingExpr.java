package StmtExpr;

import java.util.function.IntConsumer;
import java.util.function.IntFunction;
import java.util.function.Supplier;

class StmtExpr {
    void test() {
        toString();

        // Method call with `void` return type is not a ValueDiscardingExpr
        System.out.println("test");

        // LocalVariableDeclarationStatement with init is not a ValueDiscardingExpr
        String s = toString();

        int i;
        i = 0;
        i++;
        ++i;
        i--;
        --i;

        new Object();
        // Language specification does not permit ArrayCreationExpression at locations where its
        // value would be discard, but the value of a method access on it can be discarded
        new int[] {}.clone();

        // for statement init can discard value
        for (System.out.append("init");;) {
            break;
        }

        // for statement update discards value
        for (;; System.out.append("update")) {
            break;
        }

        // Method call with `void` return type is not a ValueDiscardingExpr
        for (;; System.out.println("update")) {
            break;
        }

        // variable declaration and condition are not ValueDiscardingExpr
        for (int i1 = 0; i1 < 10;) { }
        for (int i1, i2 = 0; i2 < 10;) { }
        for (;;) {
            break;
        }

        // Not a ValueDiscardingExpr
        for (int i2 : new int[] {1}) { }

        switch(1) {
            default -> toString(); // ValueDiscardingExpr
        }

        switch(1) {
            // Method call with `void` return type is not a ValueDiscardingExpr
            default -> System.out.println();
        }

        String s2 = switch(1) {
            // Expression in SwitchExpression case rule is not a ValueDiscardingExpr
            default -> toString();
        };

        // Expression in lambda with non-void return type is not a ValueDiscardingExpr
        Supplier<Object> supplier1 = () -> toString();
        Supplier<Object> supplier2 = () -> {
            return toString();
        };
        // Expression in lambda with void return type is ValueDiscardingExpr
        Runnable r1 = () -> toString();
        Runnable r2 = () -> {
            toString();
        };
        // Lambda with method call with `void` return type is not a ValueDiscardingExpr
        Runnable r3 = () -> System.out.println();
        Runnable r4 = () -> {
            System.out.println();
        };

        // Method reference with non-void return type has no ValueDiscardingExpr
        Supplier<Object> supplier3 = StmtExpr::new;
        IntFunction<Object> f = String[]::new;
        Supplier<Object> supplier4 = this::toString;

        // Method reference with void return type has ValueDiscardingExpr in implicit method body
        Runnable r5 = StmtExpr::new;
        Runnable r6 = this::toString;
        // Interestingly a method reference expression with function type (int)->void allows usage of
        // array creation expressions, even though a regular StatementExpression would not allow it,
        // for example the ExpressionStatement `new String[1];` is not allowed by the JLS
        IntConsumer c = String[]::new;

        // Method reference referring to method with `void` return type is not a ValueDiscardingExpr
        Runnable r7 = System.out::println;
    }
}
