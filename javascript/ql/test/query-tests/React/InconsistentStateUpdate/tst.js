class C1 extends React.Component {
  upd8() {
    this.setState({
      counter: this.state.counter + 1 // OK - ignored because it is safe in practice
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
      counter: this.state.counter + 1 // OK - ignored because it is safe in practice
    });
  }
}

class C4 extends React.Component {
  upd8() {
    this.setState({ // $ Alert
      counter: this.state.foo
    });
  }
}

class C5 extends React.Component {
  upd8() {
    this.setState({ // $ Alert
        foo: { bar: this.state.foo.bar }
    });
  }
}

class C7 extends React.Component {
    upd8a() {
        this.setState({ // $ Alert
            foo: this.state.foo
        });
    }

    upd8b() {
        this.setState({ // $ Alert
            foo: this.state.foo
        });
    }
}

class C8 extends React.Component {
    upd8a() {
        this.setState({ // $ Alert
            foo: this.state.foo + 1
        });
    }

    upd8b() {
        this.setState({ // $ Alert
            foo: this.state.foo + 1
        });
    }
}

class C9 extends React.Component {
    upd8a() {
        this.setState({ // $ Alert
            foo: { bar: this.state.foo.bar }
        });
    }

    upd8b() {
        this.setState({ // $ Alert
            foo: { bar: this.state.foo.bar }
        });
    }
}

class C10 extends React.Component {
    upd8a() {
        this.setState({ // $ Alert
            foo: this.state.foo,
            bar: this.state.bar // OK - ignored because it is safe in practice
        });
    }

    upd8b() {
        this.setState({ // $ Alert
            foo: this.state.foo
        });
    }
}

class C11 extends React.Component {
    upd8a() {
        var self = this;
        self.setState({ // $ Alert
            foo: self.state.foo
        });
    }

    upd8b() {
        this.setState({ // $ Alert
            foo: this.state.foo
        });
    }
}
