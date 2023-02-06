// Generated automatically from com.hubspot.jinjava.lib.tag.Tag for testing purposes

package com.hubspot.jinjava.lib.tag;

import com.hubspot.jinjava.interpret.JinjavaInterpreter;
import com.hubspot.jinjava.lib.Importable;
import com.hubspot.jinjava.tree.TagNode;
import com.hubspot.jinjava.tree.output.OutputNode;
import java.io.Serializable;

public interface Tag extends Importable, Serializable
{
    String interpret(TagNode p0, JinjavaInterpreter p1);
    default OutputNode interpretOutput(TagNode p0, JinjavaInterpreter p1){ return null; }
    default String getEndTagName(){ return null; }
    default boolean isRenderedInValidationMode(){ return false; }
}
