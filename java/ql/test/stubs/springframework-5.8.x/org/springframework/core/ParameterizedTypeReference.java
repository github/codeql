package org.springframework.core;

public abstract class ParameterizedTypeReference<T> {
    public java.lang.reflect.Type getType() {
        return null;
    }

    public boolean equals(java.lang.Object other) {
        return false;
    }

    public int hashCode() {
        return 0;
    }

    public java.lang.String toString() {
        return null;
    }

    public static <T> org.springframework.core.ParameterizedTypeReference<T> forType(java.lang.reflect.Type type) {
        return null;
    }

    private static java.lang.Class<?> findParameterizedTypeReferenceSubclass(java.lang.Class<?> child) {
        return null;
    }
}