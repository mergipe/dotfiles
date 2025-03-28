---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font = "SFMono Nerd Font Mono, Medium 8"

theme.bg_normal = "#202020ff"
theme.bg_focus = "#3a3a3aff"
theme.bg_urgent = "#ec372d"
theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_normal

theme.fg_normal = "#e8e8e8"
theme.fg_focus = theme.fg_normal
theme.fg_urgent = theme.fg_normal
theme.fg_minimize = theme.fg_normal

theme.useless_gap = dpi(0)
theme.border_width = dpi(1)
theme.border_normal = "#000000"
theme.border_focus = "#535d6c"
theme.border_marked = "#91231c"

theme.wibar_height = dpi(24)
theme.wibar_widget_label_color = "#9e9e9e"
theme.wibar_widget_alert_color = "#da4453"
theme.wibar_widget_margin = dpi(9)

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_font = "SF Pro, Regular 10"
theme.notification_max_width = 500
theme.notification_icon_size = 64

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"

-- Icons:
local icons_path = gfs.get_configuration_dir() .. "icons/"
theme.arch_icon = icons_path .. "arch.svg"
theme.updates_icon = icons_path .. "system-update-symbolic.svg"
theme.cpu_icon = icons_path .. "cpu.svg"
theme.mem_icon = icons_path .. "mem.svg"
theme.wired_net_icon = icons_path .. "network-wired-bold.svg"
theme.wireless_signal_none_icon = icons_path .. "network-wireless-20-bold.svg"
theme.wireless_signal_low_icon = icons_path .. "network-wireless-40-bold.svg"
theme.wireless_signal_ok_icon = icons_path .. "network-wireless-60-bold.svg"
theme.wireless_signal_good_icon = icons_path .. "network-wireless-80-bold.svg"
theme.wireless_signal_excellent_icon = icons_path .. "network-wireless-100-bold.svg"
theme.get_battery_icon = function(battery_level, is_charging)
    local truncated_level = math.floor(battery_level / 10 + 0.5) * 10
    local icon_filename = "battery-" .. string.format("%03d", truncated_level)
    if is_charging then
        icon_filename = icon_filename .. "-charging"
    end
    return icons_path .. icon_filename .. ".svg"
end

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
