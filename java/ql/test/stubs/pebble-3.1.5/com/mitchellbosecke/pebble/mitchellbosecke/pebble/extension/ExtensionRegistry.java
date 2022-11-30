// Generated automatically from com.mitchellbosecke.pebble.extension.ExtensionRegistry for testing purposes

package com.mitchellbosecke.pebble.extension;

import com.mitchellbosecke.pebble.attributes.AttributeResolver;
import com.mitchellbosecke.pebble.extension.Extension;
import com.mitchellbosecke.pebble.extension.Filter;
import com.mitchellbosecke.pebble.extension.Function;
import com.mitchellbosecke.pebble.extension.NodeVisitorFactory;
import com.mitchellbosecke.pebble.extension.Test;
import com.mitchellbosecke.pebble.operator.BinaryOperator;
import com.mitchellbosecke.pebble.operator.UnaryOperator;
import com.mitchellbosecke.pebble.tokenParser.TokenParser;
import java.util.Collection;
import java.util.List;
import java.util.Map;

public class ExtensionRegistry
{
    public ExtensionRegistry(){}
    public ExtensionRegistry(Collection<? extends Extension> p0){}
    public Filter getFilter(String p0){ return null; }
    public Function getFunction(String p0){ return null; }
    public List<AttributeResolver> getAttributeResolver(){ return null; }
    public List<NodeVisitorFactory> getNodeVisitors(){ return null; }
    public Map<String, BinaryOperator> getBinaryOperators(){ return null; }
    public Map<String, Object> getGlobalVariables(){ return null; }
    public Map<String, TokenParser> getTokenParsers(){ return null; }
    public Map<String, UnaryOperator> getUnaryOperators(){ return null; }
    public Test getTest(String p0){ return null; }
    public void addExtension(Extension p0){}
    public void addOperatorOverridingExtension(Extension p0){}
}
