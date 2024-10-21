-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')

-- Standard awesome library
local gears = require 'gears'
local awful = require 'awful'
require 'awful.autofocus'
-- Widget and layout library
local wibox = require 'wibox'
-- Theme handling library
local beautiful = require 'beautiful'
-- Notification library
local naughty = require 'naughty'
local hotkeys_popup = require 'awful.hotkeys_popup'
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require 'awful.hotkeys_popup.keys'
local lain = require 'lain'
local markup = lain.util.markup

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = 'Oops, there were errors during startup!',
        text = awesome.startup_errors,
    }
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal('debug::error', function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = 'Oops, an error happened!',
            text = tostring(err),
        }
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init '/home/gustavo/.config/awesome/theme.lua'

-- This is used later as the default terminal and editor to run.
terminal = 'alacritty'
browser = 'firefox'
editor = os.getenv 'EDITOR' or 'nvim'
editor_cmd = terminal .. ' -e ' .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = 'Mod4'

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    awful.layout.suit.floating,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Wibar
-- Create a textclock widget
--
local label_color = '#9e9e9e'
local sep_color = '#6e6e6e'
local alert_color = '#ff2626'
mytextclock = wibox.widget.textclock('%a %d/%m/%y %H:%M:%S', 1)
local lain_cpu = lain.widget.cpu {
    settings = function()
        local label = markup.fg.color(label_color, 'cpu')
        local value = cpu_now.usage
        if value > 80 then
            value = markup.fg.color(alert_color, value)
        end
        widget:set_markup(label .. ' ' .. value .. '%')
    end,
}
local lain_mem = lain.widget.mem {
    settings = function()
        local label = markup.fg.color(label_color, 'mem')
        local value = mem_now.used
        if mem_now.perc > 85 then
            value = markup.fg.color(alert_color, value)
        end
        widget:set_markup(label .. ' ' .. value .. 'M(' .. mem_now.perc .. '%)')
    end,
}
local lain_fs = lain.widget.fs {
    showpopup = 'off',
    settings = function()
        local root = fs_now['/']
        local hdd = fs_now['/mnt/HDD']
        local root_label = markup.fg.color(label_color, 'ssd')
        local root_value = root.percentage
        if root_value > 90 then
            root_value = markup.fg.color(alert_color, root_value)
        end
        local text = root_label .. ' ' .. root_value .. '%'
        if hdd then
            local hdd_label = markup.fg.color(label_color, 'hdd')
            local hdd_value = hdd.percentage
            if hdd_value > 90 then
                hdd_value = markup.fg.color(alert_color, hdd_value)
            end
            text = text .. ' ' .. hdd_label .. ' ' .. hdd_value .. '%'
        end
        widget:set_markup(text)
    end,
}
local lain_net = lain.widget.net {
    notify = 'off',
    wifi_state = 'on',
    eth_state = 'on',
    settings = function()
        local eth_device = nil
        local wifi_device = nil
        for k, _ in pairs(net_now.devices) do
            local first_char = string.sub(k, 1, 1)
            if first_char == 'e' then
                eth_device = k
            elseif first_char == 'w' then
                wifi_device = k
            end
        end
        local net_status = ''
        local eth = net_now.devices[eth_device]
        if eth and eth.ethernet and eth.carrier == '1' then
            local eth_label = markup.fg.color(label_color, eth_device)
            net_status = net_status .. eth_label .. ' ↓' .. eth.received .. '↑' .. eth.sent
        end
        local wlan = net_now.devices[wifi_device]
        if wlan and wlan.wifi then
            if wlan.carrier == '1' then
                local wifi_label = markup.fg.color(label_color, wifi_device)
                net_status = net_status .. wifi_label .. ' ↓' .. wlan.received .. '↑' .. wlan.sent
            end
        end
        widget:set_markup(net_status)
    end,
}
local lain_bat = lain.widget.bat {
    notify = 'off',
    battery = 'BAT1',
    settings = function()
        local ac = ''
        if bat_now.status == 'Charging' then
            ac = '↑'
        end
        local bat_label = markup.fg.color(label_color, 'bat')
        local bat_value = bat_now.perc
        if bat_value < 30 then
            bat_value = markup.fg.color(alert_color, bat_value)
        end
        widget:set_markup(bat_label .. ' ' .. bat_value .. '%' .. ac)
    end,
}
local updates_widget = awful.widget.watch('showupdates', 600)
local wifi_ssid_widget = awful.widget.watch('iwgetid -r', 5)

