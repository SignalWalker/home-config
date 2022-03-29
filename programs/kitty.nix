inputs@{ config, pkgs, ... }: {
  enable = true;
  package = pkgs.kitty;
  environment = { };
  font = {
    package = pkgs.iosevka;
    name = "Iosevka";
    size = 10;
  };
  theme = "Gruvbox Material Dark Hard";
  settings = {
    # scrollback
    scrollback_lines = 10000;
    scrollback_pager = "less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";
    scrollback_pager_history_size = 0;
    scrollback_fill_enlarged_window = true;
    wheel_scroll_multiplier = 5.0;
    # performance
    repaint_delay = 8;
    input_delay = 1;
    sync_to_monitor = true;
    # bell
    enable_audio_bell = false;
    visual_bell_duration = 0.0;
    window_alert_on_bell = true;
    bell_on_tab = "🔔 ";
    # advanced
    shell = ".";
    editor = ".";
    close_on_child_death = false;
    allow_remote_control = "socket-only";
    listen_on = "none";
    update_check_interval = 0;
    clipboard_control = "write-clipboard write-primary read-clipboard-ask read-primary-ask";
    clipboard_max_size = 128;
    allow_hyperlinks = true;
    shell_integration = "enabled";
    term = "xterm-kitty";
    # os
    linux_display_server = "auto";
    # background
    background_opacity = 0.8;
    dynamic_background_opacity = false;
    background_tint = 0.2;
    # text
    bold_font = "auto";
    italic_font = "auto";
    bold_italic_font = "auto";
    force_ltr = false;
    disable_ligatures = "never";
    box_drawing_scale = "0.001, 1, 1.5, 2";
    # cursor
    cursor_shape = "block";
    # layout
    enabled_layouts = "splits";
    draw_minimal_borders = true;
    # tab bar
    tab_bar_edge = "bottom";
    # input
    clear_all_shortcuts = true;
    clear_all_mouse_actions = true;
    ## keyboard
    kitty_mod = "hyper";
    ## mouse
    mouse_hide_wait = 3.0;
    detect-urls = true;
    url_prefixes = "http https file ftp gemini irc gopher mailto news git";
    copy_on_select = false;
    focus_follows_mouse = false;
  };

  extraConfig = [
    "mouse_map left press ungrabbed mouse_selection normal"
  ];

  keybindings = {
    "ctrl+shift+v" = "paste_from_clipboard";
    "ctrl+c" = "copy_and_clear_or_interrupt";
  };

}
