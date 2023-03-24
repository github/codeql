// Generated automatically from com.mitchellbosecke.pebble.tokenParser.TokenParser for testing purposes

package com.mitchellbosecke.pebble.tokenParser;

import com.mitchellbosecke.pebble.lexer.Token;
import com.mitchellbosecke.pebble.node.RenderableNode;
import com.mitchellbosecke.pebble.parser.Parser;

public interface TokenParser
{
    RenderableNode parse(Token p0, Parser p1);
    String getTag();
}
