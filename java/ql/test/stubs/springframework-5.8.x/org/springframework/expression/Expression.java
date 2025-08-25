/*
 * Copyright 2002-2017 the original author or authors.
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

package org.springframework.expression;

import org.springframework.lang.Nullable;

public interface Expression {
	String getExpressionString();

	Object getValue() throws EvaluationException;

	<T> T getValue(@Nullable Class<T> desiredResultType) throws EvaluationException;

	Object getValue(@Nullable Object rootObject) throws EvaluationException;

	<T> T getValue(@Nullable Object rootObject, @Nullable Class<T> desiredResultType)
			throws EvaluationException;

	Object getValue(EvaluationContext context) throws EvaluationException;

	Object getValue(EvaluationContext context, @Nullable Object rootObject)
			throws EvaluationException;

	<T> T getValue(EvaluationContext context, @Nullable Class<T> desiredResultType)
			throws EvaluationException;

	<T> T getValue(EvaluationContext context, @Nullable Object rootObject,
			@Nullable Class<T> desiredResultType) throws EvaluationException;

	Class<?> getValueType() throws EvaluationException;

	Class<?> getValueType(@Nullable Object rootObject) throws EvaluationException;

	Class<?> getValueType(EvaluationContext context) throws EvaluationException;

	Class<?> getValueType(EvaluationContext context, @Nullable Object rootObject)
			throws EvaluationException;

	boolean isWritable(@Nullable Object rootObject) throws EvaluationException;

	boolean isWritable(EvaluationContext context) throws EvaluationException;

	boolean isWritable(EvaluationContext context, @Nullable Object rootObject)
			throws EvaluationException;

	void setValue(@Nullable Object rootObject, @Nullable Object value) throws EvaluationException;

	void setValue(EvaluationContext context, @Nullable Object value) throws EvaluationException;

	void setValue(EvaluationContext context, @Nullable Object rootObject, @Nullable Object value)
			throws EvaluationException;

}
