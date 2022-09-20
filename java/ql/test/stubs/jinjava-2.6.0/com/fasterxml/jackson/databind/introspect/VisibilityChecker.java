// Generated automatically from com.fasterxml.jackson.databind.introspect.VisibilityChecker for testing purposes

package com.fasterxml.jackson.databind.introspect;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.introspect.AnnotatedField;
import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import java.lang.reflect.Field;
import java.lang.reflect.Member;
import java.lang.reflect.Method;

public interface VisibilityChecker<T extends VisibilityChecker<T>>
{
    T with(JsonAutoDetect p0);
    T with(JsonAutoDetect.Visibility p0);
    T withCreatorVisibility(JsonAutoDetect.Visibility p0);
    T withFieldVisibility(JsonAutoDetect.Visibility p0);
    T withGetterVisibility(JsonAutoDetect.Visibility p0);
    T withIsGetterVisibility(JsonAutoDetect.Visibility p0);
    T withSetterVisibility(JsonAutoDetect.Visibility p0);
    T withVisibility(PropertyAccessor p0, JsonAutoDetect.Visibility p1);
    boolean isCreatorVisible(AnnotatedMember p0);
    boolean isCreatorVisible(Member p0);
    boolean isFieldVisible(AnnotatedField p0);
    boolean isFieldVisible(Field p0);
    boolean isGetterVisible(AnnotatedMethod p0);
    boolean isGetterVisible(Method p0);
    boolean isIsGetterVisible(AnnotatedMethod p0);
    boolean isIsGetterVisible(Method p0);
    boolean isSetterVisible(AnnotatedMethod p0);
    boolean isSetterVisible(Method p0);
}
