class Clock extends React.Component {
    constructor(props) {
        super(props);
        this.state = { };
    }

    render() {
         // BAD: this.state.date is undefined
        var now = this.state.date.toLocaleTimeString();
        return (
                <div>
                <h2>The time is {now}.</h2>
                </div>
        );
    }
}
