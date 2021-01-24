package org.apache.commons.lang3;

public class StringUtils {
    public static boolean isEmpty(final CharSequence cs) {
        return cs == null || cs.length() == 0;
    }
}
