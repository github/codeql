type Mapped<MK extends string = ''> = {
        [mk in MK]: string
    };

export function fn(ev: Mapped) {
    const props: Mapped = {
        ...ev
    };
}
