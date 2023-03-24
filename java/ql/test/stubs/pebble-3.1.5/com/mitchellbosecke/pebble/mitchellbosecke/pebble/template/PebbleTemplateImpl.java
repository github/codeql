// Generated automatically from com.mitchellbosecke.pebble.template.PebbleTemplateImpl for testing purposes

package com.mitchellbosecke.pebble.template;

import com.mitchellbosecke.pebble.PebbleEngine;
import com.mitchellbosecke.pebble.extension.escaper.SafeString;
import com.mitchellbosecke.pebble.node.ArgumentsNode;
import com.mitchellbosecke.pebble.node.BlockNode;
import com.mitchellbosecke.pebble.node.RenderableNode;
import com.mitchellbosecke.pebble.template.Block;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.Macro;
import com.mitchellbosecke.pebble.template.PebbleTemplate;
import com.mitchellbosecke.pebble.utils.Pair;
import java.io.Writer;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class PebbleTemplateImpl implements PebbleTemplate
{
    protected PebbleTemplateImpl() {}
    public PebbleTemplateImpl getNamedImportedTemplate(EvaluationContextImpl p0, String p1){ return null; }
    public PebbleTemplateImpl(PebbleEngine p0, RenderableNode p1, String p2){}
    public SafeString macro(EvaluationContextImpl p0, String p1, ArgumentsNode p2, boolean p3, int p4){ return null; }
    public String getName(){ return null; }
    public String resolveRelativePath(String p0){ return null; }
    public boolean hasBlock(String p0){ return false; }
    public boolean hasMacro(String p0){ return false; }
    public void block(Writer p0, EvaluationContextImpl p1, String p2, boolean p3){}
    public void embedTemplate(int p0, Writer p1, EvaluationContextImpl p2, String p3, Map<? extends Object, ? extends Object> p4, List<BlockNode> p5){}
    public void evaluate(Writer p0){}
    public void evaluate(Writer p0, Locale p1){}
    public void evaluate(Writer p0, Map<String, Object> p1){}
    public void evaluate(Writer p0, Map<String, Object> p1, Locale p2){}
    public void evaluateBlock(String p0, Writer p1){}
    public void evaluateBlock(String p0, Writer p1, Locale p2){}
    public void evaluateBlock(String p0, Writer p1, Map<String, Object> p2){}
    public void evaluateBlock(String p0, Writer p1, Map<String, Object> p2, Locale p3){}
    public void importNamedMacrosFromTemplate(String p0, List<Pair<String, String>> p1){}
    public void importNamedTemplate(EvaluationContextImpl p0, String p1, String p2){}
    public void importTemplate(EvaluationContextImpl p0, String p1){}
    public void includeTemplate(Writer p0, EvaluationContextImpl p1, String p2, Map<? extends Object, ? extends Object> p3){}
    public void registerBlock(Block p0){}
    public void registerMacro(Macro p0){}
    public void registerMacro(String p0, Macro p1){}
    public void setParent(EvaluationContextImpl p0, String p1){}
}
