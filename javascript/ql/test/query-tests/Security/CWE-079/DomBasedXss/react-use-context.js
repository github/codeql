import { useContext } from 'react';
import { MyContext } from './react-create-context';

function useMyContext() {
    return useContext(MyContext);
}

export function useDoc1() {
    let { root } = useMyContext();
    root.appendChild(window.name); // NOT OK
}
