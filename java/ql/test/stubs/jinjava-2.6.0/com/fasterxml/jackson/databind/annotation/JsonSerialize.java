// Generated automatically from com.fasterxml.jackson.databind.annotation.JsonSerialize for testing purposes

package com.fasterxml.jackson.databind.annotation;

import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.util.Converter;
import java.lang.annotation.Annotation;

public interface JsonSerialize extends Annotation
{
    Class<? extends Converter> contentConverter();
    Class<? extends Converter> converter();
    Class<? extends JsonSerializer> contentUsing();
    Class<? extends JsonSerializer> keyUsing();
    Class<? extends JsonSerializer> nullsUsing();
    Class<? extends JsonSerializer> using();
    Class<? extends Object> as();
    Class<? extends Object> contentAs();
    Class<? extends Object> keyAs();
    JsonSerialize.Inclusion include();
    JsonSerialize.Typing typing();
    static public enum Inclusion
    {
        ALWAYS, DEFAULT_INCLUSION, NON_DEFAULT, NON_EMPTY, NON_NULL;
        private Inclusion() {}
    }
    static public enum Typing
    {
        DEFAULT_TYPING, DYNAMIC, STATIC;
        private Typing() {}
    }
}
