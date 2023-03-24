// Generated automatically from com.mitchellbosecke.pebble.parser.Parser for testing purposes

package com.mitchellbosecke.pebble.parser;

import com.mitchellbosecke.pebble.lexer.TokenStream;
import com.mitchellbosecke.pebble.node.BodyNode;
import com.mitchellbosecke.pebble.node.RootNode;
import com.mitchellbosecke.pebble.parser.ExpressionParser;
import com.mitchellbosecke.pebble.parser.StoppingCondition;

public interface Parser
{
    BodyNode subparse();
    BodyNode subparse(StoppingCondition p0);
    ExpressionParser getExpressionParser();
    RootNode parse(TokenStream p0);
    String peekBlockStack();
    String popBlockStack();
    TokenStream getStream();
    void pushBlockStack(String p0);
}
