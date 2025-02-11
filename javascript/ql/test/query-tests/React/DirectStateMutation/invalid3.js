var Hello = React.createClass({
  render: function() {
    this.state.person.name.first = "bar" // $ TODO-SPURIOUS: Alert
    return <div>Hello</div>;
  }
});
