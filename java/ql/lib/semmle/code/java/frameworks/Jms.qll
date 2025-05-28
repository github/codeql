/** Provides definitions for working with the JMS library. */
overlay[local?]
module;

import java

/** The method `ObjectMessage.getObject`. */
class ObjectMessageGetObjectMethod extends Method {
  ObjectMessageGetObjectMethod() {
    this.hasQualifiedName(["javax", "jakarta"] + ".jms", "ObjectMessage", "getObject")
  }
}
