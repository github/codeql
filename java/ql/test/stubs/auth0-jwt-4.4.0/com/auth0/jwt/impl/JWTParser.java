package com.auth0.jwt.impl;

import com.auth0.jwt.exceptions.JWTDecodeException;
import com.auth0.jwt.interfaces.Header;
import com.auth0.jwt.interfaces.JWTPartsParser;
import com.auth0.jwt.interfaces.Payload;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectReader;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.module.SimpleModule;
import java.io.IOException;

/**
 * This class helps in decoding the Header and Payload of the JWT using
 * {@link HeaderSerializer} and {@link PayloadSerializer}.
 */
public class JWTParser implements JWTPartsParser {
    private static final ObjectMapper DEFAULT_OBJECT_MAPPER = createDefaultObjectMapper();
    private static final ObjectReader DEFAULT_PAYLOAD_READER = DEFAULT_OBJECT_MAPPER.readerFor(Payload.class);
    private static final ObjectReader DEFAULT_HEADER_READER = DEFAULT_OBJECT_MAPPER.readerFor(Header.class);

    private final ObjectReader payloadReader;
    private final ObjectReader headerReader;

    public JWTParser() {
        this.payloadReader = DEFAULT_PAYLOAD_READER;
        this.headerReader = DEFAULT_HEADER_READER;
    }

    JWTParser(ObjectMapper mapper) {
        addDeserializers(mapper);

        this.payloadReader = mapper.readerFor(Payload.class);
        this.headerReader = mapper.readerFor(Header.class);
    }

    @Override
    public Payload parsePayload(String json) throws JWTDecodeException {
        if (json == null) {
            throw decodeException();
        }

        try {
            return payloadReader.readValue(json);
        } catch (IOException e) {
            throw decodeException(json);
        }
    }

    @Override
    public Header parseHeader(String json) throws JWTDecodeException {
        if (json == null) {
            throw decodeException();
        }

        try {
            return headerReader.readValue(json);
        } catch (IOException e) {
            throw decodeException(json);
        }
    }

    static void addDeserializers(ObjectMapper mapper) {
        SimpleModule module = new SimpleModule();
        module.addDeserializer(Payload.class, new PayloadDeserializer());
        module.addDeserializer(Header.class, new HeaderDeserializer());
        mapper.registerModule(module);
    }

    static ObjectMapper getDefaultObjectMapper() {
        return DEFAULT_OBJECT_MAPPER;
    }

    private static ObjectMapper createDefaultObjectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);
        mapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);

        addDeserializers(mapper);

        return mapper;
    }

    private static JWTDecodeException decodeException() {
        return decodeException(null);
    }

    private static JWTDecodeException decodeException(String json) {
        return new JWTDecodeException(String.format("The string '%s' doesn't have a valid JSON format.", json));
    }
}
