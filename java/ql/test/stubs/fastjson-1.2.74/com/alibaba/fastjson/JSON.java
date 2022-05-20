/*
 * Copyright 1999-2017 Alibaba Group.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.alibaba.fastjson;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.util.*;

import com.alibaba.fastjson.parser.*;
import com.alibaba.fastjson.parser.deserializer.ParseProcess;

public abstract class JSON {
    public static String toJSONString(Object object) {
        return null;
    }

    public static Object parse(String text) {
        return null;
    }

    public static Object parse(String text, ParserConfig config) {
        return null;
    }

    public static Object parse(String text, ParserConfig config, Feature... features) {
        return null;
    }

    public static Object parse(String text, ParserConfig config, int features) {
        return null;
    }

    public static Object parse(String text, int features) {
        return null;
    }

    public static Object parse(byte[] input, Feature... features) {
        return null;
    }

    public static Object parse(byte[] input, int off, int len, CharsetDecoder charsetDecoder, Feature... features) {
        return null;
    }

    public static Object parse(byte[] input, int off, int len, CharsetDecoder charsetDecoder, int features) {
        return null;
    }

    public static Object parse(String text, Feature... features) {
        return null;
    }

    public static JSONObject parseObject(String text, Feature... features) {
        return null;
    }

    public static JSONObject parseObject(String text) {
        return null;
    }

    public static <T> T parseObject(String text, TypeReference<T> type, Feature... features) {
        return null;
    }

    public static <T> T parseObject(String json, Class<T> clazz, Feature... features) {
        return null;
    }

    public static <T> T parseObject(String text, Class<T> clazz, ParseProcess processor, Feature... features) {
        return null;
    }

    public static <T> T parseObject(String json, Type type, Feature... features) {
        return null;
    }

    public static <T> T parseObject(String input, Type clazz, ParseProcess processor, Feature... features) {
        return null;
    }

    public static <T> T parseObject(String input, Type clazz, int featureValues, Feature... features) {
        return null;
    }

    public static <T> T parseObject(String input, Type clazz, ParserConfig config, Feature... features) {
        return null;
    }

    public static <T> T parseObject(String input, Type clazz, ParserConfig config, int featureValues,
                                          Feature... features) {
        return null;
    }

    public static <T> T parseObject(String input, Type clazz, ParserConfig config, ParseProcess processor,
                                          int featureValues, Feature... features) {
        return null;
    }

    public static <T> T parseObject(byte[] bytes, Type clazz, Feature... features) {
        return null;
    }

    public static <T> T parseObject(byte[] bytes, int offset, int len, Charset charset, Type clazz, Feature... features) {
        return null;
    }

    public static <T> T parseObject(byte[] bytes,
                                    Charset charset,
                                    Type clazz,
                                    ParserConfig config,
                                    ParseProcess processor,
                                    int featureValues,
                                    Feature... features) {
        return null;
    }

    public static <T> T parseObject(byte[] bytes, int offset, int len,
                                    Charset charset,
                                    Type clazz,
                                    ParserConfig config,
                                    ParseProcess processor,
                                    int featureValues,
                                    Feature... features) {
        return null;
    }

    public static <T> T parseObject(byte[] input,
                                    int off,
                                    int len,
                                    CharsetDecoder charsetDecoder,
                                    Type clazz,
                                    Feature... features) {
        return null;
    }

    public static <T> T parseObject(char[] input, int length, Type clazz, Feature... features) {
        return null;
    }

    public static <T> T parseObject(InputStream is,
                                    Type type,
                                    Feature... features) throws IOException {
        return null;
    }

    public static <T> T parseObject(InputStream is,
                                    Charset charset,
                                    Type type,
                                    Feature... features) throws IOException {
        return null;
    }

    public static <T> T parseObject(InputStream is,
                                    Charset charset,
                                    Type type,
                                    ParserConfig config,
                                    Feature... features) throws IOException {
        return null;
    }

    public static <T> T parseObject(InputStream is,
                                    Charset charset,
                                    Type type,
                                    ParserConfig config,
                                    ParseProcess processor,
                                    int featureValues,
                                    Feature... features) throws IOException {
        return null;
    }

    public static <T> T parseObject(String text, Class<T> clazz) {
        return null;
    }

    public static JSONArray parseArray(String text) {
        return null;
    }

    public static JSONArray parseArray(String text, ParserConfig parserConfig) {
        return null;
    }

    public static <T> List<T> parseArray(String text, Class<T> clazz) {
        return null;
    }

    public static <T> List<T> parseArray(String text, Class<T> clazz, ParserConfig config) {
        return null;
    }

    public static List<Object> parseArray(String text, Type[] types) {
        return null;
    }

    public static List<Object> parseArray(String text, Type[] types, ParserConfig config) {
        return null;
    }
}
