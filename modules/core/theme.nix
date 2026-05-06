{ config, pkgs, ... }:

{
  # GTK Theme Configuration
  gtk = {
    enable = true;
    
    # 1. 테마 설정 (Ayu Dark)
    theme = {
      name = "Ayu-Dark";
      package = pkgs.ayu-theme-gtk;
    };

    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.theme = config.gtk.theme;

    # 2. 아이콘 설정 (Papirus-Dark with Catppuccin accents)
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    # 3. 커서 설정
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 52;
    };

    font = {
      name = "Maple Mono NF, D2Coding ligature";
      size = 11;
    };
  };

  home.packages = with pkgs; [
    catppuccin-kvantum
    papirus-icon-theme
    adwaita-icon-theme
    hicolor-icon-theme
  ];

  # Qt 앱들을 GTK 테마와 동기화
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "kvantum";
  };

  # dconf 활성화
  dconf.enable = true;

  # dconf 설정으로 GNOME 환경의 아이콘 및 커서 테마 지정
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-size = 52;
      cursor-theme = "Bibata-Modern-Ice";
      icon-theme = "Papirus-Dark";
      gtk-theme = "Ayu-Dark";
    };
  };

  # 커서 테마를 X11과 Wayland 모두에 적용
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 52;
  };

  # 커서 테마 강제 연결 (Legacy 및 XWayland 호환성)
  home.file.".icons/default/index.theme".text = ''
    [icon theme]
    Inherits=Bibata-Modern-Ice
  '';
}
