package com.fasterxml.jackson.databind.cfg;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsontype.PolymorphicTypeValidator;

public abstract class MapperBuilder<M extends ObjectMapper, B extends MapperBuilder<M, B>> {
    public M build() { return null; }
    public B polymorphicTypeValidator(PolymorphicTypeValidator ptv) { return null; }
}
