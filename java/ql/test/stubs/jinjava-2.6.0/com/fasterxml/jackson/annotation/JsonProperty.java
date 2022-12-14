// Generated automatically from com.fasterxml.jackson.annotation.JsonProperty for testing purposes

package com.fasterxml.jackson.annotation;

import java.lang.annotation.Annotation;

public interface JsonProperty extends Annotation
{
    JsonProperty.Access access();
    String defaultValue();
    String value();
    boolean required();
    int index();
    static String USE_DEFAULT_NAME = null;
    static int INDEX_UNKNOWN = 0;
    static public enum Access
    {
        AUTO, READ_ONLY, READ_WRITE, WRITE_ONLY;
        private Access() {}
    }
}
