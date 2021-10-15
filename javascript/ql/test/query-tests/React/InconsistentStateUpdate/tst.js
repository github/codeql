class C1 extends React.Component {
  upd8() {
    this.setState({
      counter: this.state.counter + 1 // NOT OK, but ignored because it is safe in practice
    });
  }
}

class C2 extends React.Component {
  upd8() {
    this.setState((prevState) => {
      counter: prevState.counter + 1 // OK
    });
  }
}

class C3 extends React.Component {
  upd8() {
    var app = this;
    app.setState({
      counter: this.state.counter + 1 // NOT OK, but ignored because it is safe in practice
    });
  }
}

class C4 extends React.Component {
  upd8() {
    this.setState({
      counter: this.state.foo // NOT OK
    });
  }
}

class C5 extends React.Component {
  upd8() {
    this.setState({
        foo: { bar: this.state.foo.bar } // NOT OK
    });
  }
}

class C7 extends React.Component {
    upd8a() {
        this.setState({
            foo: this.state.foo // NOT OK
        });
    }

    upd8b() {
        this.setState({
            foo: this.state.foo // NOT OK
        });
    }
}

class C8 extends React.Component {
    upd8a() {
        this.setState({
            foo: this.state.foo + 1 // NOT OK
        });
    }

    upd8b() {
        this.setState({
            foo: this.state.foo + 1 // NOT OK
        });
    }
}

class C9 extends React.Component {
    upd8a() {
        this.setState({
            foo: { bar: this.state.foo.bar } // NOT OK
        });
    }

    upd8b() {
        this.setState({
            foo: { bar: this.state.foo.bar } // NOT OK
        });
    }
}

class C10 extends React.Component {
    upd8a() {
        this.setState({
            foo: this.state.foo, // NOT OK
            bar: this.state.bar // NOT OK, but ignored because it is safe in practice
        });
    }

    upd8b() {
        this.setState({
            foo: this.state.foo // NOT OK
        });
    }
}

class C11 extends React.Component {
    upd8a() {
        var self = this;
        self.setState({
            foo: self.state.foo // NOT OK
        });
    }

    upd8b() {
        this.setState({
            foo: this.state.foo // NOT OK
        });
    }
}
