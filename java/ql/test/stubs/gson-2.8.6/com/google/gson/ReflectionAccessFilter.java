// Generated automatically from com.google.gson.ReflectionAccessFilter for testing purposes

package com.google.gson;


public interface ReflectionAccessFilter
{
    ReflectionAccessFilter.FilterResult check(Class<? extends Object> p0);
    static ReflectionAccessFilter BLOCK_ALL_ANDROID = null;
    static ReflectionAccessFilter BLOCK_ALL_JAVA = null;
    static ReflectionAccessFilter BLOCK_ALL_PLATFORM = null;
    static ReflectionAccessFilter BLOCK_INACCESSIBLE_JAVA = null;
    static public enum FilterResult
    {
        ALLOW, BLOCK_ALL, BLOCK_INACCESSIBLE, INDECISIVE;
        private FilterResult() {}
    }
}
