let
  # `ssh-keygen -y -f ~/.ssh/id_ed25519` などで取得した公開鍵を貼る
  wtnbass = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4Q8XSnzicCv6dB/PMrsWW411Z1vPUFkInQ+eJd9yuN agenix@k-watanabe";
  users = [ wtnbass ];
in
{
  "ssh_github_personal.age".publicKeys = users;
  "ssh_github_work.age".publicKeys = users;
}
