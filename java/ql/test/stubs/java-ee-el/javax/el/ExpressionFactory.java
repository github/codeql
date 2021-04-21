package javax.el;

public class ExpressionFactory {
    public MethodExpression createMethodExpression(ELContext context, String expression, Class<?> expectedReturnType,
            Class<?>[] expectedParamTypes) {

        return null;
    }

    public ValueExpression createValueExpression(ELContext context, String expression, Class<?> expectedType) {
        return null;
    }

    public ValueExpression createValueExpression(Object instance, Class<?> expectedType) {
        return null;
    }
}
