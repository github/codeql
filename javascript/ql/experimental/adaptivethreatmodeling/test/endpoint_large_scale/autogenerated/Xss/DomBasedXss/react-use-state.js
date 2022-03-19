import { useState } from 'react';

function initialState() {
    let [state, setState] = useState(window.name);
    return <div dangerouslySetInnerHTML={{__html: state}}></div>; // NOT OK
}

function setStateValue() {
    let [state, setState] = useState('foo');
    setState(window.name);
    return <div dangerouslySetInnerHTML={{__html: state}}></div>; // NOT OK
}

function setStateValueLazy() {
    let [state, setState] = useState('foo');
    setState(() => window.name);
    return <div dangerouslySetInnerHTML={{__html: state}}></div>; // NOT OK
}

function setStateValueLazy() {
    let [state, setState] = useState('foo');
    setState(prev => {
        document.body.innerHTML = prev; // NOT OK
    })
    setState(() => window.name);
}

function setStateValueSafe() {
    let [state, setState] = useState('foo');
    setState('safe');
    setState(() => 'also safe');
    return <div dangerouslySetInnerHTML={{__html: state}}></div>; // OK
}
