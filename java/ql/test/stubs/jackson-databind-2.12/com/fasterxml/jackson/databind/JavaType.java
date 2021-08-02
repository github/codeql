package com.fasterxml.jackson.databind;

import java.util.List;
import com.fasterxml.jackson.core.type.ResolvedType;

public abstract class JavaType extends ResolvedType implements java.io.Serializable, // 2.1
    java.lang.reflect.Type // 2.2
{
  public abstract JavaType withTypeHandler(Object h);

  public abstract JavaType withContentTypeHandler(Object h);

  public abstract JavaType withValueHandler(Object h);

  public abstract JavaType withContentValueHandler(Object h);

  public JavaType withHandlersFrom(JavaType src) {
    return null;
  }

  public abstract JavaType withContentType(JavaType contentType);

  public abstract JavaType withStaticTyping();

  public JavaType forcedNarrowBy(Class<?> subclass) {
    return null;
  }

  @Override
  public final Class<?> getRawClass() {
    return null;
  }

  @Override
  public final boolean hasRawClass(Class<?> clz) {
    return false;
  }

  public boolean hasContentType() {
    return false;
  }

  public final boolean isTypeOrSubTypeOf(Class<?> clz) {
    return false;
  }

  public final boolean isTypeOrSuperTypeOf(Class<?> clz) {
    return false;
  }

  @Override
  public boolean isAbstract() {
    return false;
  }

  @Override
  public boolean isConcrete() {
    return false;
  }

  @Override
  public boolean isThrowable() {
    return false;
  }

  @Override
  public boolean isArrayType() {
    return false;
  }

  @Override
  public final boolean isEnumType() {
    return false;
  }

  public final boolean isEnumImplType() {
    return false;
  }

  public final boolean isRecordType() {
    return false;
  }

  @Override
  public final boolean isInterface() {
    return false;
  }

  @Override
  public final boolean isPrimitive() {
    return false;
  }

  @Override
  public final boolean isFinal() {
    return false;
  }

  @Override
  public abstract boolean isContainerType();

  @Override
  public boolean isCollectionLikeType() {
    return false;
  }

  @Override
  public boolean isMapLikeType() {
    return false;
  }

  public final boolean isJavaLangObject() {
    return false;
  }

  public final boolean useStaticType() {
    return false;
  }

  @Override
  public boolean hasGenericTypes() {
    return false;
  }

  @Override
  public JavaType getKeyType() {
    return null;
  }

  @Override
  public JavaType getContentType() {
    return null;
  }

  @Override
  public JavaType getReferencedType() {
    return null;
  }

  @Override
  public abstract int containedTypeCount();

  @Override
  public abstract JavaType containedType(int index);

  @Override
  public abstract String containedTypeName(int index);

  @Override
  public Class<?> getParameterSource() {
    return null;
  }

  public JavaType containedTypeOrUnknown(int index) {
    return null;
  }

  public abstract JavaType findSuperType(Class<?> erasedTarget);

  public abstract JavaType getSuperClass();

  public abstract List<JavaType> getInterfaces();

  public abstract JavaType[] findTypeParameters(Class<?> expType);

  public <T> T getValueHandler() {
    return null;
  }

  public <T> T getTypeHandler() {
    return null;
  }

  public Object getContentValueHandler() {
    return false;
  }

  public Object getContentTypeHandler() {
    return false;
  }

  public boolean hasValueHandler() {
    return false;
  }

  public boolean hasHandlers() {
    return false;
  }

  public String getGenericSignature() {
    return null;
  }

  public abstract StringBuilder getGenericSignature(StringBuilder sb);

  public String getErasedSignature() {
    return null;
  }

  public abstract StringBuilder getErasedSignature(StringBuilder sb);

  @Override
  public abstract String toString();

  @Override
  public abstract boolean equals(Object o);

  @Override
  public final int hashCode() {
    return 0;
  }

}
