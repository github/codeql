package org.hamcrest.core;

public class IsNull {

    public static Object notNullValue() {
        return new String();
    }

    public static <T> Object notNullValue(Class<T> type) {
        return new String();
    }
}

