local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local gfs = require("gears.filesystem")
require("utils/table_utils")

local function set_rounded_border_if_floating(c)
    if c.floating then
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 10)
        end
    else
        c.shape = gears.shape.rectangle
    end
end

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
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
    set_rounded_border_if_floating(c)
end)

client.connect_signal("property::floating", function(c)
    set_rounded_border_if_floating(c)
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

local state_file = gfs.get_cache_dir() .. "state"

local function save_state()
    local state = {}
    for s in screen do
        state[s.index] = {}
        for _, t in pairs(s.tags) do
            table.insert(state[s.index], {
                id = t.index,
                selected = t.selected,
                activated = t.activated,
                master_width_factor = t.master_width_factor,
                column_count = t.column_count,
                master_count = t.master_count,
                layout_index = table.indexof(t.layouts, t.layout),
            })
        end
    end
    table.save(state, state_file)
end

awesome.connect_signal("exit", function(reason_restart)
    if reason_restart then
        save_state()
    end
end)

local function restore_state()
    local state = table.load(state_file)
    if state == nil then
        return
    end
    for s in screen do
        for _, v in pairs(state[s.index]) do
            local t = s.tags[v.id]
            t.selected = v.selected
            t.activated = v.activated
            t.master_width_factor = v.master_width_factor
            t.column_count = v.column_count
            t.master_count = v.master_count
            t.layout = t.layouts[v.layout_index]
        end
    end
    os.remove(state_file)
end

awesome.connect_signal("startup", function()
    restore_state()
end)
-- }}}
