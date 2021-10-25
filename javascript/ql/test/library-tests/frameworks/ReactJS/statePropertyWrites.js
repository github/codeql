class Writes extends React.Component {
    constructor() {
        var cmp = this;
        cmp.state.p1 = 42;

        cmp.state.bar.foo = 42; // not a state write (but implies existence of `bar`)

        var o1 = {};
        o1.p2 = 42
        cmp.state = o1;

        var o2 = {};
        o2.p3 = 42;
        cmp.setState(o2);

        var o3 = {};
        o3.p4 = 42;
        cmp.setState(() => o3);

        var o4 = {};
        o4.p5 = 42;
        cmp.forceUpdate(() => o4);
    }

    getInitialState() { // not enabled for ES6 classes
        var o = {};
        o.p6 = 42
        return o;
    }

    state = {
        p7: 42
    };
}

React.createClass({
  render: function() {
    return <div>Hello {this.props.name}</div>;
  },
  getInitialState: function() {
    return {
      p8: 42
    };
  }
});
