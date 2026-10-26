// Generated automatically from software.amazon.awssdk.core.interceptor.ExecutionAttributes for testing purposes

package software.amazon.awssdk.core.interceptor;

import java.util.Map;
import java.util.Optional;
import software.amazon.awssdk.core.interceptor.ExecutionAttribute;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ExecutionAttributes implements ToCopyableBuilder<ExecutionAttributes.Builder, ExecutionAttributes>
{
    protected ExecutionAttributes(Map<? extends ExecutionAttribute<? extends Object>, ? extends Object> p0){}
    public <U> ExecutionAttributes putAttribute(software.amazon.awssdk.core.interceptor.ExecutionAttribute<U> p0, U p1){ return null; }
    public <U> ExecutionAttributes putAttributeIfAbsent(software.amazon.awssdk.core.interceptor.ExecutionAttribute<U> p0, U p1){ return null; }
    public <U> U getAttribute(software.amazon.awssdk.core.interceptor.ExecutionAttribute<U> p0){ return null; }
    public <U> java.util.Optional<U> getOptionalAttribute(software.amazon.awssdk.core.interceptor.ExecutionAttribute<U> p0){ return null; }
    public ExecutionAttributes copy(){ return null; }
    public ExecutionAttributes merge(ExecutionAttributes p0){ return null; }
    public ExecutionAttributes(){}
    public ExecutionAttributes.Builder toBuilder(){ return null; }
    public Map<ExecutionAttribute<? extends Object>, Object> getAttributes(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static ExecutionAttributes unmodifiableExecutionAttributes(ExecutionAttributes p0){ return null; }
    public static ExecutionAttributes.Builder builder(){ return null; }
    public void putAbsentAttributes(ExecutionAttributes p0){}
    static public class Builder implements CopyableBuilder<ExecutionAttributes.Builder, ExecutionAttributes>
    {
        protected Builder() {}
        public <T> ExecutionAttributes.Builder put(software.amazon.awssdk.core.interceptor.ExecutionAttribute<T> p0, T p1){ return null; }
        public ExecutionAttributes build(){ return null; }
        public ExecutionAttributes.Builder putAll(Map<? extends ExecutionAttribute<? extends Object>, ? extends Object> p0){ return null; }
    }
}
