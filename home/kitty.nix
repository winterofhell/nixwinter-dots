{ ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };

    settings = {
      background_blur = 24;
      auto_reload_config = 0.1;
      background_opacity = "0.94";
      confirm_os_window_close = 0;
      copy_on_select = "clipboard";
      cursor_blink_interval = "0.5";
      cursor_shape = "beam";
      cursor_stop_blinking_after = 0;
      cursor_trail = 1;
      disable_ligatures = "never";
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      inactive_tab_font_style = "normal";
      active_tab_font_style = "bold";
      initial_window_height = "32c";
      initial_window_width = "120c";
      mouse_hide_wait = "2.0";
      open_url_with = "default";
      remember_window_size = true;
      scrollback_lines = 20000;
      shell_integration = "enabled";
      strip_trailing_spaces = "smart";
      tab_bar_edge = "bottom";
      tab_bar_min_tabs = 2;
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      url_style = "curly";
      visual_bell_duration = "0.0";
      wheel_scroll_multiplier = "5.0";
      window_margin_width = 0;
      window_padding_width = 14;
    };

    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+v" = "paste_from_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "shift+insert" = "paste_from_clipboard";
      "ctrl+f" = "search_scrollback";
      "page_up" = "scroll_page_up";
      "page_down" = "scroll_page_down";
      "ctrl+home" = "scroll_home";
      "ctrl+end" = "scroll_end";
      "ctrl+page_up" = "scroll_page_up";
      "ctrl+page_down" = "scroll_page_down";
      "ctrl+shift+n" = "new_os_window_with_cwd";
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+w" = "close_window";
      "ctrl+tab" = "next_tab";
      "ctrl+shift+tab" = "previous_tab";
      "ctrl+plus" = "change_font_size all +1";
      "ctrl+equal" = "change_font_size all +1";
      "ctrl+kp_add" = "change_font_size all +1";
      "ctrl+minus" = "change_font_size all -1";
      "ctrl+underscore" = "change_font_size all -1";
      "ctrl+kp_subtract" = "change_font_size all -1";
      "ctrl+0" = "change_font_size all 0";
      "ctrl+kp_0" = "change_font_size all 0";
      "ctrl+backspace" = "send_text all \\x17";
      "ctrl+delete" = "send_text all \\x1b[3;5~";
      "f7" = "show_scrollback";
      "ctrl+shift+g" = "show_last_command_output";
    };
  };
}
