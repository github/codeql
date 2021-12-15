import java

class XmlPullParser extends Interface {
  XmlPullParser() { this.hasQualifiedName("org.xmlpull.v1", "XmlPullParser") }
}

class XmlPullGetMethod extends Method {
  XmlPullGetMethod() {
    this.getDeclaringType() instanceof XmlPullParser and
    this.getName().matches("get%")
  }
}

class XmlAttrSet extends Interface {
  XmlAttrSet() { this.hasQualifiedName("android.util", "AttributeSet") }
}

class XmlAttrSetGetMethod extends Method {
  XmlAttrSetGetMethod() {
    this.getDeclaringType() instanceof XmlAttrSet and
    this.getName().matches("get%")
  }
}
