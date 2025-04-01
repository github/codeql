import { NextRequest, NextResponse } from 'next/server';

export async function POST(req: NextRequest) {
  const data = await req.json(); // $ Source
  new NextResponse(data, {headers: { 'Content-Type': 'text/html' }});  // $ Alert
  return new NextResponse(data, { headers: req.headers });  // $ Alert
}
