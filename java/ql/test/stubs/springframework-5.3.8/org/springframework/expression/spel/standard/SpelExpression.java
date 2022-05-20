/*
 * Copyright 2002-2020 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package org.springframework.expression.spel.standard;

import org.springframework.expression.EvaluationContext;
import org.springframework.expression.EvaluationException;
import org.springframework.expression.Expression;
import org.springframework.lang.Nullable;

public class SpelExpression implements Expression {
	public void setEvaluationContext(EvaluationContext evaluationContext) {}

	public EvaluationContext getEvaluationContext() {
		return null;
	}

	@Override
	public String getExpressionString() {
		return null;
	}

	@Override
	public Object getValue() throws EvaluationException {
		return null;
	}

	@Override
	public <T> T getValue(@Nullable Class<T> expectedResultType) throws EvaluationException {
		return null;
	}

	@Override
	public Object getValue(@Nullable Object rootObject) throws EvaluationException {
		return null;
	}

	@Override
	public <T> T getValue(@Nullable Object rootObject, @Nullable Class<T> expectedResultType)
			throws EvaluationException {
		return null;
	}

	@Override
	public Object getValue(EvaluationContext context) throws EvaluationException {
		return null;
	}

	@Override
	public <T> T getValue(EvaluationContext context, @Nullable Class<T> expectedResultType)
			throws EvaluationException {
		return null;
	}

	@Override
	public Object getValue(EvaluationContext context, @Nullable Object rootObject)
			throws EvaluationException {
		return null;
	}

	@Override
	public <T> T getValue(EvaluationContext context, @Nullable Object rootObject,
			@Nullable Class<T> expectedResultType) throws EvaluationException {
		return null;
	}

	@Override
	public Class<?> getValueType() throws EvaluationException {
		return null;
	}

	@Override
	public Class<?> getValueType(@Nullable Object rootObject) throws EvaluationException {
		return null;
	}

	@Override
	public Class<?> getValueType(EvaluationContext context) throws EvaluationException {
		return null;
	}

	@Override
	public Class<?> getValueType(EvaluationContext context, @Nullable Object rootObject)
			throws EvaluationException {
		return null;
	}

	@Override
	public boolean isWritable(@Nullable Object rootObject) throws EvaluationException {
		return false;
	}

	@Override
	public boolean isWritable(EvaluationContext context) throws EvaluationException {
		return false;
	}

	@Override
	public boolean isWritable(EvaluationContext context, @Nullable Object rootObject)
			throws EvaluationException {
		return false;
	}

	@Override
	public void setValue(@Nullable Object rootObject, @Nullable Object value)
			throws EvaluationException {}

	@Override
	public void setValue(EvaluationContext context, @Nullable Object value)
			throws EvaluationException {}

	@Override
	public void setValue(EvaluationContext context, @Nullable Object rootObject,
			@Nullable Object value) throws EvaluationException {}

	public boolean compileExpression() {
		return false;
	}

	public void revertToInterpreted() {}

	public String toStringAST() {
		return null;
	}

}
