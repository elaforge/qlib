#!/usr/bin/env python3.7

import iterm2
import math

# Set leftmost session to 80 columns, others are even.

async def main(connection):
    app = await iterm2.async_get_app(connection)
    window = app.current_terminal_window
    tab = window.current_tab
    session = tab.root

    total_width = get_width(session)
    print('divide: %s %s' % (len(session.children)-1, total_width - 80))
    widths = [80] + divide(len(session.children) - 1, total_width - 80)
    print('widths:', widths)
    for pane, width in zip(session.children, widths):
        set_width(pane, width)
    await tab.async_update_layout()

def get_width(session):
    if isinstance(session, iterm2.Session):
        return session.grid_size.width
    elif isinstance(session, iterm2.Splitter):
        if session.vertical:
            return sum(get_width(c) for c in session.children)
        else:
            return get_width(session.children[0])
    else:
        raise TypeError()

def divide(n, size):
    pos = [math.floor((size/n) * i) for i in range(n+1)]
    return [b - a for (a, b) in zip(pos, pos[1:])]

def set_width(session, width):
    if isinstance(session, iterm2.Session):
        session.preferred_size.width = width
    elif isinstance(session, iterm2.Splitter):
        if session.vertical:
            return
        else:
            set_width(session.children[0], width)
    else:
        raise TypeError()

iterm2.run_until_complete(main)
