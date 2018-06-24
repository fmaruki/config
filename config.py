#encoding: utf-8

from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, hook, bar, widget
import os
import subprocess

mod = 'mod4'
color_alert = '#ee9900'
color_frame = '#808080'
color_graph = "#058022"

# kick a window to another screen (handy during presentations)
def kick_to_next_screen(qtile, direction=1):
	other_scr_index = (qtile.screens.index(qtile.currentScreen) + direction) % len(qtile.screens)
	othergroup = None
	for group in qtile.cmd_groups().values():
		if group['screen'] == other_scr_index:
			othergroup = group['name']
			break
	if othergroup:
		qtile.moveToGroup(othergroup)

# future use: udev code
def __x():
	import pyudev
	context = pyudev.Context()
	monitor = pyudev.Monitor.from_netlink(context)
	monitor.filter_by('drm')
	monitor.enable_receiving()
	observer = pyudev.MonitorObserver(monitor, setup_monitors)
	observer.start()

keys = [
	Key([mod], 'Tab', lazy.layout.down()),
	Key([mod, 'shift'], 'Tab', lazy.layout.up()),
	Key([mod, 'mod1'], 'Tab', lazy.layout.shuffle_down()),
	Key([mod, 'mod1', 'shift'], 'Tab', lazy.layout.shuffle_up()),
	Key([mod, 'control'], 'Tab', lazy.layout.next()),
	Key([mod, 'control', 'shift'], 'Tab', lazy.layout.prev()),
        Key([mod], 'e', lazy.layout.down()),
        Key([mod], 'n', lazy.layout.up()),
	Key([mod], 'Return', lazy.spawn('x-terminal-emulator')),
	Key([mod], 'l', lazy.spawn('xlock')),
        Key([], 'XF86MonBrightnessUp', lazy.spawn('xbacklight -inc 20')),
        Key([], 'XF86MonBrightnessDown', lazy.spawn('xbacklight -dec 20')),
	Key([], 'XF86AudioMute', lazy.spawn('pactl set-sink-mute 0 toggle')),
	Key([], 'XF86AudioRaiseVolume', lazy.spawn('pactl set-sink-volume 0 +5%')),
	Key([], 'XF86AudioLowerVolume', lazy.spawn('pactl set-sink-volume 0 -5%')),
	Key([mod], 'space', lazy.next_layout()),
	Key([mod], 'x', lazy.window.kill()),
        Key([mod, 'mod1'], 'Return', lazy.spawn("sh /home/nunes/.config/qtile/rofi_script.sh")),
	Key([mod, 'shift'], 'r', lazy.restart()), # default is control! ;)
	Key([mod, 'shift'], 'q', lazy.shutdown()),
	Key([mod], 'r', lazy.spawncmd()),
	Key([mod, 'mod1'], 'space', lazy.window.toggle_floating()),
	Key([mod], 'f', lazy.window.toggle_fullscreen()),
        Key([mod], 'Escape', lazy.spawn("dm-tool lock")),
        Key([], 'Print', lazy.spawn("gnome-screenshot")),
        Key([mod], 'Print', lazy.spawn("gnome-screenshot -a")),
        Key([mod], 'a', lazy.spawn("nemo")),
        Key([mod], 'i', lazy.spawn("setxkbmap us -variant colemak")),
        Key([mod], 'u', lazy.spawn("setxkbmap br")),
	]

# create groups
groups = [Group(i) for i in '12345']
for i in groups:
	# mod1 + letter of group = switch to group
	keys.append(
		Key([mod], i.name, lazy.group[i.name].toscreen())
	)

	# mod1 + shift + letter of group = switch to & move focused window to group
	keys.append(
		Key([mod, 'shift'], i.name, lazy.window.togroup(i.name))
	)

# see http://docs.qtile.org/en/latest/manual/ref/layouts.html
layouts = [
	layout.Max(),
	# layout.Floating(border_focus=color_alert, border_normal=color_frame, ),
	# layout.Matrix(),
	# layout.MonadTall(),
	# layout.RatioTile(),
	# layout.Slice(),
	layout.Stack(num_stacks=2),
	# layout.Tile(border_focus=color_alert, border_normal=color_frame, ),
	# layout.TreeTab(),
	# layout.VerticalTile(),
	# layout.Zoomy(),
	]

widget_defaults = dict(
	font='Sans',
	fontsize=12,
	)

