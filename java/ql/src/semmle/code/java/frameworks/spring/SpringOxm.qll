import java

/**
 * The class `org.springframework.oxm.xstream.XStreamMarshaller`.
 */
class XStreamMarshaller extends RefType {
  XStreamMarshaller() {
    this.hasQualifiedName("org.springframework.oxm.xstream", "XStreamMarshaller")
  }
}

/**
 * A XStreamMarshaller unmarshal method, declared on either `unmarshalInputStream` or `unmarshalReader`.
 */
class XStreamMarshallerUnmarshalMethod extends Method {
  XStreamMarshallerUnmarshalMethod() {
    this.getDeclaringType() instanceof XStreamMarshaller and
    this.getName() in ["unmarshalInputStream", "unmarshalReader"]
  }
}
