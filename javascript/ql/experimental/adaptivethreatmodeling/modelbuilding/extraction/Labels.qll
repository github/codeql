/*
 * For internal use only.
 *
 * Labels used in training and evaluation data to indicate knowledge about whether an endpoint is a
 * sink for a particular security query.
 */

newtype TEndpointLabel =
  TSinkLabel() or
  TNotASinkLabel() or
  TUnknownLabel()

abstract class EndpointLabel extends TEndpointLabel {
  abstract string getEncoding();

  string toString() { result = getEncoding() }
}

class SinkLabel extends EndpointLabel, TSinkLabel {
  override string getEncoding() { result = "Sink" }
}

class NotASinkLabel extends EndpointLabel, TNotASinkLabel {
  override string getEncoding() { result = "NotASink" }
}

class UnknownLabel extends EndpointLabel, TUnknownLabel {
  override string getEncoding() { result = "Unknown" }
}