class Backlight(widget.Backlight):
	def poll(self):
		info = self._get_info()
		if info is False:
			return '---'
		no = int(info['brightness'] / info['max'] * 9.999)
		char = '☼'
		#self.layout.colour = color_alert
		return '{}{}{}'.format(char, no, 'L')#chr(0x1F50B))

class Battery(widget.Battery):
	def _get_text(self):
		info = self._get_info()
		if info is False:
			return '---'
		if info['full']:
			no = int(info['now'] / info['full'] * 9.999)
		else:
			no = 0
		if info['stat'] == 'Discharging':
			char = self.discharge_char
			if no < 2:
				self.layout.colour = self.low_foreground
			else:
				self.layout.colour = self.foreground
		elif info['stat'] == 'Charging':
			char = self.charge_char
		#elif info['stat'] == 'Unknown':
		else:
			char = 'X'
		return '{}{}{}'.format(char, no, 'B')#chr(0x1F506))


class Volume(widget.Volume):
	def update(self):
		vol = self.get_volume()
		if vol != self.volume:
			self.volume = vol
			if vol < 0:
				no = '0'
			else:
				no = int(vol / 100 * 9.999)
			char = '♬'
			self.text = '{}{}{}'.format(char, no, 'V')#chr(0x1F508))

# see http://docs.qtile.org/en/latest/manual/ref/widgets.html
screens = [Screen(bottom=bar.Bar([
	widget.GroupBox(
		disable_drag=True,
		this_current_screen_border=color_frame,
		this_screen_border=color_frame,
		urgent_text=color_alert,
                spacing=0,
                use_mouse_wheel=False,
                rounded=False,
		),
	widget.CurrentLayout(),
	widget.Prompt(),
	widget.TaskList(
		font='Nimbus Sans L',
                fontsize=0,
		border=color_frame,
		highlight_method='block',
		max_title_width=50,
		urgent_border=color_alert,
		),
	widget.Systray(),
        widget.Volume(foreground = "70ff70"),
        widget.KeyboardLayout(
            configured_keyboards = ['us colemak', 'pt'],
        ),
        widget.Battery(
            energy_now_file='charge_now',
            energy_full_file='charge_full',
            power_now_file='current_now',
            update_delay = 5,
            foreground = "7070ff",),
        widget.Memory(
            update_interval=10,
            fmt="{MemUsed}M/{MemTotal}M",
        ),
        # widget.Wlan(),
	# widget.CPUGraph(
	# 	graph_color=color_graph,
	# 	fill_color='{}.5'.format(color_graph),
	# 	border_color=color_frame,
	# 	line_width=2,
	# 	border_width=1,
	# 	samples=60,
	# 	),
	# widget.MemoryGraph(
	# 	graph_color=color_graph,
	# 	fill_color='{}.5'.format(color_graph),
	# 	border_color=color_frame,
	# 	line_width=2,
	# 	border_width=1,
	# 	samples=60,
	# 	),
	widget.NetGraph(
		graph_color=color_graph,
		fill_color='{}.5'.format(color_graph),
		border_color=color_frame,
		line_width=2,
		border_width=1,
		samples=60,
		),
	widget.Clock(
		format='%Y-%m-%d %H:%M %p',
		),
	], 25, ), ), ]

def detect_screens(qtile):
	while len(screens) < len(qtile.conn.pseudoscreens):
		screens.append(Screen(
		top=bar.Bar([
			widget.GroupBox(
				disable_drag=True,
				this_current_screen_border=color_frame,
				this_screen_border=color_frame,
				),
			widget.CurrentLayout(),
			widget.TaskList(
				font='Nimbus Sans L',
				border=color_frame,
				highlight_method='block',
				max_title_width=30,
				urgent_border=color_alert,
				),
			], 32, ), ))

# Drag floating layouts.
mouse = [
	Drag([mod], 'Button1', lazy.window.set_position_floating(), start=lazy.window.get_position()),
	Drag([mod], 'Button3', lazy.window.set_size_floating(), start=lazy.window.get_size()),
	Click([mod], 'Button2', lazy.window.bring_to_front())
	]

# subscribe for change of screen setup, just restart if called
@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
	# TODO only if numbers of screens changed
	qtile.cmd_restart()

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
	border_focus=color_alert,
	border_normal=color_frame,
	float_rules=[dict(role='buddy_list', ), ],
	)
auto_fullscreen = True
# java app don't work correctly if the wmname isn't set to a name that happens to
# be on java's whitelist (LG3D is a 3D non-reparenting WM written in java).
wmname = 'LG3D'

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.call([home])

def main(qtile):
	detect_screens(qtile)
