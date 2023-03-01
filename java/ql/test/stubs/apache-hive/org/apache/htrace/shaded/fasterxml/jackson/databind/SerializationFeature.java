// Generated automatically from com.fasterxml.jackson.databind.SerializationFeature for testing
// purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.ConfigFeature;

public enum SerializationFeature implements ConfigFeature {
    CLOSE_CLOSEABLE, EAGER_SERIALIZER_FETCH, FAIL_ON_EMPTY_BEANS, FAIL_ON_SELF_REFERENCES, FAIL_ON_UNWRAPPED_TYPE_IDENTIFIERS, FLUSH_AFTER_WRITE_VALUE, INDENT_OUTPUT, ORDER_MAP_ENTRIES_BY_KEYS, USE_EQUALITY_FOR_OBJECT_ID, WRAP_EXCEPTIONS, WRAP_ROOT_VALUE, WRITE_BIGDECIMAL_AS_PLAIN, WRITE_CHAR_ARRAYS_AS_JSON_ARRAYS, WRITE_DATES_AS_TIMESTAMPS, WRITE_DATES_WITH_ZONE_ID, WRITE_DATE_KEYS_AS_TIMESTAMPS, WRITE_DATE_TIMESTAMPS_AS_NANOSECONDS, WRITE_DURATIONS_AS_TIMESTAMPS, WRITE_EMPTY_JSON_ARRAYS, WRITE_ENUMS_USING_INDEX, WRITE_ENUMS_USING_TO_STRING, WRITE_NULL_MAP_VALUES, WRITE_SINGLE_ELEM_ARRAYS_UNWRAPPED;

    private SerializationFeature() {}

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
