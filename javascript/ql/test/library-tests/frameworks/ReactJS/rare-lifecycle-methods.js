class C extends React.Component {
    static getDerivedStateFromProps(props, state) {
        return {};
    }
    shouldComponentUpdate(nextProps, nextState) {
        return true;
    }
    getSnapshotBeforeUpdate(prevProps, prevState) {
        return {};
    }
}
