
import type {
  NextApiRequest,
  NextApiResponse,
} from "next"

export async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
    res.setHeader("Location", req.body.callbackUrl); // $ Alert
}