package org.springframework.expression;

public interface Expression {

	Object getValue() throws EvaluationException;

	Object getValue(EvaluationContext context) throws EvaluationException;

	Class<?> getValueType() throws EvaluationException;

	Class<?> getValueType(EvaluationContext context) throws EvaluationException;

	void setValue(Object rootObject, Object value) throws EvaluationException;
}