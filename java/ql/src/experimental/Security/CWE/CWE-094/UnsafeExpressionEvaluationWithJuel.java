String expression = "${" + getRemoteUserInput() + "}";
ExpressionFactory factory = new de.odysseus.el.ExpressionFactoryImpl();
ValueExpression e = factory.createValueExpression(context, expression, Object.class);
SimpleContext context = getContext();
Object result = e.getValue(context);