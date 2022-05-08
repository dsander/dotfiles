
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
    pkgs.phantomjs2
    pkgs.dive
    pkgs.speedtest-cli
    pkgs.act
    pkgs.heroku
    pkgs.ansible
    pkgs.terraform
    pkgs.gitAndTools.delta
    pkgs.youtube-dl
  ];
}
