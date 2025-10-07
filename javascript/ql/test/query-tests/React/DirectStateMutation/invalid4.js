var Hello = React.createClass({
  render: function() {
    this.state.person.name.first = "bar" // $ Alert
    this.state.person.name.last = "baz" // $ Alert
    return <div>Hello</div>;
  }
});
