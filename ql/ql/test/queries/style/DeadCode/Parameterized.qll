signature module EmptySig { }

module Outer<EmptySig E> {
  signature module InputSig {
    default predicate callback() { none() }
  }

  module Make<InputSig Input> {
    predicate useCallback() { Input::callback() }
  }
}
