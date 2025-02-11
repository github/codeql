var Hello = React.createClass({
  render: function() {
    this.state.person.name.first = "bar" // $ TODO-SPURIOUS: Alert
    this.state.person.name.last = "baz" // $ TODO-SPURIOUS: Alert
    return <div>Hello</div>;
  }
});
