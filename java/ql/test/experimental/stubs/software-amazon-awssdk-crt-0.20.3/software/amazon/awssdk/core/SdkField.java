// Generated automatically from software.amazon.awssdk.core.SdkField for testing purposes

package software.amazon.awssdk.core;

import java.util.Optional;
import java.util.function.BiConsumer;
import java.util.function.Function;
import java.util.function.Supplier;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.core.protocol.MarshallLocation;
import software.amazon.awssdk.core.protocol.MarshallingType;
import software.amazon.awssdk.core.traits.Trait;

public class SdkField<TypeT>
{
    protected SdkField() {}
    public <T extends Trait> T getRequiredTrait(java.lang.Class<T> p0){ return null; }
    public <T extends Trait> T getTrait(java.lang.Class<T> p0){ return null; }
    public <T extends Trait> java.util.Optional<T> getOptionalTrait(java.lang.Class<T> p0){ return null; }
    public MarshallLocation location(){ return null; }
    public String locationName(){ return null; }
    public String memberName(){ return null; }
    public String unmarshallLocationName(){ return null; }
    public Supplier<SdkPojo> constructor(){ return null; }
    public TypeT getValueOrDefault(Object p0){ return null; }
    public boolean containsTrait(Class<? extends Trait> p0){ return false; }
    public software.amazon.awssdk.core.protocol.MarshallingType<? super TypeT> marshallingType(){ return null; }
    public static <TypeT> SdkField.Builder<TypeT> builder(software.amazon.awssdk.core.protocol.MarshallingType<? super TypeT> p0){ return null; }
    public void set(Object p0, Object p1){}
    static public class Builder<TypeT>
    {
        protected Builder() {}
        public SdkField.Builder<TypeT> constructor(Supplier<SdkPojo> p0){ return null; }
        public SdkField.Builder<TypeT> getter(Function<Object, TypeT> p0){ return null; }
        public SdkField.Builder<TypeT> memberName(String p0){ return null; }
        public SdkField.Builder<TypeT> setter(BiConsumer<Object, TypeT> p0){ return null; }
        public SdkField.Builder<TypeT> traits(Trait... p0){ return null; }
        public SdkField<TypeT> build(){ return null; }
    }
}
