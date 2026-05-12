{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jdk
    jdt-language-server
    maven
    gradle
    kotlin
    kotlin-language-server
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk.home}";
  };
}
