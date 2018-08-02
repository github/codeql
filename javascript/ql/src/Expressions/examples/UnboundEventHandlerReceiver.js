class Toggle extends React.Component {
  constructor(props) {
    super(props);
    this.state = {isToggleOn: true};
  }

  handleClick() {
    this.setState(prevState => ({
      isToggleOn: !prevState.isToggleOn
    }));
  }

  render() {
    return (
      <button onClick={this.handleClick}> // BAD `this` is now undefined in `handleClick`
        {this.state.isToggleOn ? 'ON' : 'OFF'}
      </button>
    );
  }
}
