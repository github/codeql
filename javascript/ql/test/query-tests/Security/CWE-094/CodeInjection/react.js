import React, { use } from "react";
import {Helmet} from "react-helmet";
import { echoService } from "./react-server-function";

class Application extends React.Component {
  render () {
    return (
        <div className="application">
            <Helmet>
                <title>My unsafe</title>
                <script type="application/javascript">{document.location.hash}</script> {/* $ Alert[js/code-injection] */}
            </Helmet>
        </div>
    );
  }
};

export default Application

export function Component() {
  // We currently get false-positive flow through server functions in cases where a safe value
  // is passed as the argument, which flows to the return value. In this case, the tainted parameter
  // flows out of the return value regardless.
  const data = use(echoService("safe value"));
  eval(data); // $ SPURIOUS: Alert[js/code-injection]
}
