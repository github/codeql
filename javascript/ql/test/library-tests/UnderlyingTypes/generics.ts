import * as express from 'express';

type Box1<T> = {
    value: T;
    other: string;
};
function t1(b: Box1<express.Request>) {
    b.value; // $ MISSING: hasUnderlyingType='express'.Request
    b.other;
}

interface Box2<T> {
    value: T;
    other: string;
}
function t2(b: Box2<express.Request>) {
    b.value; // $ MISSING: hasUnderlyingType='express'.Request
    b.other;
}

class Box3<T> {
    value: T;
    other: string;
}
function t3(b: Box3<express.Request>) {
    b.value; // $ MISSING: hasUnderlyingType='express'.Request
    b.other;
}

abstract class Box4<T> {
    abstract getValue(): T;
    abstract getOther(): string;
}
function t4(b: Box4<express.Request>) {
    b.getValue(); // $ MISSING: hasUnderlyingType='express'.Request
    b.getOther();
}

type Box5<T> = {
    value: T & { blah: string };
    other: string;
};
function t5(b: Box5<express.Request>) {
    b.value; // $ MISSING: hasUnderlyingType='express'.Request
    b.other;
}