-- Create a wibox for each screen and add it
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == 'function' then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal('property::geometry', set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ '1', '2', '3', '4', '5', '6', '7', '8', '9' }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
    }

    -- Create the wibox
    s.mywibox = awful.wibar { position = 'top', screen = s }

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.textbox ' ',
            wifi_ssid_widget,
            wibox.widget.textbox '  ',
            lain_net.widget,
            wibox.widget.textbox '  ',
            lain_cpu.widget,
            wibox.widget.textbox '  ',
            lain_mem.widget,
            wibox.widget.textbox '  ',
            lain_fs.widget,
            wibox.widget.textbox '  ',
            lain_bat.widget,
            wibox.widget.textbox(markup.fg.color(sep_color, ' | ')),
            mytextclock,
            wibox.widget.textbox(markup.fg.color(sep_color, ' | ')),
            updates_widget,
            wibox.widget.textbox ' ',
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey }, 's', hotkeys_popup.show_help, { description = 'show help', group = 'awesome' }),
    awful.key({ modkey }, 'Left', awful.tag.viewprev, { description = 'view previous', group = 'tag' }),
    awful.key({ modkey }, 'Right', awful.tag.viewnext, { description = 'view next', group = 'tag' }),
    awful.key({ modkey }, 'Escape', awful.tag.history.restore, { description = 'go back', group = 'tag' }),

    awful.key({ modkey }, 'j', function()
        awful.client.focus.byidx(1)
    end, { description = 'focus next by index', group = 'client' }),
    awful.key({ modkey }, 'k', function()
        awful.client.focus.byidx(-1)
    end, { description = 'focus previous by index', group = 'client' }),

    -- Layout manipulation
    awful.key({ modkey, 'Shift' }, 'j', function()
        awful.client.swap.byidx(1)
    end, { description = 'swap with next client by index', group = 'client' }),
    awful.key({ modkey, 'Shift' }, 'k', function()
        awful.client.swap.byidx(-1)
    end, { description = 'swap with previous client by index', group = 'client' }),
    awful.key({ modkey }, 'e', function()
        if awful.screen.focused({}).index < screen:count() then
            awful.screen.focus_relative(1)
        end
    end, { description = 'focus the next screen', group = 'screen' }),
    awful.key({ modkey }, 'w', function()
        if awful.screen.focused({}).index > 1 then
            awful.screen.focus_relative(-1)
        end
    end, { description = 'focus the previous screen', group = 'screen' }),
    awful.key({ modkey }, 'u', awful.client.urgent.jumpto, { description = 'jump to urgent client', group = 'client' }),
    awful.key({ modkey }, 'Tab', function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end, { description = 'go back', group = 'client' }),

    -- Standard program
    awful.key({ modkey, 'Shift' }, 'Return', function()
        awful.spawn(terminal)
    end, { description = 'open a terminal', group = 'launcher' }),
    awful.key({ modkey, 'Shift' }, 'b', function()
        awful.spawn(browser)
    end, { description = 'launch web browser', group = 'launcher' }),
    awful.key({ modkey }, 'Print', function()
        awful.spawn 'screenshot'
    end, { description = 'snapshot of the entire screen', group = 'launcher' }),
    awful.key({ modkey, 'Shift' }, 'Print', function()
        awful.spawn 'screenshot-area'
    end, { description = 'snapshot of selected area', group = 'launcher' }),
    awful.key({ modkey }, 'q', awesome.restart, { description = 'reload awesome', group = 'awesome' }),
    awful.key({ modkey, 'Shift' }, 'q', awesome.quit, { description = 'quit awesome', group = 'awesome' }),

    awful.key({ modkey }, 'l', function()
        awful.tag.incmwfact(0.02)
    end, { description = 'increase master width factor', group = 'layout' }),
    awful.key({ modkey }, 'h', function()
        awful.tag.incmwfact(-0.02)
    end, { description = 'decrease master width factor', group = 'layout' }),
    awful.key({ modkey, 'Shift' }, 'h', function()
        awful.tag.incnmaster(1, nil, true)
    end, { description = 'increase the number of master clients', group = 'layout' }),
    awful.key({ modkey, 'Shift' }, 'l', function()
        awful.tag.incnmaster(-1, nil, true)
    end, { description = 'decrease the number of master clients', group = 'layout' }),
    awful.key({ modkey, 'Control' }, 'h', function()
        awful.tag.incncol(1, nil, true)
    end, { description = 'increase the number of columns', group = 'layout' }),
    awful.key({ modkey, 'Control' }, 'l', function()
        awful.tag.incncol(-1, nil, true)
    end, { description = 'decrease the number of columns', group = 'layout' }),
    awful.key({ modkey }, 'space', function()
        awful.layout.inc(1)
    end, { description = 'select next', group = 'layout' }),
    awful.key({ modkey, 'Shift' }, 'space', function()
        awful.layout.inc(-1)
    end, { description = 'select previous', group = 'layout' }),

    awful.key({ modkey, 'Control' }, 'n', function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal('request::activate', 'key.unminimize', { raise = true })
        end
    end, { description = 'restore minimized', group = 'client' }),

    -- dmenu
    awful.key({ modkey }, 'p', function()
        awful.spawn 'dmenu_run -fn "SFMono Nerd Font Mono-9"'
    end, { description = 'open dmenu', group = 'launcher' })
)

