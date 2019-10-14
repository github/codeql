import Serialization

/**
 * A type serializable by the `XmlSerializer` must be public, and it must
 * have a no-argument constructor (which may be the auto-generated default constructor).
 */
class XmlSerializableType extends SerializableType {
  XmlSerializableType() {
    this.isPublic() and
    not this instanceof BinarySerializableType and
    this.getAConstructor().getNumberOfParameters() = 0
  }

  /**
   * XML deserialization will call the no-argument constructor, as well as all public
   * property setters (declared or inherited).
   */
  override Callable getADeserializationCallback() {
    result = any(Constructor c |
        c.getDeclaringType() = this and
        c.getNumberOfParameters() = 0
      ) or
    result = any(Setter s |
        s.getDeclaringType() = this.getABaseType*() and
        s.isPublic()
      )
  }

  /**
   * XML deserialization will write public non-static fields and call public setters,
   * so we also consider fields written by such setters to be deserialized.
   */
  override Field getASerializedField() {
    result.getDeclaringType() = this and
    this.getADeserializationCallback().(Setter) = result.getAnAssignedValue().getEnclosingCallable()
    or
    result = this.getAField() and result.isPublic() and not result.isStatic()
  }
}
