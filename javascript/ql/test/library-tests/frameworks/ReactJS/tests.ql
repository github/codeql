import getADirectStateAccess
import ReactComponent_getInstanceMethod
import react
import ReactComponent_getAPreviousStateSource
import ReactComponent_ref
import ReactComponent_getACandidateStateSource
import ReactComponent_getADirectPropsSource
import ReactComponent_getACandidatePropsValue
import ReactComponent
import ReactComponent_getAPropRead
import ReactName

query DataFlow::SourceNode locationSource() { result = DOM::locationSource() }

query predicate threatModelSource(ThreatModelSource source, string kind) {
  kind = source.getThreatModel()
}
