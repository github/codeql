// Generated automatically from com.google.common.base.Ticker for testing purposes

package com.google.common.base;


abstract public class Ticker
{
    protected Ticker(){}
    public abstract long read();
    public static Ticker systemTicker(){ return null; }
}
