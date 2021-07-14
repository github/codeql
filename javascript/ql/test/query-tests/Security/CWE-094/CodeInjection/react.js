import React from "react";
import {Helmet} from "react-helmet";
 
class Application extends React.Component {
  render () {
    return (
        <div className="application">
            <Helmet>
                <title>My unsafe</title>
                <script type="application/javascript">{document.location.hash}</script>
            </Helmet>
        </div>
    );
  }
};

export default Application