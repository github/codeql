private import unified
private import AllDataFlow

private newtype TContent = TNamedMember(string name) { name = any(Identifier id).getValue() }

class Content extends TContent {
  string asNamedMember() { this = TNamedMember(result) }

  string toString() { result = this.asNamedMember() }

  Location getLocation() { none() }
}

private newtype TContentSet = TSingleton(Content content)

class ContentSet extends TContentSet {
  Content asSingleton() { this = TSingleton(result) }

  string toString() { result = this.asSingleton().toString() }

  Location getLocation() { result = this.asSingleton().getLocation() }

  Content getAStoreContent() { result = this.asSingleton() }

  Content getAReadContent() { result = this.asSingleton() }
}

module ContentSet {
  ContentSet namedMember(string name) { result.asSingleton().asNamedMember() = name }
}
