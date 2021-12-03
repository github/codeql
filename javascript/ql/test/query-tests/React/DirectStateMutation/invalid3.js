var Hello = React.createClass({
  render: function() {
    this.state.person.name.first = "bar"
    return <div>Hello</div>;
  }
});
