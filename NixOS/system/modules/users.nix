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
    # shell = pkgs.${shellName};
    extraGroups = [ "wheel" "networkmanager" "input"  "video" "audio" "adbusers" "docker" "podman" ];
    packages = with pkgs; [
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

}
