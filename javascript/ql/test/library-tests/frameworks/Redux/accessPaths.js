import { useSelector } from 'react-redux';

function useSelectorWrapped(fn) {
    return useSelector(fn);
}

function MyComponent(props) {
    const x1 = useSelectorWrapped(state => state.x1);
    const x2 = useSelectorWrapped(state => state.x2);
    const x3 = useSelectorWrapped(state => state.x3);
    const x4 = useSelectorWrapped(state => state.x4);
    const x5 = useSelectorWrapped(state => state.x5);

    return <span>X</span>;
}
