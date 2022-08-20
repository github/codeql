package com.hubspot.jinjava;

import com.hubspot.jinjava.JinjavaConfig;
import com.hubspot.jinjava.interpret.RenderResult;

import java.lang.String;
import java.util.Map;

public class Jinjava {
    public Jinjava() {
    }

    public String render(String template, Map<String, ?> bindings) {
        return "test";
    };

    public RenderResult renderForResult(String template, Map<String, ?> bindings) {
        return new RenderResult("result");
    }

    public RenderResult renderForResult(String template, Map<String, ?> bindings, JinjavaConfig renderConfig) {
        return new RenderResult("result");
    }
}
