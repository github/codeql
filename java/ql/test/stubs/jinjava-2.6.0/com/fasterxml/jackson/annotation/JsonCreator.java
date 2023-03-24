// Generated automatically from com.fasterxml.jackson.annotation.JsonCreator for testing purposes

package com.fasterxml.jackson.annotation;

import java.lang.annotation.Annotation;

public interface JsonCreator extends Annotation
{
    JsonCreator.Mode mode();
    static public enum Mode
    {
        DEFAULT, DELEGATING, DISABLED, PROPERTIES;
        private Mode() {}
    }
}
