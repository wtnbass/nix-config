{ inputs, ... }:

{
  programs.neovim = {
    enable = true;    
    vimAlias = true;
  };
  home.file.".config/nvim".source = inputs.astronvim;
}
