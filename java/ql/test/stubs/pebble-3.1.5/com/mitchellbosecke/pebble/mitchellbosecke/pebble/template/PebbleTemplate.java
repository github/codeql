// Generated automatically from com.mitchellbosecke.pebble.template.PebbleTemplate for testing purposes

package com.mitchellbosecke.pebble.template;

import java.io.Writer;
import java.util.Locale;
import java.util.Map;

public interface PebbleTemplate
{
    String getName();
    void evaluate(Writer p0);
    void evaluate(Writer p0, Locale p1);
    void evaluate(Writer p0, Map<String, Object> p1);
    void evaluate(Writer p0, Map<String, Object> p1, Locale p2);
    void evaluateBlock(String p0, Writer p1);
    void evaluateBlock(String p0, Writer p1, Locale p2);
    void evaluateBlock(String p0, Writer p1, Map<String, Object> p2);
    void evaluateBlock(String p0, Writer p1, Map<String, Object> p2, Locale p3);
}
