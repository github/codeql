package com.fasterxml.jackson.databind.json;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.cfg.MapperBuilder;

public class JsonMapper extends ObjectMapper {
    public static JsonMapper.Builder builder() { return null; }
    public static class Builder extends MapperBuilder<JsonMapper, JsonMapper.Builder> {}
}