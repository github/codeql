var Hello = React.createClass({
  render: function() {
    this.state.person.name.first = "bar" // $ Alert
    return <div>Hello</div>;
  }
});
