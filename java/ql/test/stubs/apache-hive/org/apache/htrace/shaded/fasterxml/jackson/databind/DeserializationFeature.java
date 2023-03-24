// Generated automatically from
// org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationFeature for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.ConfigFeature;

public enum DeserializationFeature implements ConfigFeature {
    ACCEPT_EMPTY_STRING_AS_NULL_OBJECT, ACCEPT_SINGLE_VALUE_AS_ARRAY, ADJUST_DATES_TO_CONTEXT_TIME_ZONE, EAGER_DESERIALIZER_FETCH, FAIL_ON_IGNORED_PROPERTIES, FAIL_ON_INVALID_SUBTYPE, FAIL_ON_NULL_FOR_PRIMITIVES, FAIL_ON_NUMBERS_FOR_ENUMS, FAIL_ON_READING_DUP_TREE_KEY, FAIL_ON_UNKNOWN_PROPERTIES, READ_DATE_TIMESTAMPS_AS_NANOSECONDS, READ_ENUMS_USING_TO_STRING, READ_UNKNOWN_ENUM_VALUES_AS_NULL, UNWRAP_ROOT_VALUE, UNWRAP_SINGLE_VALUE_ARRAYS, USE_BIG_DECIMAL_FOR_FLOATS, USE_BIG_INTEGER_FOR_INTS, USE_JAVA_ARRAY_FOR_JSON_ARRAY, WRAP_EXCEPTIONS;

    private DeserializationFeature() {}

    public boolean enabledByDefault() {
        return false;
    }

    public boolean enabledIn(int p0) {
        return false;
    }

    public int getMask() {
        return 0;
    }
}
