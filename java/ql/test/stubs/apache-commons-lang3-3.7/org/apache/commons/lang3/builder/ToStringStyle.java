/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.commons.lang3.builder;

import java.io.Serializable;

public abstract class ToStringStyle implements Serializable {
    public static final ToStringStyle DEFAULT_STYLE = null;

    public static final ToStringStyle MULTI_LINE_STYLE = null;

    public static final ToStringStyle NO_FIELD_NAMES_STYLE = null;

    public static final ToStringStyle SHORT_PREFIX_STYLE = null;

    public static final ToStringStyle SIMPLE_STYLE = null;

    public static final ToStringStyle NO_CLASS_NAME_STYLE = null;

    public static final ToStringStyle JSON_STYLE = null;

    public void appendSuper(final StringBuffer buffer, final String superToString) {
    }

    public void appendToString(final StringBuffer buffer, final String toString) {
    }

    public void appendStart(final StringBuffer buffer, final Object object) {
    }

    public void appendEnd(final StringBuffer buffer, final Object object) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final Object value, final Boolean fullDetail) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final long value) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final int value) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final short value) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final byte value) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final char value) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final double value) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final float value) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final boolean value) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final Object[] array, final Boolean fullDetail) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final long[] array, final Boolean fullDetail) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final int[] array, final Boolean fullDetail) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final short[] array, final Boolean fullDetail) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final byte[] array, final Boolean fullDetail) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final char[] array, final Boolean fullDetail) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final double[] array, final Boolean fullDetail) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final float[] array, final Boolean fullDetail) {
    }

    public void append(final StringBuffer buffer, final String fieldName, final boolean[] array, final Boolean fullDetail) {
    }

}
