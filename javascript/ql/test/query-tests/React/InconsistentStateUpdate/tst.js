class C1 extends React.Component {
  upd8() {
    this.setState({
      counter: this.state.counter + 1 // $ TODO-MISSING: Alert - but ignored because it is safe in practice
    });
  }
}

class C2 extends React.Component {
  upd8() {
    this.setState((prevState) => {
      counter: prevState.counter + 1
    });
  }
}

class C3 extends React.Component {
  upd8() {
    var app = this;
    app.setState({
      counter: this.state.counter + 1 // $ TODO-MISSING: Alert - but ignored because it is safe in practice
    });
  }
}

class C4 extends React.Component {
  upd8() {
    this.setState({
      counter: this.state.foo // $ TODO-MISSING: Alert
    }); // $ TODO-SPURIOUS: Alert
  }
}

class C5 extends React.Component {
  upd8() {
    this.setState({
        foo: { bar: this.state.foo.bar } // $ TODO-MISSING: Alert
    }); // $ TODO-SPURIOUS: Alert
  }
}

class C7 extends React.Component {
    upd8a() {
        this.setState({
            foo: this.state.foo // $ TODO-MISSING: Alert
        }); // $ TODO-SPURIOUS: Alert
    }

    upd8b() {
        this.setState({
            foo: this.state.foo // $ TODO-MISSING: Alert
        }); // $ TODO-SPURIOUS: Alert
    }
}

class C8 extends React.Component {
    upd8a() {
        this.setState({
            foo: this.state.foo + 1 // $ TODO-MISSING: Alert
        }); // $ TODO-SPURIOUS: Alert
    }

    upd8b() {
        this.setState({
            foo: this.state.foo + 1 // $ TODO-MISSING: Alert
        }); // $ TODO-SPURIOUS: Alert
    }
}

class C9 extends React.Component {
    upd8a() {
        this.setState({
            foo: { bar: this.state.foo.bar } // $ TODO-MISSING: Alert
        }); // $ TODO-SPURIOUS: Alert
    }

    upd8b() {
        this.setState({
            foo: { bar: this.state.foo.bar } // $ TODO-MISSING: Alert
        }); // $ TODO-SPURIOUS: Alert
    }
}

class C10 extends React.Component {
    upd8a() {
        this.setState({
            foo: this.state.foo, // $ TODO-MISSING: Alert
            bar: this.state.bar // $ TODO-MISSING: Alert - but ignored because it is safe in practice
        }); // $ TODO-SPURIOUS: Alert
    }

    upd8b() {
        this.setState({
            foo: this.state.foo // $ TODO-MISSING: Alert
        }); // $ TODO-SPURIOUS: Alert
    }
}

class C11 extends React.Component {
    upd8a() {
        var self = this;
        self.setState({
            foo: self.state.foo // $ TODO-MISSING: Alert
        }); // $ TODO-SPURIOUS: Alert
    }

    upd8b() {
        this.setState({
            foo: this.state.foo // $ TODO-MISSING: Alert
        }); // $ TODO-SPURIOUS: Alert
    }
}
