class MyComponent extends React.Component {

    constructor(props) {
        super(props)
        this.setState({
            counter: 0
        })

    }

    render() {
        return <div>{this.state.counter}</div>
    }

}
