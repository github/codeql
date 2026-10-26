// Generated automatically from com.mitchellbosecke.pebble.extension.Extension for testing purposes

package com.mitchellbosecke.pebble.extension;

import com.mitchellbosecke.pebble.attributes.AttributeResolver;
import com.mitchellbosecke.pebble.extension.Filter;
import com.mitchellbosecke.pebble.extension.Function;
import com.mitchellbosecke.pebble.extension.NodeVisitorFactory;
import com.mitchellbosecke.pebble.extension.Test;
import com.mitchellbosecke.pebble.operator.BinaryOperator;
import com.mitchellbosecke.pebble.operator.UnaryOperator;
import com.mitchellbosecke.pebble.tokenParser.TokenParser;
import java.util.List;
import java.util.Map;

public interface Extension
{
    List<AttributeResolver> getAttributeResolver();
    List<BinaryOperator> getBinaryOperators();
    List<NodeVisitorFactory> getNodeVisitors();
    List<TokenParser> getTokenParsers();
    List<UnaryOperator> getUnaryOperators();
    Map<String, Filter> getFilters();
    Map<String, Function> getFunctions();
    Map<String, Object> getGlobalVariables();
    Map<String, Test> getTests();
}
