
image::image(int width, int height)
{
	int x, y;

	// allocate width * height pixels
	pixels = new uint32_t[width * height];

	// fill width * height pixels
	for (y = 0; y < height; y++)
	{
		for (x = 0; x < width; x++)
		{
			pixels[(y * width) + height] = 0;
		}
	}

	// ...
}
