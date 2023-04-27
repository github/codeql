// Generated automatically from org.apache.htrace.core.Sampler for testing purposes

package org.apache.htrace.core;


abstract public class Sampler
{
    public Sampler(){}
    public abstract boolean next();
    public static Sampler ALWAYS = null;
    public static Sampler NEVER = null;
}
