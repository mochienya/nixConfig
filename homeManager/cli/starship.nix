extras@{ pkgs, ... }:
{
  home.packages = [ pkgs.starship ];
  programs.fish.functions.starship_transient_prompt_func.body = "starship module character";
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      # based off of tokyo night preset
      # i wrote this inside the toml file with a `echo "/home/mochie/.config/starship.toml" | entr -c -s "starship prompt"`
      # open side by side, i'm not THAT insane
      format = extras.lib.strings.concatStrings [
        "[](fg:#212736)"
        "[](fg:#394260 bg:#212736)"
        "[ $username$hostname](bg:#394260 fg:#7aa2f7)"
        "[](bg:#7aa2f7 fg:#394260)"
        "$directory"
        "[](fg:#7aa2f7 bg:#394260)"
        "$git_branch"
        "[](fg:#394260 bg:#212736)"
        "$bun"
        "$c"
        "$cpp"
        "$deno"
        "$elixir"
        "$erlang"
        "$golang"
        "$haskell"
        "$java"
        "$kotlin"
        "$lua"
        "$nim"
        "$nodejs"
        "$purescript"
        "$python"
        "$ruby"
        "$rust"
        "$zig"
        "[](fg:#212736 bg:#1d2230)"
        "[ ](fg:#1d2230)"
        "$fill"
        "[](fg:#bb9af7)"
        "$time"
        "[ ](fg:#bb9af7)"
        "\n"
        "$cmd_duration"
        "$character"
      ];

      # things configured in same order they show up
      # except for languages because it's really long

      username = {
        format = "[$user]($style)";
        style_root = "fg:#1a1b26 bg:#394260";
        style_user = "fg:#c0caf5 bg:#394260";
      };

      hostname = {
        trim_at = "";
        format = "[@$hostname](fg:#bb9af7 bg:#394260)";
      };

      directory = {
        style = "fg:#e3e5e5 bg:#7aa2f7";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        format = "[ $symbol $branch (($remote_name)/($remote_branch))](fg:#7aa2f7 bg:#394260)";
      };

      fill = {
        symbol = " ";
      };

      time = {
        disabled = false;
        time_format = "%a %I:%M:%S %p";
        format = "[ $time ](fg:#1a1b26 bg:#bb9af7)";
      };

      cmd_duration = {
        min_time = 0;
        show_milliseconds = true;
        format = "[$duration ](fg:#394260)";
      };

      character = {
        success_symbol = "[ ](fg:#ff9e64)";
        error_symbol = "[ ](fg:#f7768e)";
      };

      # languages (why did i do this to myself)
      # (manually making sure each logo has the correct color)

      bun = {
        format = "[ $symbol ](fg:#fbf0df bg:#212736)";
        symbol = "";
      };

      c = {
        format = "[ $symbol ](fg:#00599d bg:#212736)";
        symbol = "";
      };

      cpp = {
        format = "[ $symbol ](fg:#00599d bg:#212736)";
        symbol = "";
      };

      deno = {
        format = "[ $symbol ](fg:#e3e5e5 bg:#212736)";
        symbol = "";
      };

      elixir = {
        # who needs contrast anyway?
        format = "[ $symbol ](fg:#350a4b bg:#212736)";
        symbol = "";
      };

      erlang = {
        format = "[ $symbol ](fg:#a90432 bg:#212736)";
        symbol = "";
      };

      golang = {
        format = "[ $symbol ](fg:#e3e5e5 bg:#212736)";
        symbol = "󰟓";
      };

      haskell = {
        format = "[ $symbol ](fg:#904d8c bg:#212736)";
        symbol = "";
      };

      java = {
        format = "[ $symbol ](fg:#0d8ac7 bg:#212736)";
        symbol = "";
      };

      kotlin = {
        # not actually the correct color but it was close enough so :3
        format = "[ $symbol ](fg:#e700ff bg:#212736)";
        symbol = "";
      };

      lua = {
        format = "[ $symbol ](fg:#00007f bg:#212736)";
        symbol = "";
      };

      nim = {
        format = "[ $symbol ](fg:#f3d400 bg:#212736)";
        symbol = "";
      };

      nodejs = {
        format = "[ $symbol ](fg:#3178c6 bg:#212736)";
        symbol = "";
      };

      purescript = {
        format = "[ $symbol ](fg:#e3e5e5 bg:#212736)";
        symbol = "";
      };

      python = {
        format = "[ $symbol ](fg:#ffcf43 bg:#212736)";
        symbol = "";
      };

      ruby = {
        format = "[ $symbol ](fg:#ae1908 bg:#212736)";
        symbol = "";
      };

      rust = {
        format = "[ $symbol ](fg:#e3e5e5 bg:#212736)";
        symbol = "";
      };

      zig = {
        format = "[ $symbol ](fg:#f7a41d bg:#212736)";
        symbol = "";
      };
    };
  };

}
