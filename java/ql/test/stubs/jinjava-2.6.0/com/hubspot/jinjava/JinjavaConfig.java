// Generated automatically from com.hubspot.jinjava.JinjavaConfig for testing purposes

package com.hubspot.jinjava;

import com.hubspot.jinjava.LegacyOverrides;
import com.hubspot.jinjava.interpret.Context;
import com.hubspot.jinjava.interpret.InterpreterFactory;
import com.hubspot.jinjava.mode.ExecutionMode;
import com.hubspot.jinjava.random.RandomNumberGeneratorStrategy;
import com.hubspot.jinjava.tree.parse.TokenScannerSymbols;
import java.nio.charset.Charset;
import java.time.ZoneId;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import jinjava.javax.el.ELResolver;

public class JinjavaConfig
{
    public Charset getCharset(){ return null; }
    public ELResolver getElResolver(){ return null; }
    public ExecutionMode getExecutionMode(){ return null; }
    public InterpreterFactory getInterpreterFactory(){ return null; }
    public JinjavaConfig(){}
    public JinjavaConfig(Charset p0, Locale p1, ZoneId p2, int p3){}
    public JinjavaConfig(InterpreterFactory p0){}
    public LegacyOverrides getLegacyOverrides(){ return null; }
    public Locale getLocale(){ return null; }
    public Map<Context.Library, Set<String>> getDisabled(){ return null; }
    public RandomNumberGeneratorStrategy getRandomNumberGeneratorStrategy(){ return null; }
    public TokenScannerSymbols getTokenScannerSymbols(){ return null; }
    public ZoneId getTimeZone(){ return null; }
    public boolean isEnableRecursiveMacroCalls(){ return false; }
    public boolean isFailOnUnknownTokens(){ return false; }
    public boolean isIterateOverMapKeys(){ return false; }
    public boolean isLstripBlocks(){ return false; }
    public boolean isNestedInterpretationEnabled(){ return false; }
    public boolean isTrimBlocks(){ return false; }
    public boolean isValidationMode(){ return false; }
    public int getMaxListSize(){ return 0; }
    public int getMaxMacroRecursionDepth(){ return 0; }
    public int getMaxMapSize(){ return 0; }
    public int getMaxNumEagerTokens(){ return 0; }
    public int getMaxRenderDepth(){ return 0; }
    public int getRangeLimit(){ return 0; }
    public long getMaxOutputSize(){ return 0; }
    public long getMaxStringLength(){ return 0; }
    public static JinjavaConfig.Builder newBuilder(){ return null; }
    public void setTokenScannerSymbols(TokenScannerSymbols p0){}
    static public class Builder
    {
        protected Builder() {}
        public JinjavaConfig build(){ return null; }
        public JinjavaConfig.Builder withCharset(Charset p0){ return null; }
        public JinjavaConfig.Builder withDisabled(Map<Context.Library, Set<String>> p0){ return null; }
        public JinjavaConfig.Builder withElResolver(ELResolver p0){ return null; }
        public JinjavaConfig.Builder withEnableRecursiveMacroCalls(boolean p0){ return null; }
        public JinjavaConfig.Builder withExecutionMode(ExecutionMode p0){ return null; }
        public JinjavaConfig.Builder withFailOnUnknownTokens(boolean p0){ return null; }
        public JinjavaConfig.Builder withInterperterFactory(InterpreterFactory p0){ return null; }
        public JinjavaConfig.Builder withIterateOverMapKeys(boolean p0){ return null; }
        public JinjavaConfig.Builder withLegacyOverrides(LegacyOverrides p0){ return null; }
        public JinjavaConfig.Builder withLocale(Locale p0){ return null; }
        public JinjavaConfig.Builder withLstripBlocks(boolean p0){ return null; }
        public JinjavaConfig.Builder withMaxListSize(int p0){ return null; }
        public JinjavaConfig.Builder withMaxMacroRecursionDepth(int p0){ return null; }
        public JinjavaConfig.Builder withMaxMapSize(int p0){ return null; }
        public JinjavaConfig.Builder withMaxNumEagerTokens(int p0){ return null; }
        public JinjavaConfig.Builder withMaxOutputSize(long p0){ return null; }
        public JinjavaConfig.Builder withMaxRenderDepth(int p0){ return null; }
        public JinjavaConfig.Builder withMaxStringLength(long p0){ return null; }
        public JinjavaConfig.Builder withNestedInterpretationEnabled(boolean p0){ return null; }
        public JinjavaConfig.Builder withRandomNumberGeneratorStrategy(RandomNumberGeneratorStrategy p0){ return null; }
        public JinjavaConfig.Builder withRangeLimit(int p0){ return null; }
        public JinjavaConfig.Builder withReadOnlyResolver(boolean p0){ return null; }
        public JinjavaConfig.Builder withTimeZone(ZoneId p0){ return null; }
        public JinjavaConfig.Builder withTokenScannerSymbols(TokenScannerSymbols p0){ return null; }
        public JinjavaConfig.Builder withTrimBlocks(boolean p0){ return null; }
        public JinjavaConfig.Builder withValidationMode(boolean p0){ return null; }
    }
}
