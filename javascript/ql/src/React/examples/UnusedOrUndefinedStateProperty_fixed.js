class Clock extends React.Component {
    constructor(props) {
        super(props);
        this.state = { date: new Date() };
    }

    render() {
         // GOOD: this.state.date is defined above
        var now = this.state.date.toLocaleTimeString()
        return (
                <div>
                <h2>The time is {now}.</h2>
                </div>
        );
    }
}
