import React from 'react';
import ReactDOM from 'react-dom';
import ReactTooltip from 'react-tooltip';

function tooltips() {
    const source = window.name;
    return <span>
        <span data-tip={source}/> // OK
        <span data-tip={source} data-html={false} /> // OK
        <span data-tip={source} data-html="true" /> // NOT OK
        <span data-tip={source} data-html={true} /> // NOT OK
        <ReactTooltip />
    </span>
}

function MyElement(props) {
    const provide = props.provide;
    return <div dangerouslySetInnerHTML={{__html: provide()}} />; // NOT OK
}

function useMyElement() {
    const source = window.name;
    return <MyElement provide={() => source} />;
}