import SomeComponent from './higherOrderComponent';
import { lazy } from 'react';

function foo() {
    return <SomeComponent color="red"/>
}

const LazyLoadedComponent = lazy(() => import('./higherOrderComponent'));

function bar() {
    return <LazyLoadedComponent color="lazy"/>
}

const LazyLoadedComponent2 = lazy(() => import('./exportedComponent').then(m => m.MyComponent));

function barz() {
    return <LazyLoadedComponent2 color="lazy2"/>
}
