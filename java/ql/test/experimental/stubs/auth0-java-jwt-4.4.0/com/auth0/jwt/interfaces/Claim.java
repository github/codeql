// Generated automatically from com.auth0.jwt.interfaces.Claim for testing purposes

package com.auth0.jwt.interfaces;

import java.time.Instant;
import java.util.Date;
import java.util.List;
import java.util.Map;

public interface Claim
{
    <T> T as(java.lang.Class<T> p0);
    <T> T[] asArray(java.lang.Class<T> p0);
    <T> java.util.List<T> asList(java.lang.Class<T> p0);
    Boolean asBoolean();
    Date asDate();
    Double asDouble();
    Integer asInt();
    Long asLong();
    Map<String, Object> asMap();
    String asString();
    boolean isMissing();
    boolean isNull();
    default Instant asInstant(){ return null; }
}
