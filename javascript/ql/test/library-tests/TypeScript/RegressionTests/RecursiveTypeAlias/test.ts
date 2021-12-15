import { ArrayBox, Box } from 'somewhere';

type Disjunction<T> =
    T extends ArrayBox<infer U1> ? U1[] :
    T extends Box<infer U2> ? U2 :
    T extends ({[P in keyof T]: T[P]} & {p: any}) ? {[P in Exclude<keyof T, 'p'>]: Disjunction<T[P]>} :
    T;

export type Triple<T> = Disjunction<Disjunction<Disjunction<T>>>;
