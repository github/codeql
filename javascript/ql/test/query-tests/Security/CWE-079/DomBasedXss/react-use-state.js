import { useState } from 'react';

function initialState() {
    let [state, setState] = useState(window.name); // $ Source
    return <div dangerouslySetInnerHTML={{__html: state}}></div>; // $ Alert
}

function setStateValue() {
    let [state, setState] = useState('foo');
    setState(window.name); // $ Source
    return <div dangerouslySetInnerHTML={{__html: state}}></div>; // $ Alert
}

function setStateValueLazy() {
    let [state, setState] = useState('foo');
    setState(() => window.name); // $ Source
    return <div dangerouslySetInnerHTML={{__html: state}}></div>; // $ Alert
}

function setStateValueLazy() {
    let [state, setState] = useState('foo');
    setState(prev => {
        document.body.innerHTML = prev; // $ Alert
    })
    setState(() => window.name); // $ Source
}

function setStateValueSafe() {
    let [state, setState] = useState('foo');
    setState('safe');
    setState(() => 'also safe');
    return <div dangerouslySetInnerHTML={{__html: state}}></div>;
}
