# Terminal configuration
{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.warp-terminal
  ];

  programs.wezterm = {
    package = pkgs.unstable.wezterm;
    enable = true;
    extraConfig = ''
      function tab_title(tab_info)
        local title = tab_info.tab_title
        -- if the tab title is explicitly set, take that
        if title and #title > 0 then
          return title
        end
        -- Otherwise, use the title from the active pane in that tab
        return tab_info.active_pane.title
      end

      function trim_title(title, max_width)
        if #title > max_width then
          return title:sub(1, max_width - 1) .. "…"
        else
          return title
        end
      end

      wezterm.on(
        'format-tab-title',
        function(tab, tabs, panes, config, hover, max_width)
          local title = tab_title(tab)
          title = trim_title(title, max_width-2)
          title = ' ' .. title .. ' '

          return {
            { Attribute = { Intensity = 'Bold' } },
            { Text = title },
          }
        end
      )

      local act = wezterm.action
      return {
        default_prog = { '${pkgs.fish}/bin/fish' },
        set_environment_variables = {
          TERMINFO_DIRS = '/etc/profiles/per-user/mathieu/share/terminfo',
        },
        term = 'wezterm',
        dpi = 110,
        font = wezterm.font { family = 'JetBrainsMono Nerd Font' },
        font_size = 10.0,
        color_scheme = 'OneDark (base16)',
        keys = {
          { key = '-', mods = 'CTRL', action = wezterm.action.DisableDefaultAssignment },
          { key = '=', mods = 'CTRL', action = wezterm.action.DisableDefaultAssignment },
          { key = 'w', mods = 'CTRL|CMD', action = act.ActivateKeyTable { name = 'window' } },
          { key = 'W', mods = 'CTRL|CMD', action = act.ActivateKeyTable { name = 'window' } },
        },
        key_tables = {
          window = {
            { key = 's', mods = 'CTRL|CMD', action = act.SplitPane { direction = 'Down' } },
            { key = 'v', mods = 'CTRL|CMD', action = act.SplitPane { direction = 'Right' } },

            { key = 'h', mods = 'CTRL|CMD', action = act.ActivatePaneDirection 'Left' },
            { key = 'l', mods = 'CTRL|CMD', action = act.ActivatePaneDirection 'Right' },
            { key = 'k', mods = 'CTRL|CMD', action = act.ActivatePaneDirection 'Up' },
            { key = 'j', mods = 'CTRL|CMD', action = act.ActivatePaneDirection 'Down' },

            { key = 'H', mods = 'CTRL|CMD', action = act.AdjustPaneSize { 'Left', 5 } },
            { key = 'L', mods = 'CTRL|CMD', action = act.AdjustPaneSize { 'Right', 5 } },
            { key = 'K', mods = 'CTRL|CMD', action = act.AdjustPaneSize { 'Up', 5 } },
            { key = 'J', mods = 'CTRL|CMD', action = act.AdjustPaneSize { 'Down', 5 } },
          },
        },

        -- UI
        hide_tab_bar_if_only_one_tab = true,
        use_fancy_tab_bar = false,
        window_decorations = 'RESIZE', -- Remove title bar
        window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
        tab_max_width = 32,

        -- Scrolling
        enable_scroll_bar = true,
        scrollback_lines = 500000,
        alternate_buffer_wheel_scroll_speed = 1,

        -- SSH
        ssh_domains = {
          { name = 'hackbook', remote_address = 'hackbook' },
        },
      }
    '';
  };
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
