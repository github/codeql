private import Accessor

final class WillSetObserver extends Accessor {
  WillSetObserver() { this.isWillSet() }
}

class DidSetObserver extends Accessor {
  DidSetObserver() { this.isDidSet() }
}
