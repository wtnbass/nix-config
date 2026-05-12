{ user, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "${user.home}/.ssh/id_github_personal";
        identitiesOnly = true;
      };
      "github-work" = {
        hostname = "github.com";
        user = "git";
        identityFile = "${user.home}/.ssh/id_github_work";
        identitiesOnly = true;
      };
    };
  };
}
