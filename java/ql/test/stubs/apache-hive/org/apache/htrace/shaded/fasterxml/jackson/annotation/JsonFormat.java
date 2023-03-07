// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonFormat for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.annotation;

import java.lang.annotation.Annotation;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.util.Locale;
import java.util.TimeZone;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JacksonAnnotation;

@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.ANNOTATION_TYPE,java.lang.annotation.ElementType.FIELD,java.lang.annotation.ElementType.METHOD,java.lang.annotation.ElementType.PARAMETER,java.lang.annotation.ElementType.TYPE})
@JacksonAnnotation
public @interface JsonFormat
{
    JsonFormat.Shape shape();
    String locale();
    String pattern();
    String timezone();
    static String DEFAULT_LOCALE = null;
    static String DEFAULT_TIMEZONE = null;
    static public class Value
    {
        public JsonFormat.Shape getShape(){ return null; }
        public JsonFormat.Value withLocale(Locale p0){ return null; }
        public JsonFormat.Value withPattern(String p0){ return null; }
        public JsonFormat.Value withShape(JsonFormat.Shape p0){ return null; }
        public JsonFormat.Value withTimeZone(TimeZone p0){ return null; }
        public Locale getLocale(){ return null; }
        public String getPattern(){ return null; }
        public String timeZoneAsString(){ return null; }
        public TimeZone getTimeZone(){ return null; }
        public Value(){}
        public Value(JsonFormat p0){}
        public Value(String p0, JsonFormat.Shape p1, Locale p2, String p3, TimeZone p4){}
        public Value(String p0, JsonFormat.Shape p1, Locale p2, TimeZone p3){}
        public Value(String p0, JsonFormat.Shape p1, String p2, String p3){}
        public boolean hasLocale(){ return false; }
        public boolean hasPattern(){ return false; }
        public boolean hasShape(){ return false; }
        public boolean hasTimeZone(){ return false; }
    }
    static public enum Shape
    {
        ANY, ARRAY, BOOLEAN, NUMBER, NUMBER_FLOAT, NUMBER_INT, OBJECT, SCALAR, STRING;
        private Shape() {}
        public boolean isNumeric(){ return false; }
        public boolean isStructured(){ return false; }
    }
}
