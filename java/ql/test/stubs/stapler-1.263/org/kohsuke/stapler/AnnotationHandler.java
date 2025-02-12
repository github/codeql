// Generated automatically from org.kohsuke.stapler.AnnotationHandler for testing purposes

package org.kohsuke.stapler;

import java.lang.annotation.Annotation;
import org.kohsuke.stapler.StaplerRequest;

abstract public class AnnotationHandler<T extends Annotation>
{
    protected final Object convert(Class p0, String p1){ return null; }
    public AnnotationHandler(){}
    public abstract Object parse(StaplerRequest p0, T p1, Class p2, String p3);
}
