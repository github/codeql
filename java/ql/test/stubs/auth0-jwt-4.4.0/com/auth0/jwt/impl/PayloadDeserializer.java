package com.auth0.jwt.impl;

import com.auth0.jwt.RegisteredClaims;
import com.auth0.jwt.exceptions.JWTDecodeException;
import com.auth0.jwt.interfaces.Payload;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.ObjectCodec;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectReader;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;

import java.io.IOException;
import java.time.Instant;
import java.util.*;

/**
 * Jackson deserializer implementation for converting from JWT Payload parts.
 * <p>
 * This class is thread-safe.
 *
 * @see JWTParser
 */
class PayloadDeserializer extends StdDeserializer<Payload> {

    PayloadDeserializer() {
        super(Payload.class);
    }

    @Override
    public Payload deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        Map<String, JsonNode> tree = p.getCodec().readValue(p, new TypeReference<Map<String, JsonNode>>() {
        });
        if (tree == null) {
            throw new JWTDecodeException("Parsing the Payload's JSON resulted on a Null map");
        }

        String issuer = getString(tree, RegisteredClaims.ISSUER);
        String subject = getString(tree, RegisteredClaims.SUBJECT);
        List<String> audience = getStringOrArray(p.getCodec(), tree, RegisteredClaims.AUDIENCE);
        Instant expiresAt = getInstantFromSeconds(tree, RegisteredClaims.EXPIRES_AT);
        Instant notBefore = getInstantFromSeconds(tree, RegisteredClaims.NOT_BEFORE);
        Instant issuedAt = getInstantFromSeconds(tree, RegisteredClaims.ISSUED_AT);
        String jwtId = getString(tree, RegisteredClaims.JWT_ID);

        return new PayloadImpl(issuer, subject, audience, expiresAt, notBefore, issuedAt, jwtId, tree, p.getCodec());
    }

    List<String> getStringOrArray(ObjectCodec codec, Map<String, JsonNode> tree, String claimName)
            throws JWTDecodeException {
        JsonNode node = tree.get(claimName);
        if (node == null || node.isNull() || !(node.isArray() || node.isTextual())) {
            return null;
        }
        if (node.isTextual() && !node.asText().isEmpty()) {
            return Collections.singletonList(node.asText());
        }

        List<String> list = new ArrayList<>(node.size());
        for (int i = 0; i < node.size(); i++) {
            try {
                list.add(codec.treeToValue(node.get(i), String.class));
            } catch (JsonProcessingException e) {
                throw new JWTDecodeException("Couldn't map the Claim's array contents to String", e);
            }
        }
        return list;
    }

    Instant getInstantFromSeconds(Map<String, JsonNode> tree, String claimName) {
        JsonNode node = tree.get(claimName);
        if (node == null || node.isNull()) {
            return null;
        }
        if (!node.canConvertToLong()) {
            throw new JWTDecodeException(
                    String.format("The claim '%s' contained a non-numeric date value.", claimName));
        }
        return Instant.ofEpochSecond(node.asLong());
    }

    String getString(Map<String, JsonNode> tree, String claimName) {
        JsonNode node = tree.get(claimName);
        if (node == null || node.isNull()) {
            return null;
        }
        return node.asText(null);
    }
}
