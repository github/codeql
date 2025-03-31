import { NextRequest, NextResponse } from 'next/server';

export async function POST(req: NextRequest) {
  const { url } = await req.json(); // $ MISSING: Source[js/request-forgery]
  const res = await fetch(url); // $ MISSING: Alert[js/request-forgery] Sink[js/request-forgery]
  const data = await res.text();
  return new NextResponse(data, { headers: res.headers });
}
