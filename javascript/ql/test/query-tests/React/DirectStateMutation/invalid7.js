class Component extends React.Component {
    constructor(props) {
        super(props);
        this.state = {};
        this.updater = function(){this.state.title = 'new title';};
    }
}
