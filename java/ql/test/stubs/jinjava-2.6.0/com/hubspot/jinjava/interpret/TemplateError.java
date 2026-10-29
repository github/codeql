// Generated automatically from com.hubspot.jinjava.interpret.TemplateError for testing purposes

package com.hubspot.jinjava.interpret;

import com.hubspot.jinjava.interpret.InterpretException;
import com.hubspot.jinjava.interpret.InvalidArgumentException;
import com.hubspot.jinjava.interpret.InvalidInputException;
import com.hubspot.jinjava.interpret.TemplateSyntaxException;
import com.hubspot.jinjava.interpret.errorcategory.TemplateErrorCategory;
import java.util.Map;
import java.util.Optional;

public class TemplateError
{
    protected TemplateError() {}
    public Exception getException(){ return null; }
    public Map<String, String> getCategoryErrors(){ return null; }
    public Optional<String> getSourceTemplate(){ return null; }
    public String getFieldName(){ return null; }
    public String getMessage(){ return null; }
    public String toString(){ return null; }
    public TemplateError serializable(){ return null; }
    public TemplateError withScopeDepth(int p0){ return null; }
    public TemplateError(TemplateError.ErrorType p0, TemplateError.ErrorReason p1, String p2, String p3, int p4, int p5, Exception p6){}
    public TemplateError(TemplateError.ErrorType p0, TemplateError.ErrorReason p1, TemplateError.ErrorItem p2, String p3, String p4, int p5, Exception p6){}
    public TemplateError(TemplateError.ErrorType p0, TemplateError.ErrorReason p1, TemplateError.ErrorItem p2, String p3, String p4, int p5, Exception p6, TemplateErrorCategory p7, Map<String, String> p8){}
    public TemplateError(TemplateError.ErrorType p0, TemplateError.ErrorReason p1, TemplateError.ErrorItem p2, String p3, String p4, int p5, int p6, Exception p7){}
    public TemplateError(TemplateError.ErrorType p0, TemplateError.ErrorReason p1, TemplateError.ErrorItem p2, String p3, String p4, int p5, int p6, Exception p7, TemplateErrorCategory p8, Map<String, String> p9){}
    public TemplateError(TemplateError.ErrorType p0, TemplateError.ErrorReason p1, TemplateError.ErrorItem p2, String p3, String p4, int p5, int p6, Exception p7, TemplateErrorCategory p8, Map<String, String> p9, int p10){}
    public TemplateError.ErrorItem getItem(){ return null; }
    public TemplateError.ErrorReason getReason(){ return null; }
    public TemplateError.ErrorType getSeverity(){ return null; }
    public TemplateErrorCategory getCategory(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int getLineno(){ return 0; }
    public int getScopeDepth(){ return 0; }
    public int getStartPosition(){ return 0; }
    public int hashCode(){ return 0; }
    public static TemplateError fromException(Exception p0){ return null; }
    public static TemplateError fromException(Exception p0, int p1){ return null; }
    public static TemplateError fromException(Exception p0, int p1, int p2){ return null; }
    public static TemplateError fromException(TemplateSyntaxException p0){ return null; }
    public static TemplateError fromInvalidArgumentException(InvalidArgumentException p0){ return null; }
    public static TemplateError fromInvalidInputException(InvalidInputException p0){ return null; }
    public static TemplateError fromOutputTooBigException(Exception p0){ return null; }
    public static TemplateError fromSyntaxError(InterpretException p0){ return null; }
    public static TemplateError fromUnknownProperty(Object p0, String p1, int p2){ return null; }
    public static TemplateError fromUnknownProperty(Object p0, String p1, int p2, int p3){ return null; }
    public void setLineno(int p0){}
    public void setMessage(String p0){}
    public void setSourceTemplate(String p0){}
    public void setStartPosition(int p0){}
    static public enum ErrorItem
    {
        EXPRESSION_TEST, FILTER, FUNCTION, OTHER, PROPERTY, TAG, TEMPLATE, TOKEN;
        private ErrorItem() {}
    }
    static public enum ErrorReason
    {
        BAD_URL, COLLECTION_TOO_BIG, DISABLED, EXCEPTION, INVALID_ARGUMENT, INVALID_INPUT, MISSING, OTHER, OUTPUT_TOO_BIG, OVER_LIMIT, SYNTAX_ERROR, UNKNOWN;
        private ErrorReason() {}
    }
    static public enum ErrorType
    {
        FATAL, WARNING;
        private ErrorType() {}
    }
}
