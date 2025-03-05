class C1 extends React.Component { // $ Alert
    constructor() {
        this.state.readDirectly = 42;
        this.state.readInChain = {};
        this.state.readInOtherMethod = {};
        this.state.notRead = 42; // $ RelatedLocation
        this.state.readDirectly;
        this.state.readInChain.foo;
    }

    otherMethod() {
        this.state.readInOtherMethod;
    }
}

function f(s){
    s.readWhenEscaped;
}
class C2 extends React.Component {
    constructor() {
        this.state.readWhenEscaped = 42;
        f(this.state);
    }
}


class C3 extends React.Component { // $ Alert
    constructor() {
        this.state.readThrougExternaPropertyAccess = 42;
        this.state.notReadThrougExternaPropertyAccess = 42; // $ RelatedLocation
    }
}

new C3().state.readThrougExternaPropertyAccess;

class C4 extends React.Component {
    constructor() {
        function f() { return "readThroughUnknownDynamicPropertyAccess"; }
        this.state.readThroughUnknownDynamicPropertyAccess = 42;
        this.state.notReadThroughUnknownDynamicPropertyAccess = 42; // $ OK - ignored to avoid FP above

        this.state[f()];
    }
}


class C5 extends React.Component {
    constructor() {
        this.state.readThroughSpreadOperator = 42;
        ({...this.state});
    }
}

React.createClass({
    render: function() {
        this.state.readThroughMixin = 42;
        this.state.notReadThroughMixin = 42;  // $ OK - ignored to avoid FP above
        return <h1>Hello</h1>;
    },

    mixins: [{ f: () => this.state.readThroughMixin }]
});

class C6 extends React.Component {

    static getDerivedStateFromProps(p, s) {
        s.readIn_getDerivedStateFromProps;
    }

    constructor() {
        this.state.readIn_getDerivedStateFromProps = 42;
    }

}
