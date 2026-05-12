{ ... }:

{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };

  programs.git = {
    enable = true;

    settings = {
      user.name = "wtnbass";
      user.email = "wtnbass@icloud.com";
      core.editor = "hx";
      merge.ff = "false";
      pull.ff = "only";

      # Ref: https://blog.gitbutler.com/how-git-core-devs-configure-git
      # clearly makes git better
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      init.defaultBranch = "main";
      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = "true";
      diff.renames = "true";
      push.default = "simple";
      push.autoSetupRemote = "true";
      push.followTags = "true";
      fetch.prune = "true";
      fetch.pruneTags = "true";
      fetch.all = "true";

      # why the hell not?
      help.autocorrect = "prompt";
      commit.verbose = "true";
      rerere.enabled = "true";
      rerere.autoupdate = "true";
      core.excludesfile = "~/.gitignore";
      rebase.autoSquash = "true";
      rebase.autoStash = "true";
      rebase.updateRefs = "true";

      # work アカウントの clone を ssh の github-work ホスト (ssh.nix 参照) 経由に書き換える
      "url \"git@github.com:\"".insteadOf = "https://github.com/";
      "url \"git@github-work:EARTHBRAIN/\"".insteadOf = [
        "git@github.com:EARTHBRAIN/"
        "https://github.com/EARTHBRAIN/"
      ];
    };

    includes = [
      {
        condition = "gitdir:~/ghq/github.com/EARTHBRAIN/";
        contents = {
          user.name = "bacwatanabe";
          user.email = "k-watanabe@bac.jp";
        };
      }
      {
        condition = "gitdir:~/ghq/proj.osaka.bac.co.jp/";
        contents = {
          user.name = "watanabe";
          user.email = "k-watanabe@bac.jp";
        };
      }
    ];
  };
}
