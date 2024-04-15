
# write a frame to the screen.
# Interpolate values based on percent
def interpolate_frame(screen, pcnt, grid, line):
    """ Interpolate new values by reading from grid and
         writing to the screen """
    # each row interpolates with the one before it
    for y in range(DISPLAY_HEIGHT-1, 0, -1):
        for x in range(DISPLAY_WIDTH):
            mask = MASK[y][x]
            newval = ((100-pcnt) * grid[y][x] + pcnt * grid[y-1][x] ) / 100.0
            newval = mask * newval / 100.0
            if INVERT_DISPLAY:
                screen.set_pixel(x, DISPLAY_HEIGHT-y-1, int(newval))
            else:
                screen.set_pixel(x, y, int(newval))
    # first row interpolates with the "next" line
    for x in range(DISPLAY_WIDTH):
        mask = MASK[y][x]
        newval = ((100-pcnt) * grid[0][x] + pcnt * line[x]) / 100.0
        newval = mask * newval / 100.0
        if INVERT_DISPLAY:
            screen.set_pixel(x, DISPLAY_HEIGHT-1, int(newval))
        else:
            screen.set_pixel(x, 0, int(newval))

## Setup
line = generate_line()
