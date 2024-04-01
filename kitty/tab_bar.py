import datetime
from dataclasses import dataclass
from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import (DrawData, ExtraData, TabBarData , as_rgb,
                           draw_tab_with_powerline)
from kitty.utils import color_as_int

KITTY_OPTS = get_options()

@dataclass
class ColorType:
    dark: any
    light: any

class TermColors:
    black:   ColorType = ColorType(as_rgb(color_as_int(KITTY_OPTS.color0)), as_rgb(color_as_int(KITTY_OPTS.color8)))
    red:     ColorType = ColorType(as_rgb(color_as_int(KITTY_OPTS.color1)), as_rgb(color_as_int(KITTY_OPTS.color9)))
    green:   ColorType = ColorType(as_rgb(color_as_int(KITTY_OPTS.color2)), as_rgb(color_as_int(KITTY_OPTS.color10)))
    yellow:  ColorType = ColorType(as_rgb(color_as_int(KITTY_OPTS.color3)), as_rgb(color_as_int(KITTY_OPTS.color11)))
    blue:    ColorType = ColorType(as_rgb(color_as_int(KITTY_OPTS.color4)), as_rgb(color_as_int(KITTY_OPTS.color12)))
    magenta: ColorType = ColorType(as_rgb(color_as_int(KITTY_OPTS.color5)), as_rgb(color_as_int(KITTY_OPTS.color13)))
    cyan:    ColorType = ColorType(as_rgb(color_as_int(KITTY_OPTS.color6)), as_rgb(color_as_int(KITTY_OPTS.color14)))
    white:   ColorType = ColorType(as_rgb(color_as_int(KITTY_OPTS.color7)), as_rgb(color_as_int(KITTY_OPTS.color15)))

def _draw_right_status(screen: Screen, is_last: bool) -> int:
    if not is_last:
        return screen.cursor.x

    cells = [
        # foreground, background, content
        (TermColors.yellow.dark, screen.cursor.bg, ""),
        (TermColors.white.dark, TermColors.yellow.dark, "   "),
        (TermColors.black.dark, TermColors.white.dark, datetime.datetime.now().strftime(" %H:%M ")),
        (TermColors.blue.dark, TermColors.white.dark, ""),
        (TermColors.white.dark, TermColors.blue.dark, "   "),
        (TermColors.black.dark, TermColors.white.dark, datetime.datetime.now().strftime(" %Y/%m/%d ")),
    ]

    right_status_length = 0
    for _, _, cell in cells:
        right_status_length += len(cell)

    draw_spaces = screen.columns - screen.cursor.x - right_status_length
    if draw_spaces > 0:
        screen.draw(" " * draw_spaces)

    for fg, bg, cell in cells:
        screen.cursor.fg = fg
        screen.cursor.bg = bg
        screen.draw(cell)
    screen.cursor.fg = 0
    screen.cursor.bg = 0

    screen.cursor.x = max(screen.cursor.x, screen.columns - right_status_length)
    return screen.cursor.x


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    end = draw_tab_with_powerline(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
    _draw_right_status(
        screen,
        is_last,
    )
    return end
