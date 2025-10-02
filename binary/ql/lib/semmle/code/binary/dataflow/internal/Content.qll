private import codeql.util.Void
private import binary
private import DataFlowImpl

abstract class Content extends TContent {
  abstract string toString();

  abstract Location getLocation();
}

abstract class ContentSet extends TContentSet {
  abstract string toString();

  abstract Content getAStoreContent();

  abstract Content getAReadContent();
}

class TContent = Void;
