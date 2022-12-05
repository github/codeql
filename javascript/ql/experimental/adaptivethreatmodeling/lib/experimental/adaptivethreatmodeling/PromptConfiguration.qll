import javascript
private import BaseScoring
import FeaturizationConfig

class PromptConfiguration extends FeaturizationConfig {
  PromptConfiguration() {
    this = "PromptConfiguration"
  }
  // abstract predicate getANodeAndPrompt(DataFlow::Node node, string prompt);

  string getPrompt(DataFlow::Node node) {
    result = "# Examples of security vulnerability sinks and non-sinks\n|Dataflow node|Neighborhood|Classification|\n|---|---|---|\n| `bid` | `const body =   <a href=https://ampbyexample.com target=_blank>    <amp-img alt=AMP Ad height=250 src=//localhost:9876/amp4test/request-bank/${bid}/deposit/image width=300></amp-img>  </a>  <amp-pixel src=//localhost:9876/amp4test/request-bank/${bid}/deposit/pixel/foo?cid=CLIENT_ID(a)></amp-pixel>` | xss sink |\n| `nick` | `irc.me = nick;  irc.nick(nick); irc.user(username, realname);` | non-sink || `hash` | `componentDidMount() {    const [, hash] = location.href.split(#)    this.setState({ hash })  }` | `"
      + extractString(node) + "` | "
  }

  string extractString(DataFlow::Node node) {
    result = node.getStringValue()
  }

  override DataFlow::Node getAnEndpointToFeaturize() {
    getCfg().isEffectiveSource(result) and any(DataFlow::Configuration cfg).hasFlow(result, _)
    or
    getCfg().isEffectiveSink(result) and any(DataFlow::Configuration cfg).hasFlow(_, result)
  }
}
