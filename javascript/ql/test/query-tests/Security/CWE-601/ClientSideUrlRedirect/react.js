import React from "react";
import {Helmet} from "react-helmet";
 
class Application extends React.Component {
  render () {
    return (
        <div className="application">
            <Helmet>
                <title>My unsafe app</title>
                <script type="application/javascript" src={document.location.hash}/>
            </Helmet>
        </div>
    );
  }
};

export default Application

import Link from 'next/link'
export function NextLink() {
    return <Link href={document.location.hash}><a>this page!</a></Link>;
}