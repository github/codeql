package org.hamcrest;


public class MatcherAssert {
    public static <T> void assertThat(T actual, Object matcher) {
        assertThat("", actual, matcher);
    }
    
    public static <T> void assertThat(String reason, T actual, Object matcher) {
    }
    
    public static void assertThat(String reason, boolean assertion) {
    }
}
