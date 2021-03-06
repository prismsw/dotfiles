-- Standard awesome library
awful = require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
-- Widget library
vicious = require("vicious")

-- {{{ Global functions

-- Switches keyboard layout
function switchkbLayout()
	layout = getkbLayout()
	if layout == "de" then
		return setkbLayout("us")
	else
		return setkbLayout("de")
	end
end

-- Sets keyboard layout
function setkbLayout(layout)
	io.popen("setxkbmap " .. layout)
	return layout
end

-- Queries keyboard layout
function getkbLayout()
	layout = io.popen("setxkbmap -query | grep layout | awk '{print $2}'"):read()
	return layout
end

-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/simon/.config/awesome/themes/rainbow_stripes/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "main", "term", "media", "dev", "misc1" , "misc2"}, s, layouts[2])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{ "quit", awesome.quit }
}

applicationsmenu = {
	{ "Chrome", "google-chrome" },
	{ "Chromium", "chromium" },
	{ "Gimp", "gimp"},
	{ "VLC", "vlc"}
}

mymainmenu = awful.menu({ items = { 
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "applications", applicationsmenu },
		{ "open terminal", terminal }
	}})

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
widget_margin = 15
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })
mytextclock:margin({ right = widget_margin })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Keyboard layout widget
kbwidget = widget({ type = "textbox" })
kbwidget:margin({ right = widget_margin })

kbtimer = timer({ timeout = 20 })
kbtimer:add_signal("timeout",
	function()
		layout = getkbLayout()
		kbwidget.text = layout
	end)
kbtimer:start()
kbtimer:emit_signal("timeout")


-- Volume widget
volwidget = widget({ type = "textbox" })
volwidget:margin({ right = widget_margin })
vicious.register(volwidget, vicious.widgets.volume,
	function(widget, args)
		if args[1] == 0 or args[2] == "♩" then
			return "Vol: " .. "<span color=\"red\">OFF</span>"
		else
			return "Vol: " .. args[1] .. "%"
		end
	end, 0.1, "Master")

-- Gmail widget
gmailwidget = widget({ type = "textbox" })
gmailwidget:margin({ right = widget_margin })
vicious.register(gmailwidget, vicious.widgets.gmail, 
	function(widget, args)
		if args["{count}"] > 0 then
			return "<span color=\"red\">Mail: " .. args["{count}"] .. "</span>"
		else
			return "Mail: " .. args["{count}"]
		end
	end, 60)

-- MPD widget
mpdwidget = widget({type = "textbox" })
mpdwidget:margin({ right = widget_margin })
vicious.register(mpdwidget, vicious.widgets.mpd,
	function (widget, args)
		if args["{state}"] == "Stop" then 
                	return "N/A" ..' - '.. "N/A"
		else 
                	return args["{Artist}"]..' - '.. args["{Title}"]
        	end
    	end, 1)
-- CPU widget
cpuwidget =  widget({type = "textbox" })
cpuwidget:margin({ right = widget_margin })
vicious.register(cpuwidget, vicious.widgets.cpu,
	function(widget, args)
		cpuStr = ""
		if args[1] < 10 then
			cpuStr = "0" .. args[1] .. "%"
		else
			cpuStr = args[1] .. "%"
		end

		return "CPU: " .. cpuStr
	end, 1)

-- Backup widget
backupwidget = widget({ type = "textbox" })
backupwidget:margin({ right = widget_margin })

backuptimer = timer({ timeout = 60 })
backuptimer:add_signal("timeout",
	function()
		result = io.popen("pgrep duplicity"):read("*n")
		if result == nil then
			backupwidget.text = ""
		else
			backupwidget.text = '<span color="red">Backup running</span>'
		end
	end)
backuptimer:start()
		

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
	kbwidget,
	volwidget,
	gmailwidget,
	mpdwidget,
	cpuwidget,
	backupwidget,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Media buttons
    awful.key({}, "XF86AudioMute", function() awful.util.spawn("amixer set Master toggle", false) end ),
    awful.key({}, "XF86AudioRaiseVolume", function() awful.util.spawn("amixer set Master 2%+", false) end ),
    awful.key({}, "XF86AudioLowerVolume", function() awful.util.spawn("amixer set Master 2%-", false) end ),
    -- Needs to be adapted for the preferred music player
    awful.key({}, "XF86AudioNext", function() awful.util.spawn("mpc next", false) end ),
    awful.key({}, "XF86AudioPrev", function() awful.util.spawn("mpc prev", false) end ),
    awful.key({}, "XF86AudioPlay", function() awful.util.spawn("mpc toggle", false) end ),

    -- Lock screen
    awful.key({ "Mod1", "Control" }, "l", function() awful.util.spawn("slock", false) end),

    -- Keyboard layout switcher
    awful.key({ "Mod1", "Control" }, "k", function() 
	layout = switchkbLayout() .. " | "
	kbwidget.text = layout
    end),


    -- Window/Tag control
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal, false) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
		     border_color = beautiful.border_normal,
		     focus = true,
		     keys = clientkeys,
		     buttons = clientbuttons,
		     size_hints_honor = false } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "chrome" },
      properties = { floating = false } },
    { rule = { class = "Chromium" },
      properties = { floating = false } },
    { rule = { class = "Eclipse" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Transmission-gtk" },
      properties = { tag = tags[2][6] } },
    { rule = { class = "Transmission-remote-gtk" },
      properties = { tag = tags[2][6] } },
    { rule = { class = "Gimp" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "Vlc" },
      properties = { tag = tags[2][1] } },
    { rule = { class = "Spotify" },
      properties = { tag = tags[2][3],
                     floating = false } },

    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}


-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Function to start only if not already running
function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then 
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end

-- Autostart commands
run_once("/opt/dropbox/dropboxd")
