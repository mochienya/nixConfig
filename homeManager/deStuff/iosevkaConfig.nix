{
  pkgs,
  lib,
  ...
}:

{
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    twitter-color-emoji
    (
      (iosevka.overrideAttrs {
        buildPhase = ''
          export HOME=$TMPDIR
          npm --no-update-notifier run build -- --jCmd=$NIX_BUILD_CORES --verbosity=9 ttf::"$pname" |& cat
        '';
      }).override
      {
        privateBuildPlan = {
          family = "Mochie Iosevka";
          spacing = "fontconfig-mono";
          serifs = "sans";
          noCvSs = false;
          noLigation = false;
          exportGlyphNames = true;

          variants = rec {
            oblique = design;
            italic = design;
            design = {
              one = "base";
              two = "straight-neck-serifless";
              three = "flat-top-serifless";
              four = "closed-serifless";
              five = "upright-flat-serifless";
              six = "straight-bar";
              seven = "straight-serifless";
              eight = "crossing";
              nine = "straight-bar";
              zero = "tall-slashed";
              capital-g = "toothless-corner-inward-serifed-capped";
              capital-i = "serifed";
              capital-j = "serifed-symmetric";
              capital-m = "hanging-serifless";
              capital-q = "crossing";
              capital-r = "straight-serifless";
              a = "double-storey-serifless";
              b = "toothed-serifless";
              d = "toothed-serifless";
              e = "rounded";
              f = "flat-hook-serifed";
              g = "single-storey-serifless";
              i = "serifed";
              j = "serifless";
              k = "symmetric-connected-serifless";
              l = "serifed";
              n = "straight-serifless";
              r = "hookless-serifless";
              t = "flat-hook";
              u = "toothed-serifless";
              v = "straight-serifless";
              x = "straight-serifless";
              y = "curly-serifless";
              punctuation-dot = "round";
              tilde = "low";
              asterisk = "penta-low";
              underscore = "high";
              caret = "medium";
              paren = "normal";
              brace = "straight";
              guillemet = "straight";
              number-sign = "upright";
              at = "fourfold";
              dollar = "interrupted";
              percent = "rings-continuous-slash";
              bar = "natural-slope";
              question = "smooth";
              decorative-angle-brackets = "middle";
              lig-neq = "vertical-dotted";
              lig-equal-chain = "without-notch";
              lig-hyphen-chain = "without-notch";
              lig-plus-chain = "without-notch";
              lig-double-arrow-bar = "without-notch";
              lig-single-arrow-bar = "without-notch";
            };
          };

          ligations.enables = [
            "arrow-l" # Left-pointing arrows.;
            "arrow-r" # Right-pointing arrows.;
            "arrow-lr" # Dual-pointing arrows.;
            "arrow-hyphen" # Arrows using hyphen-minus (`-`) as the rod.;
            "arrow-equal" # Arrows using equal sign (`=`) as the rod.;
            "arrow-wave" # Arrows using tilde (`~`) as the rod.;
            "eqeq" # Enable ligation for `==` and `===`.;
            "lteq" # Enable ligation for `<=` as less-than-or-equal sign.;
            "eqlt" # Enable ligation for `=<` as less-than-or-equal sign.;
            "gteq" # Enable ligation for `>=` as greater-than-or-equal sign.;
            "exeq" # Enable ligation for `!=` and `!==`.;
            "slasheq" # Enable ligation for `/=` and `=/=` as inequality.;
            "trig" # Enable ligation for `<|`, `|>` , `<||`, and other bar-and-angle-bracket symbols.;
            "ltgt-ne" # Enable ligation for `<>` as inequality.
            "ltgt-slash-tag" # Enable ligation for `</`, `/>` and `</>`.;
            "brst" # Center asterisk in `(*` and `*)`.;
            "kern-dotty" # Move connecting dotty punctuations closer, like for `::`, `:::` and `...`.;
            "kern-bars" # Move consecutive bars closer, like for `||`, `|||` and `//`.;
            "center-ops" # Vertically align some of the operators (like `*`) to the center position it is before or after a "center" operator (like `+`).;
            "tilde-tilde" # Make 2 or more contiguous ASCII tildes (like `~~`, `~~~` and `~~~~`) connected as a wave line.;
            "minus-minus-minus" # Make 2 or more contiguous hyphen-minuses (like `--`, `---` and `----`) connected as a straight solid line.;
            "plus-plus" # Make 2 or more contiguous plus signs (like `++`, `+++` and `++++`) connected..;
            "underscore-underscore-underscore" # Make 2 or more contiguous underscores (like `__`, `___` and `____`) connected.;
            "hash-hash" # Make 2 or more contiguous hash signs (number signs) (like `##`, `###` and `####`) connected.;
            "llgg" # Enable ligation for `<<`, `>>` and other angle-bracket chaining.;
            "html-comment" # Enable ligation for `<!--` and `<!---`.
            "brace-bar" # Enable ligation for `{|` and `|}`.
            "brack-bar" # Enable ligation for `[|` and `|]`.
            "markdown-checkboxes" # Enable ligation for Markdown checkboxes like `- [ ]` and `- [x]`.
          ];

          /*
            output is:
            <key> = {
              shape = <value>;
              menu = <value>;
              css = <value>;
            };
          */
          weights =
            lib.mapAttrs
              (_: v: {
                shape = v;
                menu = v;
                css = v;
              })
              {
                Light = 300;
                Regular = 400;
                Medium = 500;
                SemiBold = 600;
                Bold = 700;
              };

          widths.Normal = {
            shape = 500;
            menu = 5;
            css = "normal";
          };

          slopes.Upright = {
            angle = 0;
            shape = "upright";
            menu = "upright";
            css = "normal";
          };

          slopes.Italic = {
            angle = 9.4;
            shape = "italic";
            menu = "italic";
            css = "italic";
          };
        };
      }
    )
  ];
}
