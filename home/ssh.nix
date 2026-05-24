{ user, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com" = {
        User = "git";
        IdentityFile = "${user.home}/.ssh/id_github_personal";
        IdentitiesOnly = true;
      };
      "github-work" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "${user.home}/.ssh/id_github_work";
        IdentitiesOnly = true;
      };
    };
  };
}
