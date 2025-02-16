{ pkgs, userConfig, ... }:
let
  shellName = userConfig.shell;
in
{
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.name;
    useDefaultShell = true;
    extraGroups = [ "wheel" "networkmanager" "input"  "video" "audio" "adbusers" "docker" ];
    packages = with pkgs; [
      tdesktop
    ];
  };

  users.users.${userConfig.username2} = {
    isNormalUser = true;
    description = userConfig.name2;
    useDefaultShell = true;
    extraGroups = [ "networkmanager" "input" "video" "audio" ];
    packages = with pkgs; [
    ];
  };

  # shell
  programs.${shellName}.enable = true;
  users.defaultUserShell = pkgs.${shellName};

  # Change runtime directory size
  services.logind.extraConfig = "RuntimeDirectorySize=8G";

  # user pkgs
  programs = {
    adb.enable = true;
  };
}
