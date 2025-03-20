import { Request, Response, wrapper } from './expressWrapperExport';
import * as w from './expressWrapperExport';

function t1(req: Request) { // $ SPURIOUS: hasUnderlyingType='expressWrapperExport.ts'.Request - none
}

function t2(res: Response) { // $ SPURIOUS: hasUnderlyingType='expressWrapperExport.ts'.Response - none
}

function t3(req: wrapper.Request) { // $ MISSING: hasUnderlyingType='express'.Request
}

function t4(res: wrapper.Response) { // $ MISSING: hasUnderlyingType='express'.Response
}

function t5(req: w.wrapper.Request) { // $ MISSING: hasUnderlyingType='express'.Request
}

function t6(res: w.wrapper.Response) { // $ MISSING: hasUnderlyingType='express'.Response
}

function t7(req: w.Request) { // $ SPURIOUS: hasUnderlyingType='expressWrapperExport.ts'.Request - none
}

function t8(res: w.Response) { // $ SPURIOUS: hasUnderlyingType='expressWrapperExport.ts'.Response - none
}

function t9(e: typeof w.wrapper) { // $ MISSING: hasUnderlyingType='express'
}
