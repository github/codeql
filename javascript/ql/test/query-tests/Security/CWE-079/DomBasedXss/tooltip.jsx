import React from 'react';
import ReactDOM from 'react-dom';
import ReactTooltip from 'react-tooltip';

function tooltips() {
    const source = window.name; // $ Source
    return <span>
        <span data-tip={source}/>
        <span data-tip={source} data-html={false} />
        <span data-tip={source} data-html="true" /> { /* $ Alert */ }
        <span data-tip={source} data-html={true} /> { /* $ Alert */ }
        <ReactTooltip />
    </span>
}

function MyElement(props) {
    const provide = props.provide;
    return <div dangerouslySetInnerHTML={{__html: provide()}} />; // $ Alert
}

function useMyElement() {
    const source = window.name; // $ Source
    return <MyElement provide={() => source} />;
}