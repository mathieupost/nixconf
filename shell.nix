# Shell configuration
{ config, lib, pkgs, goBuildModule, ... }:

{
  home.packages = with pkgs; [
    fzf
    any-nix-shell # fish and zsh support for nix-shell
    comma # run everything with "," without installing
    thefuck
    babelfish # convert POSIX to fish
    ttyd # shell in your browser
    unstable.warp-terminal
  ];

  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autocd = true;
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      fish_title = "prompt_pwd"; # set terminal window title
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      zf = "z --pipe=fzf";
      darwin-switch = "darwin-rebuild switch --flake ~/.config/nixconf";
    };
    plugins = with pkgs.fishPlugins; [
      { name = "fzf"; src = fzf-fish.src; } # better than buit-in fzf keybinds
    ];
    shellInit = ''
      any-nix-shell fish --info-right | source
      thefuck --alias | source
      fish_add_path /opt/homebrew/bin
    '';
  };

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

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  programs.go = {
    enable = true;
    goPath = "Dev";
    goBin = "Dev/bin";
  };

  programs.starship = {
    enable = true;
    settings = {
      cmd_duration.min_time = 500;
      command_timeout = 1000;
      gcloud.disabled = true;
      docker_context.disabled = true;
      buf.disabled = true;
      nix_shell.format = "via [\$symbol\$state](\$style) ";
      nix_shell.symbol = "❄️ ";
      kubernetes = {
        disabled = false;
      };
    };
  };

  programs.pazi.enable = true;
  programs.dircolors.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      tmutil addexclusion $(direnv_layout_dir)

      layout_poetry() {
        export POETRY_VIRTUALENVS_PATH="$(direnv_layout_dir)/poetry"
        PYPROJECT_TOML="''${PYPROJECT_TOML:-pyproject.toml}"
        if [[ ! -f "$PYPROJECT_TOML" ]]; then
            log_status "No pyproject.toml found. Executing \`poetry init\` to create a \`$PYPROJECT_TOML\` first."
            poetry init
        fi

        if [[ -d ".venv" ]]; then
            VIRTUAL_ENV="$(pwd)/.venv"
        else
            VIRTUAL_ENV=$(poetry env info --path 2>/dev/null ; true)
        fi

        if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
            log_status "No virtual environment exists. Executing \`poetry install\` to create one."    
            poetry install
            VIRTUAL_ENV=$(poetry env info --path)
        fi

        PATH_add "$VIRTUAL_ENV/bin"
        export POETRY_ACTIVE=1
        export VIRTUAL_ENV
      }
    '';
  };
  programs.fzf = {
    enable = true;
    enableFishIntegration = false; # use fzf-fish plugin instead
  };
}
# vim: sw=2 sts=2 ts=2 fdm=indent expandtab
