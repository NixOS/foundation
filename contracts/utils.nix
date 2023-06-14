let
  inherit (builtins) head tail map filter isList split concatStringsSep;
in
rec {
  splitLines = s: filter (x: !isList x) (split "\n" s);

  indent = prefix: s:
    concatStringsSep "\n" (map (x: if x == "" then x else "${prefix}${x}") (splitLines s));

  # unordered list item
  ul = x: "-" + builtins.substring 1 (-1) (indent "  " x);

  # ordered list item
  ol = x: "1." + builtins.substring 2 (-1) (indent "   " x);
}
