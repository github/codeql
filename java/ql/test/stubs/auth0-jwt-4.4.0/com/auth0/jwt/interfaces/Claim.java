package com.auth0.jwt.interfaces;

import com.auth0.jwt.exceptions.JWTDecodeException;

import java.time.Instant;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * The Claim class holds the value in a generic way so that it can be recovered in many representations.
 */
public interface Claim {

    /**
     * Whether this Claim has a null value or not.
     * If the claim is not present, it will return false hence checking {@link Claim#isMissing} is advised as well
     *
     * @return whether this Claim has a null value or not.
     */
    boolean isNull();

    /**
     * Can be used to verify whether the Claim is found or not.
     * This will be true even if the Claim has {@code null} value associated to it.
     *
     * @return whether this Claim is present or not
     */
    boolean isMissing();

    /**
     * Get this Claim as a Boolean.
     * If the value isn't of type Boolean or it can't be converted to a Boolean, {@code null} will be returned.
     *
     * @return the value as a Boolean or null.
     */
    Boolean asBoolean();

    /**
     * Get this Claim as an Integer.
     * If the value isn't of type Integer or it can't be converted to an Integer, {@code null} will be returned.
     *
     * @return the value as an Integer or null.
     */
    Integer asInt();

    /**
     * Get this Claim as an Long.
     * If the value isn't of type Long or it can't be converted to a Long, {@code null} will be returned.
     *
     * @return the value as an Long or null.
     */
    Long asLong();

    /**
     * Get this Claim as a Double.
     * If the value isn't of type Double or it can't be converted to a Double, {@code null} will be returned.
     *
     * @return the value as a Double or null.
     */
    Double asDouble();

    /**
     * Get this Claim as a String.
     * If the value isn't of type String, {@code null} will be returned. For a String representation of non-textual
     * claim types, clients can call {@code toString()}.
     *
     * @return the value as a String or null if the underlying value is not a string.
     */
    String asString();

    /**
     * Get this Claim as a Date.
     * If the value can't be converted to a Date, {@code null} will be returned.
     *
     * @return the value as a Date or null.
     */
    Date asDate();

    /**
     * Get this Claim as an Instant.
     * If the value can't be converted to an Instant, {@code null} will be returned.
     *
     * @return the value as a Date or null.
     */
    default Instant asInstant() {
        Date date = asDate();
        return date != null ? date.toInstant() : null;
    }

    /**
     * Get this Claim as an Array of type T.
     * If the value isn't an Array, {@code null} will be returned.
     *
     * @param <T> type
     * @param clazz the type class
     * @return the value as an Array or null.
     * @throws JWTDecodeException if the values inside the Array can't be converted to a class T.
     */
    <T> T[] asArray(Class<T> clazz) throws JWTDecodeException;

    /**
     * Get this Claim as a List of type T.
     * If the value isn't an Array, {@code null} will be returned.
     *
     * @param <T> type
     * @param clazz the type class
     * @return the value as a List or null.
     * @throws JWTDecodeException if the values inside the List can't be converted to a class T.
     */
    <T> List<T> asList(Class<T> clazz) throws JWTDecodeException;

    /**
     * Get this Claim as a generic Map of values.
     *
     * @return the value as instance of Map.
     * @throws JWTDecodeException if the value can't be converted to a Map.
     */
    Map<String, Object> asMap() throws JWTDecodeException;

    /**
     * Get this Claim as a custom type T.
     * This method will return null if {@link Claim#isMissing()} or {@link Claim#isNull()} is true
     *
     * @param <T> type
     * @param clazz the type class
     * @return the value as instance of T.
     * @throws JWTDecodeException if the value can't be converted to a class T.
     */
    <T> T as(Class<T> clazz) throws JWTDecodeException;
}
