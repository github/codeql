// update variants
React.createClass({
    render: function() {
        this.setState({}); // $ Alert
        this.replaceState({}); // $ Alert
        this.forceUpdate({}); // $ Alert
        return <div/>
    }
});

// indirect call, in ES6 class
class MyClass1 extends React.Component {
    constructor(props) {
        super(props);
    }
    render() {
        this.indirectUpdate(); // $ Alert
        this.veryIndirectUpdate(); // $ Alert
        return <div/>
    }

    indirectUpdate() {
        this.setState({});
    }
    veryIndirectUpdate() {
        this.lessIndirectUpdate();
    }
    lessIndirectUpdate() {
        this.setState({});
    }

}

// definiteness variants
React.createClass({
    render: function() {
        this.setState({}); // $ Alert
    },
    componentDidUpdate: function() {
        this.setState({}); // $ Alert
        if (cond) {
            this.setState({});
        }
    },
    shouldComponentUpdate: function() {
        this.setState({}); // $ Alert
        if (cond) {
            this.setState({});
        }
    },
    componentWillUpdate: function() {
        this.setState({}); // $ Alert
        if (cond) {
            this.setState({});
        }
    }
});

// definiteness and indirect call, in ES6 class
class MyClass2 extends React.Component {
    constructor(props) {
        super(props);
    }

    componentWillUpdate() {
        this.definiteIndirectUpdate(); // $ Alert
        if (cond) {
            this.definiteIndirectUpdate();
        }
        this.indefiniteIndirectUpdate();
        return <div/>
    }

    definiteIndirectUpdate() {
        this.setState({});
    }

    indefiniteIndirectUpdate() {
        if (cond) {
            this.setState({});
        }
    }
}

// aliasing
React.createClass({
    render: function() {
        var app = this;
        app.setState({}); // $ Alert
        return <div/>
    }
});

// indirect, in object literal
React.createClass({
    indirectUpdate: function() {
        this.setState({})
    },
    render: function() {
        this.indirectUpdate(); // $ Alert
        return <div/>
    }
});

// eslint examples
React.createClass({
  componentDidUpdate: function() {
     this.setState({
        name: this.props.name.toUpperCase()
      }); // $ Alert
    },
  render: function() {
    return <div>Hello {this.state.name}</div>;
  }
});
React.createClass({
  componentWillUpdate: function() {
     this.setState({
        name: this.props.name.toUpperCase()
      }); // $ Alert
    },
  render: function() {
    return <div>Hello {this.state.name}</div>;
  }
});

// Most SO examples: early invoked event handler
class Search extends React.Component {

    constructor() {
        super();
        this.handleButtonChange = this.handleButtonChange.bind(this);
    }

    handleButtonChange() {
        this.setState({});
    }

    render() {
        return (
                <Button onClick={this.handleButtonChange()} ></Button> // $ Alert
        );
    }
}

// less serious variants
class MyClass3 extends React.Component {
    constructor(props) {
        super(props);
        this.setState({}); // $ Alert
    }
    componentDidUnmount() {
        this.setState({}); // $ Alert
    }
    getDefaultProps() {
        this.setState({}); // $ Alert
    }
    getInitialState() {
        this.setState({}); // $ Alert
    }
    componentWillUnmount() {
        this.setState({});
    }
    componentWillMount() {
        this.setState({});
    }
    componentDidMount() {
        this.setState({});
    }
}

// arrow functions
class MyClass4 extends React.Component {
    constructor(props) {
        super(props);
    }
    myUpdate() {
        this.setState();
    }
    render() {
        var doUpdate1 = () => this.setState({});
        var doUpdate2 = () => this.myUpdate();
        var doUpdate3 = () => {
            var doUpdate4 = () => this.myUpdate();
            doUpdate4();
        }
        doUpdate1(); // $ Alert
        doUpdate2(); // $ Alert
        doUpdate3(); // $ Alert
    }
}
