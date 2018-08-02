import React from 'react';

class Component extends React.Component {
    constructor(props) {
        super(props);
        this.bound_throughBindInConstructor = this.bound_throughBindInConstructor.bind(this);
        this.bound_throughBizarreBind = foo.bar.bind(baz);
        var cmp = this;
        var bound = (cmp.bound_throughNonSyntacticBindInConstructor.bind(this));
        (cmp).bound_throughNonSyntacticBindInConstructor = bound;
    }

    unbound1() {
        this.setState({ });
    }

    unbound2() {
        () => this.setState({ });
    }

    unbound3() {
        () => this.setState({ });
    }

    bound_throughBindInConstructor() {
        this.setState({ });
    }

    bound_throughNonSyntacticBindInConstructor() {
        this.setState({ });
    }

    bound_throughBizzareBind() {
        this.setState({ });
    }

    bound_throughDeclaration = () => {
        this.setState({ });
    }

    unbound_butNoThis1() {

    }

    unbound_butNoThis2() {
        (function(){ this.setState({ })});
    }

    unbound_butInvokedSafely() {
        this.setState({ });
    }

    render() {
        var unbound3 = this.unbound3;
        return <div>
            <div onClick={this.unbound1}/> // NOT OK
            <div onClick={this.unbound2}/> // NOT OK
            <div onClick={unbound3}/> // NOT OK
            <div onClick={this.bound_throughBindInConstructor}/> // OK
            <div onClick={this.bound_throughDeclaration}/> // OK
            <div onClick={this.unbound_butNoThis}/> // OK
            <div onClick={this.unbound_butNoThis2}/> // OK
            <div onClick={(e) => this.unbound_butInvokedSafely(e)}/> // OK
            <div onClick={this.bound_throughBindInMethod}/> // OK
            <div onClick={this.bound_throughNonSyntacticBindInConstructor}/> // OK
            </div>
    }

    componentWillMount() {
        this.bound_throughBindInMethod = this.bound_throughBindInMethod.bind(this);
    }

    bound_throughBindInMethod() {
        this.setState({ });
    }

}

// semmle-extractor-options: --experimental
