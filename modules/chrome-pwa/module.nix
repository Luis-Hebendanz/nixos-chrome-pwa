moduleConfig:
{ config, lib, pkgs, ... }:

with lib;

{
  options.services.chrome-pwa.enable = with types; mkEnableOption "Chrome PWA";

  config = lib.mkIf config.services.chrome-pwa.enable (moduleConfig rec {
    name = "auto-fix-chrome-pwa";
    description = "Automatically fix chromes progressive web apps desktop shortcuts";
    serviceConfig = {
      # When a monitored directory is deleted, it will stop being monitored.
      # Even if it is later recreated it will not restart monitoring it.
      # Unfortunately the monitor does not kill itself when it stops monitoring,
      # so rather than creating our own restart mechanism, we leverage systemd to do this for us.
      Restart = "always";
      RestartSec = 0;
      ExecStart = "${pkgs.writeShellScript "${name}.sh" ''
        set -euo pipefail
        PATH=${makeBinPath (with pkgs; [ coreutils findutils inotify-tools ])}
        places=( ~/.local/share/applications ~/.gnome/apps/ ~/Desktop/ )

        while true
        do
            result=$(inotifywait -e CREATE --include "\.desktop$" "''${places[@]}")
            file=$(echo "$result" | cut --field 3 --delimiter " ")
            echo "File: $file"
            sleep 0.2
            for desk in "''${places[@]}"; do
                target="$desk/$file"
                echo "Desk File: $target"
                sed -i 's/Exec=.*\//Exec=/g' "$target"
                sed -i 's/\#\!.*\//\#\!\/usr\/bin\/env /g' "$target"
            done
        done
      ''}";
    };
  });
}
