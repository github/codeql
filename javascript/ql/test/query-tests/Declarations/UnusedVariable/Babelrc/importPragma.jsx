import { h } from 'preact'; // OK - JSX element uses 'h' after babel compilation
import { q } from 'preact'; // NOT OK - not used 

export default (<div>Hello</div>);
