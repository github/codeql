package org.springframework.http;

public class ResponseEntity<T> extends org.springframework.http.HttpEntity {

    // private final java.lang.Object status;

    // public ResponseEntity(org.springframework.http.HttpStatus status) {
    // }

    // public ResponseEntity(T body, org.springframework.http.HttpStatus status) {
    // }

    public static <T> ResponseEntity<T> ok(T body) {
        return null;
    }
 }