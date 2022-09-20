// Generated automatically from com.fasterxml.jackson.databind.deser.DataFormatReaders for testing purposes

package com.fasterxml.jackson.databind.deser;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.format.MatchStrength;
import com.fasterxml.jackson.databind.DeserializationConfig;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectReader;
import java.io.InputStream;
import java.util.Collection;

public class DataFormatReaders
{
    protected DataFormatReaders() {}
    protected final MatchStrength _minimalMatch = null;
    protected final MatchStrength _optimalMatch = null;
    protected final ObjectReader[] _readers = null;
    protected final int _maxInputLookahead = 0;
    public DataFormatReaders with(DeserializationConfig p0){ return null; }
    public DataFormatReaders with(ObjectReader[] p0){ return null; }
    public DataFormatReaders withMaxInputLookahead(int p0){ return null; }
    public DataFormatReaders withMinimalMatch(MatchStrength p0){ return null; }
    public DataFormatReaders withOptimalMatch(MatchStrength p0){ return null; }
    public DataFormatReaders withType(JavaType p0){ return null; }
    public DataFormatReaders(Collection<ObjectReader> p0){}
    public DataFormatReaders(ObjectReader... p0){}
    public DataFormatReaders.Match findFormat(InputStream p0){ return null; }
    public DataFormatReaders.Match findFormat(byte[] p0){ return null; }
    public DataFormatReaders.Match findFormat(byte[] p0, int p1, int p2){ return null; }
    public String toString(){ return null; }
    public static int DEFAULT_MAX_INPUT_LOOKAHEAD = 0;
    static public class Match
    {
        protected Match() {}
        protected Match(InputStream p0, byte[] p1, int p2, int p3, ObjectReader p4, MatchStrength p5){}
        protected final InputStream _originalStream = null;
        protected final MatchStrength _matchStrength = null;
        protected final ObjectReader _match = null;
        protected final byte[] _bufferedData = null;
        protected final int _bufferedLength = 0;
        protected final int _bufferedStart = 0;
        public InputStream getDataStream(){ return null; }
        public JsonParser createParserWithMatch(){ return null; }
        public MatchStrength getMatchStrength(){ return null; }
        public ObjectReader getReader(){ return null; }
        public String getMatchedFormatName(){ return null; }
        public boolean hasMatch(){ return false; }
    }
}
