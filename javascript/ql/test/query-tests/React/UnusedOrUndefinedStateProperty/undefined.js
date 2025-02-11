class C1 extends React.Component {
    constructor() {
        this.state.writtenDirectly = 42;
        this.setState({
            writtenInSetState: 42
        });
        this.state.writtenInOtherMethod;
        this.state.notWritten; // $ TODO-MISSING: Alert
        this.state.notWrittenButReadInChain; // $ TODO-MISSING: Alert
        this.state.writtenDirectly;
        this.state.writtenInSetState;

    }

    otherMethod() {
        this.state.writtenInOtherMethod = 42;
    }
}

class C2 extends React.Component {
    constructor() {
        function f(s){
            s.writtenWhenEscaped = 42;
        }
        f(this.state);
        this.state.writtenWhenEscaped;
        this.state.notWrittenWhenEscaped; // $ TODO-MISSING: Alert - but ignored to avoid FP above
    }
}


class C3 extends React.Component {
    constructor() {
        this.state.writtenThrougExternalPropertyAccess;
        this.state.notWrittenThrougExternalPropertyAccess; // $ TODO-MISSING: Alert
    }
}

new C3().state.writtenThrougExternalPropertyAccess = 42;

class C4 extends React.Component {
    constructor() {
        function f(){
            return { writtenInUnknownInitializerObject: 42 };
        }
        this.state = f();
        this.state.writtenInUnknownInitializerObject;
        this.state.notWrittenInUnknownInitializerObject; // $ TODO-MISSING: Alert - but ignored to avoid FP above
    }
}

class C5 extends React.Component {
    constructor(x) {
        this.state = x;
        this.state.writtenInUnknownInitializerObject;
        this.state.notWrittenInUnknownInitializerObject; // $ TODO-MISSING: Alert - but ignored to avoid FP above
    }
}
new C5({writtenInUnknownInitializerObject: 42});

React.createClass({ // $ TODO-SPURIOUS: Alert
    render: function() {
        this.state.writtenInKnownInitializerObject;
        this.state.notWrittenInKnownInitializerObject; // $ TODO-MISSING: Alert
        return <div/>;
  },
  getInitialState: function() {
      return { writtenInKnownInitializerObject: 42 };
  }
});

React.createClass({
    render: function() {
        function f(){
            return { writtenInUnknownInitializerObject: 42 };
        }
        this.state.writtenInUnknownInitializerObject;
        this.state.notWrittenInUnknownInitializerObject; // $ TODO-MISSING: Alert - but ignored to avoid FP above
        return <div/>;
  },
  getInitialState: function() {
    return f();
  }
});

class C6 extends React.Component {
    constructor(x) {
        Object.assign(this.state, {writtenInObjectAssign: 42});
        this.state.writtenInObjectAssign;
        this.state.notWrittenInObjectAssign; // $ TODO-MISSING: Alert - but ignored to avoid FP above
    }
}

class C6 extends React.Component {
    constructor(x) {
        function f(){
            return { writtenInSetState: 42 };
        }
        this.state.writtenSetState;
        this.state.notWrittenSetState; // $ TODO-MISSING: Alert - but ignored to avoid FP above
        this.setState(f());
    }
}

class C7 extends React.Component {
    constructor(x) {
        function f(){
            return { writtenInSetState: 42 };
        }
        this.state.writtenInSetState;
        this.setState(f);
    }
}

class C8 extends React.Component {
    constructor(x) {
        function f() {
            return g();
        }
        function g() {
            return { writtenInSetState: 42 }
        }
        this.state.writtenInSetState;
        this.state.notInWrittenSetState; // $ TODO-MISSING: Alert - but ignored to avoid FP above
        this.setState(f());
    }
}

class C9 extends React.Component {
    constructor() {
        function f() { return "readThroughUnknownDynamicPropertyAccess"; }
        this.state[f()] = 42;

        this.state.writtenThroughUnknownDynamicPropertyAccess;
        this.state.notWrittenThroughUnknownDynamicPropertyAccess; // $ TODO-MISSING: Alert - but ignored to avoid FP above

    }
}

class C10 extends React.Component {
    constructor() {
        var x = { writtenThroughUnknownSpreadAccess: 42 };
        this.state = { ...x };
        this.state.writtenThroughUnknownSpreadAccess;
        this.state.notWrittenThroughUnknownSpreadAccess // $ TODO-MISSING: Alert - but ignored to avoid FP above
    }
}

React.createClass({
    render: function() {
        this.state.writtenThroughMixin;
        this.state.notWrittenThroughMixin;  // $ TODO-MISSING: Alert - but ignored to avoid FP above
        return <h1>Hello</h1>;
    },

    mixins: [{ f: () => this.state.writtenThroughMixin = 42 }]
});

class C11 extends React.Component {

    static getDerivedStateFromProps(p, s) {
        return { writeIn_getDerivedStateFromProps};
    }

    otherMethod() {
        this.state.writeIn_getDerivedStateFromProps;
    }
}
