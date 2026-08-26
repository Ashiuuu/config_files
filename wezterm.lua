local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false

-- Color scheme / font
config.color_scheme = 'Dracula'
config.font = wezterm.font_with_fallback { 'Hack Nerd Font Mono', 'Hack Font Mono' }
config.font_size = 10.0
config.tab_max_width = 60
config.audible_bell = "Disabled"

-- Terminator Keybindings Migration
config.keys = {
  -- Split Vertically (Side-by-Side): Ctrl+Shift+E
  { key = 'E', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- Split Horizontally (Top/Bottom): Ctrl+Shift+O
  { key = 'O', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Close Pane: Ctrl+Shift+W
  { key = 'W', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentPane { confirm = true } },

  -- New Tab: Ctrl+Shift+T
  { key = 'T', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },

  -- Switch Panes with Alt + Arrow Keys
  { key = 'LeftArrow',  mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down' },
}

config.mouse_bindings = {
  -- Disable the default click behavior
  {
    event = { Up = { streak = 1, button = "Left"} },
    mods = "NONE",
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- Ctrl-click will open the link under the mouse cursor
  {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "CTRL",
      action = wezterm.action.OpenLinkAtMouseCursor,
  },
  -- Disable the Ctrl-click down event to stop programs from seeing it when a URL is clicked
  {
      event = { Down = { streak = 1, button = "Left" } },
      mods = "CTRL",
      action = wezterm.action.Nop,
  },
}

config.window_frame = {
	font_size = 12
}

--------------------------------------------------------------------------------
-- 1. TERMINATOR TAB BAR FRAME & CONTAINER
--------------------------------------------------------------------------------
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = false

config.colors = {
  split = '#c80003',
  background = '#000000',
  tab_bar = {
    -- Dark background strip behind the tabs
    background = '#1e1e1e',

    -- New tab (+) button
    new_tab = {
      bg_color = '#1e1e1e',
      fg_color = '#aaaaaa',
    },
    new_tab_hover = {
      bg_color = '#2a2a2a',
      fg_color = '#ffffff',
    },
  },
}

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.inactive_pane_hsb = {
  saturation = 0.7, -- Reduce color saturation of inactive panes
  brightness = 0.5, -- Dim inactive panes to 50% brightness
}


--------------------------------------------------------------------------------
-- 2. TERMINATOR TAB TITLE RENDERING & EXACT HEX PALETTE
--------------------------------------------------------------------------------
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end
  if not title or #title == 0 then
    local process = tab.active_pane.foreground_process_name
    title = process and process:match("([^/]+)$") or "terminal"
  end

  local index = tab.tab_index + 1
  local close_icon = " ✕"
  local tab_text = string.format(" %d: %s%s ", index, title, close_icon)

  ------------------------------------------------------------------------------
  -- ACTIVE TAB (Default: Signature Terminator Red '#c80003')
  -- Note: If you prefer GTK Dark Charcoal active tabs, change '#c80003' to '#383838'
  ------------------------------------------------------------------------------
  if tab.is_active then
    return {
      { Background = { Color = '#c80003' } }, -- Classic Terminator Red
      { Foreground = { Color = '#ffffff' } }, -- White Text
      { Attribute = { Intensity = 'Bold' } },
      { Text = tab_text },
    }
  -- HOVERED INACTIVE TAB
  elseif hover then
    return {
      { Background = { Color = '#3a3a3a' } }, -- Lighter Grey Hover
      { Foreground = { Color = '#ffffff' } },
      { Text = tab_text },
    }
  -- INACTIVE TAB
  else
    return {
      { Background = { Color = '#2a2a2a' } }, -- Dark Inactive Grey
      { Foreground = { Color = '#aaaaaa' } }, -- Muted Text
      { Text = tab_text },
    }
  end
end)

return config