clientkeys = gears.table.join(
    awful.key({ modkey }, 'f', function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = 'toggle fullscreen', group = 'client' }),
    awful.key({ modkey, 'Shift' }, 'c', function(c)
        c:kill()
    end, { description = 'close', group = 'client' }),
    awful.key({ modkey }, 't', function(c)
        c.floating = not c.floating
    end, { description = 'toggle floating', group = 'client' }),
    awful.key({ modkey }, 'Return', function(c)
        c:swap(awful.client.getmaster())
    end, { description = 'move to master', group = 'client' }),
    awful.key({ modkey }, 'o', function(c)
        c:move_to_screen()
    end, { description = 'move to screen', group = 'client' }),
    awful.key({ modkey }, 'y', function(c)
        c.ontop = not c.ontop
    end, { description = 'toggle keep on top', group = 'client' }),
    awful.key({ modkey }, 'n', function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end, { description = 'minimize', group = 'client' }),
    awful.key({ modkey }, 'm', function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = '(un)maximize', group = 'client' }),
    awful.key({ modkey, 'Control' }, 'm', function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = '(un)maximize vertically', group = 'client' }),
    awful.key({ modkey, 'Shift' }, 'm', function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = '(un)maximize horizontally', group = 'client' })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(
        globalkeys,
        -- View tag only.
        awful.key({ modkey }, '#' .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = 'view tag #' .. i, group = 'tag' }),
        -- Toggle tag display.
        awful.key({ modkey, 'Control' }, '#' .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, { description = 'toggle tag #' .. i, group = 'tag' }),
        -- Move client to tag.
        awful.key({ modkey, 'Shift' }, '#' .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, { description = 'move focused client to tag #' .. i, group = 'tag' }),
        -- Toggle tag on focused client.
        awful.key({ modkey, 'Control', 'Shift' }, '#' .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end, { description = 'toggle focused client on tag #' .. i, group = 'tag' })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal('request::activate', 'mouse_click', { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal('request::activate', 'mouse_click', { raise = true })
        c.floating = true
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal('request::activate', 'mouse_click', { raise = true })
        awful.mouse.client.resize(c, 'bottom_right')
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                'DTA', -- Firefox addon DownThemAll.
                'copyq', -- Includes session name in class.
                'pavucontrol',
                'pinentry',
            },
            class = {
                'Arandr',
                'Blueman-manager',
                'Gpick',
                'Kruler',
                'MessageWin', -- kalarm.
                'Sxiv',
                'Nsxiv',
                'Nitrogen',
                'Tor Browser', -- Needs a fixed window size to avoid fingerprinting by screen size.
                'Wpa_gui',
                'veromix',
                'xtightvncviewer',
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                'Event Tester', -- xev.
            },
            role = {
                'AlarmWindow', -- Thunderbird's calendar.
                'ConfigManager', -- Thunderbird's about:config.
                'pop-up', -- e.g. Google Chrome's (detached) Developer Tools.
            },
        },
        properties = { floating = true },
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal('manage', function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then
        awful.client.setslave(c)
        local prev_focused = awful.client.focus.history.get(awful.screen.focused(), 1, nil)
        local prev_client = awful.client.next(-1, c)
        if prev_client and prev_focused then
            while prev_client ~= prev_focused do
                c:swap(prev_client)
                prev_client = awful.client.next(-1, c)
            end
        end
    end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal('mouse::enter', function(c)
    c:emit_signal('request::activate', 'mouse_enter', { raise = false })
end)

client.connect_signal('focus', function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal('unfocus', function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}

-- awful.spawn.with_shell 'picom -b'
beautiful.tasklist_disable_icon = true
