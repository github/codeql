// Generated automatically from com.fasterxml.jackson.annotation.JsonFormat for testing purposes

package com.fasterxml.jackson.annotation;

import com.fasterxml.jackson.annotation.JacksonAnnotationValue;
import java.io.Serializable;
import java.lang.annotation.Annotation;
import java.util.Locale;
import java.util.TimeZone;

public interface JsonFormat extends Annotation
{
    JsonFormat.Feature[] with();
    JsonFormat.Feature[] without();
    JsonFormat.Shape shape();
    String locale();
    String pattern();
    String timezone();
    static String DEFAULT_LOCALE = null;
    static String DEFAULT_TIMEZONE = null;
    static public class Features
    {
        protected Features() {}
        public Boolean get(JsonFormat.Feature p0){ return null; }
        public JsonFormat.Features with(JsonFormat.Feature... p0){ return null; }
        public JsonFormat.Features withOverrides(JsonFormat.Features p0){ return null; }
        public JsonFormat.Features without(JsonFormat.Feature... p0){ return null; }
        public boolean equals(Object p0){ return false; }
        public int hashCode(){ return 0; }
        public static JsonFormat.Features construct(JsonFormat p0){ return null; }
        public static JsonFormat.Features construct(JsonFormat.Feature[] p0, JsonFormat.Feature[] p1){ return null; }
        public static JsonFormat.Features empty(){ return null; }
    }
    static public class Value implements JacksonAnnotationValue<JsonFormat>, Serializable
    {
        public Boolean getFeature(JsonFormat.Feature p0){ return null; }
        public Class<JsonFormat> valueFor(){ return null; }
        public JsonFormat.Shape getShape(){ return null; }
        public JsonFormat.Value withFeature(JsonFormat.Feature p0){ return null; }
        public JsonFormat.Value withLocale(Locale p0){ return null; }
        public JsonFormat.Value withPattern(String p0){ return null; }
        public JsonFormat.Value withShape(JsonFormat.Shape p0){ return null; }
        public JsonFormat.Value withTimeZone(TimeZone p0){ return null; }
        public JsonFormat.Value withoutFeature(JsonFormat.Feature p0){ return null; }
        public Locale getLocale(){ return null; }
        public String getPattern(){ return null; }
        public String timeZoneAsString(){ return null; }
        public String toString(){ return null; }
        public TimeZone getTimeZone(){ return null; }
        public Value(){}
        public Value(JsonFormat p0){}
        public Value(String p0, JsonFormat.Shape p1, Locale p2, String p3, TimeZone p4){}
        public Value(String p0, JsonFormat.Shape p1, Locale p2, String p3, TimeZone p4, JsonFormat.Features p5){}
        public Value(String p0, JsonFormat.Shape p1, Locale p2, TimeZone p3){}
        public Value(String p0, JsonFormat.Shape p1, Locale p2, TimeZone p3, JsonFormat.Features p4){}
        public Value(String p0, JsonFormat.Shape p1, String p2, String p3){}
        public Value(String p0, JsonFormat.Shape p1, String p2, String p3, JsonFormat.Features p4){}
        public boolean equals(Object p0){ return false; }
        public boolean hasLocale(){ return false; }
        public boolean hasPattern(){ return false; }
        public boolean hasShape(){ return false; }
        public boolean hasTimeZone(){ return false; }
        public final JsonFormat.Value withOverrides(JsonFormat.Value p0){ return null; }
        public int hashCode(){ return 0; }
        public static JsonFormat.Value empty(){ return null; }
        public static JsonFormat.Value forPattern(String p0){ return null; }
        public static JsonFormat.Value forShape(JsonFormat.Shape p0){ return null; }
        public static JsonFormat.Value from(JsonFormat p0){ return null; }
    }
    static public enum Feature
    {
        ACCEPT_SINGLE_VALUE_AS_ARRAY, WRITE_DATES_WITH_ZONE_ID, WRITE_DATE_TIMESTAMPS_AS_NANOSECONDS, WRITE_SINGLE_ELEM_ARRAYS_UNWRAPPED, WRITE_SORTED_MAP_ENTRIES;
        private Feature() {}
    }
    static public enum Shape
    {
        ANY, ARRAY, BOOLEAN, NUMBER, NUMBER_FLOAT, NUMBER_INT, OBJECT, SCALAR, STRING;
        private Shape() {}
        public boolean isNumeric(){ return false; }
        public boolean isStructured(){ return false; }
    }
}
