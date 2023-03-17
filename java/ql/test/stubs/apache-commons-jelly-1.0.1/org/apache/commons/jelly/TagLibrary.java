// Generated automatically from org.apache.commons.jelly.TagLibrary for testing purposes

package org.apache.commons.jelly;

import java.util.Map;
import org.apache.commons.jelly.Tag;
import org.apache.commons.jelly.expression.Expression;
import org.apache.commons.jelly.expression.ExpressionFactory;
import org.apache.commons.jelly.impl.TagFactory;
import org.apache.commons.jelly.impl.TagScript;
import org.xml.sax.Attributes;

abstract public class TagLibrary
{
    protected ExpressionFactory getExpressionFactory(){ return null; }
    protected Map getTagClasses(){ return null; }
    protected void registerTag(String p0, Class p1){}
    protected void registerTagFactory(String p0, TagFactory p1){}
    public Expression createExpression(ExpressionFactory p0, TagScript p1, String p2, String p3){ return null; }
    public Tag createTag(String p0, Attributes p1){ return null; }
    public TagLibrary(){}
    public TagScript createTagScript(String p0, Attributes p1){ return null; }
}
