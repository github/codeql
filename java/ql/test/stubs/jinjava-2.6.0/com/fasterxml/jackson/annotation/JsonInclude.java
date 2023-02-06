// Generated automatically from com.fasterxml.jackson.annotation.JsonInclude for testing purposes

package com.fasterxml.jackson.annotation;

import com.fasterxml.jackson.annotation.JacksonAnnotationValue;
import java.io.Serializable;
import java.lang.annotation.Annotation;

public interface JsonInclude extends Annotation
{
    JsonInclude.Include content();
    JsonInclude.Include value();
    static public class Value implements JacksonAnnotationValue<JsonInclude>, Serializable
    {
        protected Value() {}
        protected Object readResolve(){ return null; }
        protected Value(JsonInclude.Include p0, JsonInclude.Include p1){}
        protected final JsonInclude.Include _contentInclusion = null;
        protected final JsonInclude.Include _valueInclusion = null;
        protected static JsonInclude.Value EMPTY = null;
        public Class<JsonInclude> valueFor(){ return null; }
        public JsonInclude.Include getContentInclusion(){ return null; }
        public JsonInclude.Include getValueInclusion(){ return null; }
        public JsonInclude.Value withContentInclusion(JsonInclude.Include p0){ return null; }
        public JsonInclude.Value withOverrides(JsonInclude.Value p0){ return null; }
        public JsonInclude.Value withValueInclusion(JsonInclude.Include p0){ return null; }
        public String toString(){ return null; }
        public Value(JsonInclude p0){}
        public boolean equals(Object p0){ return false; }
        public int hashCode(){ return 0; }
        public static JsonInclude.Value construct(JsonInclude.Include p0, JsonInclude.Include p1){ return null; }
        public static JsonInclude.Value empty(){ return null; }
        public static JsonInclude.Value from(JsonInclude p0){ return null; }
    }
    static public enum Include
    {
        ALWAYS, NON_ABSENT, NON_DEFAULT, NON_EMPTY, NON_NULL, USE_DEFAULTS;
        private Include() {}
    }
}
