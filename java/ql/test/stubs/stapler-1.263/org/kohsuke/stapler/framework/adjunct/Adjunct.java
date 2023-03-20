// Generated automatically from org.kohsuke.stapler.framework.adjunct.Adjunct for testing purposes

package org.kohsuke.stapler.framework.adjunct;

import java.util.List;
import org.apache.commons.jelly.XMLOutput;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.framework.adjunct.AdjunctManager;

public class Adjunct
{
    protected Adjunct() {}
    public Adjunct(AdjunctManager p0, String p1, ClassLoader p2){}
    public String getPackageUrl(){ return null; }
    public boolean has(Adjunct.Kind p0){ return false; }
    public final AdjunctManager manager = null;
    public final List<String> required = null;
    public final String name = null;
    public final String packageName = null;
    public final String slashedName = null;
    public void write(StaplerRequest p0, XMLOutput p1){}
    static public enum Kind
    {
        CSS, JS;
        private Kind() {}
    }
}
