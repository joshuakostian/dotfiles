#!/bin/bash
set +e

# environment for portals and systemd user services
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# portals
systemctl --user restart xdg-desktop-portal &
/usr/lib/xdg-desktop-portal-wlr >/dev/null 2>&1 &

# polkit agent
/usr/lib/xfce-polkit/xfce-polkit >/dev/null 2>&1 &

# bar, notifications, idle
waybar >/dev/null 2>&1 &
dunst >/dev/null 2>&1 &
hypridle >/dev/null 2>&1 &

# wallpaper (waypaper set to swaybg backend)
waypaper --restore >/dev/null 2>&1 &

# night light
wlsunset -l 59.1 -L 18.1 -t 3500 -T 6500 >/dev/null 2>&1 &

# clipboard
wl-clip-persist --clipboard regular --reconnect-tries 0 >/dev/null 2>&1 &
wl-paste --type text --watch cliphist store >/dev/null 2>&1 &

# tray applets
blueman-applet >/dev/null 2>&1 &
nm-applet >/dev/null 2>&1 &
