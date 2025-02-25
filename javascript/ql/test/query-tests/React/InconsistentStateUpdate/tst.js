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
    this.setState({
      counter: this.state.foo
    }); // $ Alert
  }
}

class C5 extends React.Component {
  upd8() {
    this.setState({
        foo: { bar: this.state.foo.bar }
    }); // $ Alert
  }
}

class C7 extends React.Component {
    upd8a() {
        this.setState({
            foo: this.state.foo
        }); // $ Alert
    }

    upd8b() {
        this.setState({
            foo: this.state.foo
        }); // $ Alert
    }
}

class C8 extends React.Component {
    upd8a() {
        this.setState({
            foo: this.state.foo + 1
        }); // $ Alert
    }

    upd8b() {
        this.setState({
            foo: this.state.foo + 1
        }); // $ Alert
    }
}

class C9 extends React.Component {
    upd8a() {
        this.setState({
            foo: { bar: this.state.foo.bar }
        }); // $ Alert
    }

    upd8b() {
        this.setState({
            foo: { bar: this.state.foo.bar }
        }); // $ Alert
    }
}

class C10 extends React.Component {
    upd8a() {
        this.setState({
            foo: this.state.foo,
            bar: this.state.bar // OK - ignored because it is safe in practice
        }); // $ Alert
    }

    upd8b() {
        this.setState({
            foo: this.state.foo
        }); // $ Alert
    }
}

class C11 extends React.Component {
    upd8a() {
        var self = this;
        self.setState({
            foo: self.state.foo
        }); // $ Alert
    }

    upd8b() {
        this.setState({
            foo: this.state.foo
        }); // $ Alert
    }
}
