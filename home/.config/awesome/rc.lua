-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')

-- Standard awesome library
local gears = require 'gears'
local gfs = gears.filesystem
local awful = require 'awful'
require 'awful.autofocus'
-- Widget and layout library
-- Theme handling library
local beautiful = require 'beautiful'
-- Notification library
local naughty = require 'naughty'

naughty.config.padding = beautiful.xresources.apply_dpi(10)
naughty.config.spacing = beautiful.xresources.apply_dpi(10)
naughty.config.defaults.timeout = 30
naughty.config.presets.low.timeout = 30
naughty.config.presets.normal.timeout = 30
naughty.config.presets.ok.timeout = 30
naughty.config.presets.info.timeout = 30
naughty.config.presets.warn.timeout = 0
naughty.config.presets.critical.timeout = 0

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
beautiful.init(gfs.get_configuration_dir() .. 'theme.lua')

require 'layouts'
require 'keys'
require 'rules'
require 'wibar'
require 'signals'

awful.spawn 'picom -b'
awful.spawn 'nitrogen --restore'
awful.spawn 'solaar --window=hide'
