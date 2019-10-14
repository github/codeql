import Serialization

/**
 * Add indirectly referenced callbacks and serialized fields to a given
 * serializable type.
 */
library class IndirectlyDeserializedType extends SerializableType {
  IndirectlyDeserializedType() { this instanceof SerializableType }

  /**
   * The newly contributed callbacks are those of serializable fields' own
   * serializable types.
   */
  override Callable getADeserializationCallback() {
    result = this.getASerializedField().getType().(SerializableType).getADeserializationCallback()
  }

  /**
   * The newly contributed serializable fields are the serializable fields
   * of existing serializable fields.
   */
  override Field getASerializedField() {
    result = this.getASerializedField().getType().(SerializableType).getASerializedField()
  }
}
