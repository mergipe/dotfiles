local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local lain = require 'lain'
local markup = lain.util.markup

beautiful.tasklist_disable_icon = true

-- {{{ Wibar
-- Create widgets
--
local widgets_margin = beautiful.xresources.apply_dpi(7)
local mytextclock = wibox.widget.textclock('%a %d/%m/%y %H:%M:%S', 1)

local function markup_value(value, use_alert_color)
    if use_alert_color then
        return markup.fg.color(beautiful.wibar_widget_alert_color, value)
    else
        return value
    end
end

local lain_cpu = lain.widget.cpu {
    settings = function()
        local label = markup.fg.color(beautiful.wibar_widget_label_color, 'cpu')
        local value = markup_value(cpu_now.usage, cpu_now.usage > 80)
        widget:set_markup(label .. ' ' .. value .. '%')
    end,
}
local lain_mem = lain.widget.mem {
    settings = function()
        local label = markup.fg.color(beautiful.wibar_widget_label_color, 'mem')
        local value = markup_value(mem_now.used, mem_now.perc > 85)
        widget:set_markup(label .. ' ' .. value .. 'M(' .. mem_now.perc .. '%)')
    end,
}
local lain_fs = lain.widget.fs {
    showpopup = 'off',
    settings = function()
        local percentage_alert_threshold = 90
        local root = fs_now['/']
        local root_label = markup.fg.color(beautiful.wibar_widget_label_color, 'ssd')
        local root_value = markup_value(root.percentage, root.percentage > percentage_alert_threshold)
        local text = root_label .. ' ' .. root_value .. '%'
        local hdd = fs_now['/mnt/HDD']
        if hdd then
            local hdd_label = markup.fg.color(beautiful.wibar_widget_label_color, 'hdd')
            local hdd_value = markup_value(hdd.percentage, hdd.percentage > percentage_alert_threshold)
            text = text .. '  ' .. hdd_label .. ' ' .. hdd_value .. '%'
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
        local wlan = net_now.devices[wifi_device]
        if eth and eth.ethernet and eth.carrier == '1' then
            local eth_label = markup.fg.color(beautiful.wibar_widget_label_color, eth_device)
            net_status = net_status .. eth_label .. ' ↓' .. eth.received .. '↑' .. eth.sent
        elseif wlan and wlan.wifi then
            if wlan.carrier == '1' then
                local wifi_label = markup.fg.color(beautiful.wibar_widget_label_color, wifi_device)
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
        if bat_now.perc == 'N/A' then
            return
        end
        local ac = ''
        if bat_now.status == 'Charging' then
            ac = '↑'
        end
        local bat_label = markup.fg.color(beautiful.wibar_widget_label_color, 'bat')
        local bat_value = markup_value(bat_now.perc, bat_now.perc < 30)
        widget:set_markup(bat_label .. ' ' .. bat_value .. '%' .. ac)
    end,
}
local updates_widget = awful.widget.watch('showupdates', 600)
local wifi_ssid_widget = awful.widget.watch('iwgetid -r', 5)
local right_widgets = {
    layout = wibox.layout.fixed.horizontal,
    wibox.container.margin(wifi_ssid_widget, widgets_margin, widgets_margin),
    wibox.container.margin(lain_net.widget, widgets_margin, widgets_margin),
    wibox.container.margin(lain_cpu.widget, widgets_margin, widgets_margin),
    wibox.container.margin(lain_mem.widget, widgets_margin, widgets_margin),
    wibox.container.margin(lain_fs.widget, widgets_margin, widgets_margin),
    wibox.container.margin(lain_bat.widget, widgets_margin, widgets_margin),
    wibox.container.margin(mytextclock, widgets_margin, widgets_margin),
    wibox.container.margin(updates_widget, widgets_margin, widgets_margin * 2),
}

awful.screen.connect_for_each_screen(function(s)
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
    local icon = wibox.widget {
        image = beautiful.arch_icon,
        widget = wibox.widget.imagebox,
    }

    local left_widgets = {
        layout = wibox.layout.fixed.horizontal,
        wibox.container.margin(icon, widgets_margin * 2, widgets_margin, 4, 4),
        wibox.container.margin(s.mytaglist, widgets_margin, widgets_margin),
        wibox.container.margin(s.mylayoutbox, widgets_margin, widgets_margin, 4, 4),
    }

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        left_widgets,
        wibox.container.margin(s.mytasklist, widgets_margin, widgets_margin), -- Middle widget
        right_widgets,
    }
end)
-- }}}
