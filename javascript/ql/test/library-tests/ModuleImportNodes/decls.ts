// <reference types="framework2" />
import * as F1_outer from 'framework1';
import * as F2_outer from 'framework2';
import * as net_outer from "net";

declare global {
	var F1: typeof F1_outer
	var F2: typeof F2_outer
	var net: typeof net_outer
}