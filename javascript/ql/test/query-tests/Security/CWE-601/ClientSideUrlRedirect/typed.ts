export class MyComponent {
    componentDidMount() {
        const { location }: { location: Location } = (this as any).props;
        var params = location.search.substring(1);
        this.doRedirect(params);
    }
    private doRedirect(redirectUri: string) {
        window.location.replace(redirectUri); // NOT OK
    }
}

export class MyTrackingComponent {
    componentDidMount() {
        const { location }: { location: Location } = (this as any).props; // location source

        var container = {
            loc: location
        };
        var secondLoc = container.loc; // type-tracking step 1 - not the source

        this.myIndirectRedirect(secondLoc);
    }

    private myIndirectRedirect(loc) { // type-tracking step 2 - also not the source
        this.doRedirect(loc.search.substring(1));
    }

    private doRedirect(redirectUri: string) {
        window.location.replace(redirectUri); // NOT OK
    }
}

export class WeirdTracking {
    componentDidMount() {
        const { location }: { location: Location } = (this as any).props; // location source

        var container = {
            loc: location
        };
        var secondLoc = container.loc; // type-tracking step 1 - not the source

        this.myIndirectRedirect(secondLoc);
    }

    private myIndirectRedirect(loc) { // type-tracking step 2 - also not the source
        const loc2: Location = (loc as any).componentDidMount;
        this.doRedirect(loc.search.substring(1));
        this.doRedirect2(loc2.search.substring(1));
    }

    private doRedirect(redirectUri: string) {
        window.location.replace(redirectUri); // NOT OK
    }

    private doRedirect2(redirectUri: string) {
        window.location.replace(redirectUri); // NOT OK
    }
}
