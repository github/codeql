// Generated automatically from com.hubspot.jinjava.interpret.Context for testing purposes

package com.hubspot.jinjava.interpret;

import com.google.common.collect.SetMultimap;
import com.hubspot.jinjava.interpret.CallStack;
import com.hubspot.jinjava.interpret.DynamicVariableResolver;
import com.hubspot.jinjava.lib.Importable;
import com.hubspot.jinjava.lib.expression.ExpressionStrategy;
import com.hubspot.jinjava.lib.exptest.ExpTest;
import com.hubspot.jinjava.lib.filter.Filter;
import com.hubspot.jinjava.lib.fn.ELFunctionDefinition;
import com.hubspot.jinjava.lib.fn.MacroFunction;
import com.hubspot.jinjava.lib.tag.Tag;
import com.hubspot.jinjava.lib.tag.eager.EagerToken;
import com.hubspot.jinjava.tree.Node;
import com.hubspot.jinjava.util.ScopeMap;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

public class Context extends ScopeMap<String, Object>
{
    public CallStack getCurrentPathStack(){ return null; }
    public CallStack getExtendPathStack(){ return null; }
    public CallStack getImportPathStack(){ return null; }
    public CallStack getIncludePathStack(){ return null; }
    public CallStack getMacroStack(){ return null; }
    public Collection<ELFunctionDefinition> getAllFunctions(){ return null; }
    public Collection<ExpTest> getAllExpTests(){ return null; }
    public Collection<Filter> getAllFilters(){ return null; }
    public Collection<Tag> getAllTags(){ return null; }
    public Context getParent(){ return null; }
    public Context setDeferredExecutionMode(boolean p0){ return null; }
    public Context setValidationMode(boolean p0){ return null; }
    public Context(){}
    public Context(Context p0){}
    public Context(Context p0, Map<String, ? extends Object> p1){}
    public Context(Context p0, Map<String, ? extends Object> p1, Map<Context.Library, Set<String>> p2){}
    public Context(Context p0, Map<String, ? extends Object> p1, Map<Context.Library, Set<String>> p2, boolean p3){}
    public Context.TemporaryValueClosable<Boolean> withPartialMacroEvaluation(){ return null; }
    public Context.TemporaryValueClosable<Boolean> withUnwrapRawOverride(){ return null; }
    public DynamicVariableResolver getDynamicVariableResolver(){ return null; }
    public ELFunctionDefinition getFunction(String p0){ return null; }
    public ExpTest getExpTest(String p0){ return null; }
    public ExpressionStrategy getExpressionStrategy(){ return null; }
    public Filter getFilter(String p0){ return null; }
    public List<? extends Node> getSuperBlock(){ return null; }
    public MacroFunction getGlobalMacro(String p0){ return null; }
    public Map<String, MacroFunction> getGlobalMacros(){ return null; }
    public Map<String, Object> getSessionBindings(){ return null; }
    public Node getCurrentNode(){ return null; }
    public Optional<MacroFunction> getLocalMacro(String p0){ return null; }
    public Optional<String> getImportResourceAlias(){ return null; }
    public Set<EagerToken> getEagerTokens(){ return null; }
    public Set<Node> getDeferredNodes(){ return null; }
    public Set<String> getMetaContextVariables(){ return null; }
    public Set<String> getResolvedExpressions(){ return null; }
    public Set<String> getResolvedFunctions(){ return null; }
    public Set<String> getResolvedValues(){ return null; }
    public SetMultimap<String, String> getDependencies(){ return null; }
    public String popRenderStack(){ return null; }
    public Tag getTag(String p0){ return null; }
    public boolean doesRenderStackContain(String p0){ return false; }
    public boolean getThrowInterpreterErrors(){ return false; }
    public boolean isAutoEscape(){ return false; }
    public boolean isDeferredExecutionMode(){ return false; }
    public boolean isFunctionDisabled(String p0){ return false; }
    public boolean isGlobalMacro(String p0){ return false; }
    public boolean isPartialMacroEvaluation(){ return false; }
    public boolean isUnwrapRawOverride(){ return false; }
    public boolean isValidationMode(){ return false; }
    public boolean wasExpressionResolved(String p0){ return false; }
    public boolean wasValueResolved(String p0){ return false; }
    public final void registerClasses(Class<? extends Importable>... p0){}
    public int getRenderDepth(){ return 0; }
    public static String DEFERRED_IMPORT_RESOURCE_PATH_KEY = null;
    public static String GLOBAL_MACROS_SCOPE_KEY = null;
    public static String IMPORT_RESOURCE_ALIAS_KEY = null;
    public static String IMPORT_RESOURCE_PATH_KEY = null;
    public void addDependencies(SetMultimap<String, String> p0){}
    public void addDependency(String p0, String p1){}
    public void addGlobalMacro(MacroFunction p0){}
    public void addResolvedExpression(String p0){}
    public void addResolvedFrom(Context p0){}
    public void addResolvedFunction(String p0){}
    public void addResolvedValue(String p0){}
    public void checkNumberOfDeferredTokens(){}
    public void handleDeferredNode(Node p0){}
    public void handleEagerToken(EagerToken p0){}
    public void popFromStack(){}
    public void pushFromStack(String p0, int p1, int p2){}
    public void pushRenderStack(String p0){}
    public void registerExpTest(ExpTest p0){}
    public void registerFilter(Filter p0){}
    public void registerFunction(ELFunctionDefinition p0){}
    public void registerTag(Tag p0){}
    public void removeSuperBlock(){}
    public void reset(){}
    public void setAutoEscape(Boolean p0){}
    public void setCurrentNode(Node p0){}
    public void setDynamicVariableResolver(DynamicVariableResolver p0){}
    public void setExpressionStrategy(ExpressionStrategy p0){}
    public void setPartialMacroEvaluation(boolean p0){}
    public void setRenderDepth(int p0){}
    public void setSuperBlock(List<? extends Node> p0){}
    public void setThrowInterpreterErrors(boolean p0){}
    public void setUnwrapRawOverride(boolean p0){}
    static public class TemporaryValueClosable<T> implements AutoCloseable
    {
        protected TemporaryValueClosable() {}
        public void close(){}
    }
    static public enum Library
    {
        EXP_TEST, FILTER, FUNCTION, TAG;
        private Library() {}
    }
}
