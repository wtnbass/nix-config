{ pkgs, ... }:

{
  # flutter は dart SDK を同梱するため dart は別途入れない。
  home.packages = with pkgs; [
    flutter
    # iOS / macOS ターゲットをビルドするなら有効化する。
    # cocoapods
  ];
}
