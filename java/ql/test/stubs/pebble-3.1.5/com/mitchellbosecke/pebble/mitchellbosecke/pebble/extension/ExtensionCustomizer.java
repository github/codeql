// Generated automatically from com.mitchellbosecke.pebble.extension.ExtensionCustomizer for testing purposes

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
import java.util.List;
import java.util.Map;

abstract public class ExtensionCustomizer implements Extension
{
    protected ExtensionCustomizer() {}
    public ExtensionCustomizer(Extension p0){}
    public List<AttributeResolver> getAttributeResolver(){ return null; }
    public List<BinaryOperator> getBinaryOperators(){ return null; }
    public List<NodeVisitorFactory> getNodeVisitors(){ return null; }
    public List<TokenParser> getTokenParsers(){ return null; }
    public List<UnaryOperator> getUnaryOperators(){ return null; }
    public Map<String, Filter> getFilters(){ return null; }
    public Map<String, Function> getFunctions(){ return null; }
    public Map<String, Object> getGlobalVariables(){ return null; }
    public Map<String, Test> getTests(){ return null; }
}
