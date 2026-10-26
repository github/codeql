// Generated automatically from com.fasterxml.jackson.core.filter.TokenFilter for testing purposes

package com.fasterxml.jackson.core.filter;

import com.fasterxml.jackson.core.JsonParser;
import java.math.BigDecimal;
import java.math.BigInteger;

public class TokenFilter
{
    protected TokenFilter(){}
    protected boolean _includeScalar(){ return false; }
    public String toString(){ return null; }
    public TokenFilter filterStartArray(){ return null; }
    public TokenFilter filterStartObject(){ return null; }
    public TokenFilter includeElement(int p0){ return null; }
    public TokenFilter includeProperty(String p0){ return null; }
    public TokenFilter includeRootValue(int p0){ return null; }
    public boolean includeBinary(){ return false; }
    public boolean includeBoolean(boolean p0){ return false; }
    public boolean includeEmbeddedValue(Object p0){ return false; }
    public boolean includeNull(){ return false; }
    public boolean includeNumber(BigDecimal p0){ return false; }
    public boolean includeNumber(BigInteger p0){ return false; }
    public boolean includeNumber(double p0){ return false; }
    public boolean includeNumber(float p0){ return false; }
    public boolean includeNumber(int p0){ return false; }
    public boolean includeNumber(long p0){ return false; }
    public boolean includeRawValue(){ return false; }
    public boolean includeString(String p0){ return false; }
    public boolean includeValue(JsonParser p0){ return false; }
    public static TokenFilter INCLUDE_ALL = null;
    public void filterFinishArray(){}
    public void filterFinishObject(){}
}
