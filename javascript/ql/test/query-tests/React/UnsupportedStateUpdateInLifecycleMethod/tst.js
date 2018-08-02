// update variants
React.createClass({
    render: function() {
        this.setState({}); // NOT OK
        this.replaceState({}); // NOT OK
        this.forceUpdate({}); // NOT OK
        return <div/>
    }
});

// indirect call, in ES6 class
class MyClass1 extends React.Component {
    constructor(props) {
        super(props);
    }
    render() {
        this.indirectUpdate(); // NOT OK
        this.veryIndirectUpdate(); // NOT OK
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
        this.setState({}); // NOT OK
    },
    componentDidUpdate: function() {
        this.setState({}); // NOT OK
        if (cond) {
            this.setState({}); // OK
        }
    },
    shouldComponentUpdate: function() {
        this.setState({}); // NOT OK
        if (cond) {
            this.setState({}); // OK
        }
    },
    componentWillUpdate: function() {
        this.setState({}); // NOT OK
        if (cond) {
            this.setState({}); // OK
        }
    }
});

// definiteness and indirect call, in ES6 class
class MyClass2 extends React.Component {
    constructor(props) {
        super(props);
    }

    componentWillUpdate() {
        this.definiteIndirectUpdate(); // NOT OK
        if (cond) {
            this.definiteIndirectUpdate(); // OK
        }
        this.indefiniteIndirectUpdate(); // OK
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
        app.setState({}); // NOT OK
        return <div/>
    }
});

// indirect, in object literal
React.createClass({
    indirectUpdate: function() {
        this.setState({})
    },
    render: function() {
        this.indirectUpdate();
        return <div/>
    }
});

// eslint examples
React.createClass({
  componentDidUpdate: function() {
     this.setState({ // NOT OK
        name: this.props.name.toUpperCase()
      });
    },
  render: function() {
    return <div>Hello {this.state.name}</div>;
  }
});
React.createClass({
  componentWillUpdate: function() {
     this.setState({ // NOT OK
        name: this.props.name.toUpperCase()
      });
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
                <Button onClick={this.handleButtonChange()} ></Button> // NOT OK
        );
    }
}

// less serious variants
class MyClass3 extends React.Component {
    constructor(props) {
        super(props);
        this.setState({}); // NOT OK
    }
    componentDidUnmount() {
        this.setState({}); // NOT OK
    }
    getDefaultProps() {
        this.setState({}); // NOT OK
    }
    getInitialState() {
        this.setState({}); // NOT OK
    }
    componentWillUnmount() {
        this.setState({}); // OK
    }
    componentWillMount() {
        this.setState({}); // OK
    }
    componentDidMount() {
        this.setState({}); // OK
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
        doUpdate1(); // NOT OK
        doUpdate2(); // NOT OK
        doUpdate3(); // NOT OK
    }
}
