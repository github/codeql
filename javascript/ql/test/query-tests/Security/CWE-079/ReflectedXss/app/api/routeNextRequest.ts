import { NextRequest, NextResponse } from 'next/server';

export async function POST(req: NextRequest) {
  const data = await req.json(); // $ MISSING: Source
  new NextResponse(data, {headers: { 'Content-Type': 'text/html' }});  // $ MISSING: Alert
  return new NextResponse(data, { headers: req.headers });  // $ MISSING: Alert
}
