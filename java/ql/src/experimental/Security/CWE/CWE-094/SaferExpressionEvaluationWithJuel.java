String input = getRemoteUserInput();
String pattern = "(inside|outside)\\.(temperature|humidity)";
if (!input.matches(pattern)) {
    throw new IllegalArgumentException("Unexpected expression");
}
String expression = "${" + input + "}";
ExpressionFactory factory = new de.odysseus.el.ExpressionFactoryImpl();
ValueExpression e = factory.createValueExpression(context, expression, Object.class);
SimpleContext context = getContext();
Object result = e.getValue(context);
