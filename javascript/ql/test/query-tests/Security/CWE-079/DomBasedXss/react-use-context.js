import { useContext, Component } from 'react';
import { MyContext } from './react-create-context';

function useMyContext() {
    return useContext(MyContext);
}

export function useDoc1() {
    let { root } = useMyContext();
    root.appendChild(window.name); // OK -- the function does not accept string arguments
}

class C extends Component {
    foo() {
        let { root } = this.context;
        root.appendChild(window.name); // OK -- the function does not accept string arguments
    }
}

C.contextType = MyContext;
