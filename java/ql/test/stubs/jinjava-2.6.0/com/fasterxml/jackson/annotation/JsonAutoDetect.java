// Generated automatically from com.fasterxml.jackson.annotation.JsonAutoDetect for testing purposes

package com.fasterxml.jackson.annotation;

import java.lang.annotation.Annotation;
import java.lang.reflect.Member;

public interface JsonAutoDetect extends Annotation
{
    JsonAutoDetect.Visibility creatorVisibility();
    JsonAutoDetect.Visibility fieldVisibility();
    JsonAutoDetect.Visibility getterVisibility();
    JsonAutoDetect.Visibility isGetterVisibility();
    JsonAutoDetect.Visibility setterVisibility();
    static public enum Visibility
    {
        ANY, DEFAULT, NONE, NON_PRIVATE, PROTECTED_AND_PUBLIC, PUBLIC_ONLY;
        private Visibility() {}
        public boolean isVisible(Member p0){ return false; }
    }
}
