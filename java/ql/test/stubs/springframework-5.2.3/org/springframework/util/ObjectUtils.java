package org.springframework.util;

import java.lang.reflect.Array;
import java.util.Arrays;
import java.util.Collection;
import java.util.Map;
import java.util.Optional;
import java.util.StringJoiner;
import org.springframework.lang.Nullable;

public abstract class ObjectUtils {

    private static final int INITIAL_HASH = 7;
    private static final int MULTIPLIER = 31;
    private static final String EMPTY_STRING = "";
    private static final String NULL_STRING = "null";
    private static final String ARRAY_START = "{";
    private static final String ARRAY_END = "}";
    private static final String EMPTY_ARRAY = "{}";
    private static final String ARRAY_ELEMENT_SEPARATOR = ", ";
    private static final Object[] EMPTY_OBJECT_ARRAY = new Object[0];

    public ObjectUtils() {
    }

    public static boolean isCheckedException(Throwable ex) {
        return false;
    }

    public static boolean isCompatibleWithThrowsClause(Throwable ex, @Nullable Class<?>... declaredExceptions) {
        return false;
    }

    public static boolean isArray(@Nullable Object obj) {
        return false;
    }

    public static boolean isEmpty(@Nullable Object[] array) {
        return false;
    }

    public static boolean isEmpty(@Nullable Object obj) {
        return false;
    }

    @Nullable
    public static Object unwrapOptional(@Nullable Object obj) {
        return null;
    }

    public static boolean containsElement(@Nullable Object[] array, Object element) {
        return true;
    }

    public static boolean containsConstant(Enum<?>[] enumValues, String constant) {
        return true;
    }

    public static boolean containsConstant(Enum<?>[] enumValues, String constant, boolean caseSensitive) {  
        return true;
    }

    public static <E extends Enum<?>> E caseInsensitiveValueOf(E[] enumValues, String constant) {
        return null;
    }

    public static <A, O extends A> A[] addObjectToArray(@Nullable A[] array, @Nullable O obj) {
        return null;
    }

    public static Object[] toObjectArray(@Nullable Object source) {
        return null;
    }

    public static boolean nullSafeEquals(@Nullable Object o1, @Nullable Object o2) {
        return false;
    }

    private static boolean arrayEquals(Object o1, Object o2) {
        return false;
    }

    public static int nullSafeHashCode(@Nullable Object obj) {
        return 1;
    }

    public static int nullSafeHashCode(@Nullable Object[] array) {
        return 1;
    }

    public static int nullSafeHashCode(@Nullable boolean[] array) {
        return 1;
    }

    public static int nullSafeHashCode(@Nullable byte[] array) {
        return 1;
    }

    public static int nullSafeHashCode(@Nullable char[] array) {
        return 1;
    }

    public static int nullSafeHashCode(@Nullable double[] array) {
        return 1;
    }

    public static int nullSafeHashCode(@Nullable float[] array) {
        return 1;
    }

    public static int nullSafeHashCode(@Nullable int[] array) {
        return 1;
    }

    public static int nullSafeHashCode(@Nullable long[] array) {
        return 1;
    }

    public static int nullSafeHashCode(@Nullable short[] array) {
        return 1;
    }

    /** @deprecated */
    @Deprecated
    public static int hashCode(boolean bool) {
        return 1;
    }

    /** @deprecated */
    @Deprecated
    public static int hashCode(double dbl) {
        return 1;
    }

    /** @deprecated */
    @Deprecated
    public static int hashCode(float flt) {
        return 1;
    }

    /** @deprecated */
    @Deprecated
    public static int hashCode(long lng) {
        return 1;
    }

    public static String identityToString(@Nullable Object obj) {
        return "";
    }

    public static String getIdentityHexString(Object obj) {
        return "";
    }

    public static String getDisplayString(@Nullable Object obj) {
        return "";
    }

    public static String nullSafeClassName(@Nullable Object obj) {
        return "";
    }

    public static String nullSafeToString(@Nullable Object obj) {
        return "";
    }

    public static String nullSafeToString(@Nullable Object[] array) {
        return "";
    }

    public static String nullSafeToString(@Nullable boolean[] array) {
        return "";
    }

    public static String nullSafeToString(@Nullable byte[] array) {
        return "";
    }

    public static String nullSafeToString(@Nullable char[] array) {
        return "";
    }

    public static String nullSafeToString(@Nullable double[] array) {
        return "";
    }

    public static String nullSafeToString(@Nullable float[] array) {
        return "";
    }

    public static String nullSafeToString(@Nullable int[] array) {
        return "";
    }

    public static String nullSafeToString(@Nullable long[] array) {
        return "";
    }

    public static String nullSafeToString(@Nullable short[] array) {
        return "";
    }
}
