set quiet := true

list:
    just --list --unsorted

fmt:
    nix fmt

[group('zola')]
serve:
    zola serve --drafts --open

[group('zola')]
check:
    zola check --drafts

[group('zola')]
update-theme:
    nix flake update linkita
    nix develop --command zsh

[group('nix')]
update:
    nix flake update nixpkgs treefmt --commit-lock-file
