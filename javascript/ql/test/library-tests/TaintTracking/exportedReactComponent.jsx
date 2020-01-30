export function UnsafeReactComponent(props) {
    sink(props.text);
    return <div/>
}
