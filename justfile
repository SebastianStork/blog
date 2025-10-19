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

[group('nix')]
update:
    nix flake update --commit-lock-file
