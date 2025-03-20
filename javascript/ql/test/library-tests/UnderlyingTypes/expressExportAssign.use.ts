import { Request } from "./expressExportAssign";

function t1(req: Request) { // $ MISSING: hasUnderlyingType='express'.Request SPURIOUS: hasUnderlyingType='expressExportAssign.ts'.Request
}
