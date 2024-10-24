local awful = require 'awful'
local beautiful = require 'beautiful'

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
