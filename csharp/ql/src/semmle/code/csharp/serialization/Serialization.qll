import csharp

class SerializationConstructor extends Constructor {
  SerializationConstructor() {
    this.getNumberOfParameters() = 2 and
    this.getParameter(0).getType().hasName("SerializationInfo") and
    this.getParameter(1).getType().hasName("StreamingContext")
  }
}

/**
 * A serializable type, using any of the built-in .NET serialization mechanisms.
 */
abstract class SerializableType extends ValueOrRefType {
  /**
   * A method or constructor that should always be considered as potentially
   * called on a deserialized object. The precise details depend on the
   * deserialization mechanism.
   */
  abstract Callable getADeserializationCallback();

  /**
   * A field whose value is restored during a deserialization, rendering it
   * potentially untrusted.
   */
  abstract Field getASerializedField();

  /**
   * Get a callback that is automatically executed (without user code
   * interaction) when an object instance is deserialized. This includes
   * deserialization callbacks as well as cleanup/dispose calls.
   */
  Callable getAnAutomaticCallback() {
    result = this.getADeserializationCallback() or
    result.(Destructor).getDeclaringType() = this or
    result = any(Method m |
        m.getDeclaringType() = this and
        m.hasName("Dispose") and
        (
          m.getNumberOfParameters() = 0
          or
          m.getNumberOfParameters() = 1 and m.getParameter(0).getType() instanceof BoolType
        )
      )
  }
}

/**
 * To be serializable by the `BinaryFormatter`, a class must have the `Serializable`
 * attribute.
 */
class BinarySerializableType extends SerializableType {
  BinarySerializableType() { this.getAnAttribute().getType().hasName("SerializableAttribute") }

  /**
   * In addition to the defaults, a `BinarySerializer` will call any method annotated
   * with an `OnDeserialized` or `OnDeserializing` attribute, as well as an
   * `OnDeserialization` method.
   */
  override Callable getADeserializationCallback() {
    result.(SerializationConstructor).getDeclaringType() = this
    or
    result = this.getAMethod() and
    (
      result.(Attributable).getAnAttribute().getType().hasName("OnDeserializedAttribute") or
      result.(Attributable).getAnAttribute().getType().hasName("OnDeserializingAttribute") or
      result.hasName("OnDeserialization")
    )
  }

  override Field getASerializedField() {
    result.getDeclaringType() = this and
    not result.getAnAttribute().getType().hasName("NonSerializedAttribute") and
    not result.isStatic()
  }
}

/**
 * If a class annotated with the `Serializable` attribute also implements `ISerializable`,
 * then it is serialized and deserialized in a special way.
 */
class CustomBinarySerializableType extends BinarySerializableType {
  CustomBinarySerializableType() { this.getABaseType*().hasName("ISerializable") }

  /**
   * For custom deserialization, the `BinarySerializer` will call the serialization constructor.
   */
  override Callable getADeserializationCallback() {
    result = super.getADeserializationCallback() or
    result.(SerializationConstructor).getDeclaringType() = this
  }
}

class DangerousCallable extends Callable {
  DangerousCallable() {
    //files
    this.(Method).getQualifiedName().matches("System.IO.File.Write%") or
    this.(Method).getQualifiedName().matches("System.IO.File.%Copy%") or
    this.(Method).getQualifiedName().matches("System.IO.File.%Move%") or
    this.(Method).getQualifiedName().matches("System.IO.File.%Append%") or
    this.(Method).getQualifiedName().matches("System.IO.%.%Delete%") or
    //assembly
    this.(Method).getQualifiedName().matches("System.Reflection.Assembly.%Load%")
  }
}
