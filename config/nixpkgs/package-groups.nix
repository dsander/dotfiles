
{ pkgs, ... }:
{
  base = [
    pkgs.htop
    pkgs.ripgrep
    pkgs.jq
    pkgs.neovim
    pkgs.gitAndTools.delta
  ];
  test = [
    pkgs.dive
  ];
  dev = [
    pkgs.dive
    pkgs.speedtest-cli
    pkgs.act
    pkgs.heroku
    pkgs.ansible
    pkgs.ansible-lint
    pkgs.terraform
    pkgs.youtube-dl
    pkgs.act
    pkgs.sshfs
  ];
}
