{
  description = "Mike's darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  let
    configuration = { pkgs, config, ... }: {
      
      nixpkgs.config.allowUnfree = true;

      ############
      #  System  #
      ############

       system = {
        activationScripts.postActivation.text = ''
          ###############################################################################
          # General UI/UX                                                               #
          ###############################################################################
          # Disable UI alert audio
          defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0
          # Shows battery percentage
          defaults write com.apple.menuextra.battery ShowPercent YES; killall SystemUIServer
          # Increase sound quality for Bluetooth headphones/headsets
          defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
        '';
      };

      # programs.git = {
      #   enable = true;
      #   userName  = "ammichael";
      #   userEmail = "michael.amaral@platformbuilders.io";
      # };

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.mkalias
          pkgs.neovim
          pkgs.neofetch
          pkgs.alacritty
          pkgs.obsidian
          pkgs.vscode
          pkgs.yarn
          pkgs.cocoapods
          pkgs.watchman
          pkgs.pyenv
          pkgs.fastlane
          pkgs.zsh
          pkgs.yt-dlp
          pkgs.postman
          pkgs.flutter
          pkgs.fira-code
          pkgs.jdk
          pkgs.raycast
          pkgs.ffmpeg
          pkgs.gh
          pkgs.arc-browser
          pkgs.mas
          pkgs.aldente
        ];

      # Homebrew Apps
      
      homebrew = {
        enable = false;
        brews = [
          "nvm"
        ];
        casks = [
          "arc"
          "notion"
          "notion-calendar"
          "clop"
          "numi"
          "displaylink"
          "sourcetree"
          "figma"
          "android-studio"
        ];
        masApps = { 
          "WhatsApp" = 1147396723;
          "Slack" = 803453959;
          "Spark" = 6445813049;
          "TextSnipper" = 1528890965;
          "Affinity Designer" = 824183456;
          "Safari Adblock" = 1402042596;
          "Windows App" = 1295203466;
          "Hidden Bar" = 1452453066;
        };
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };
        global = {
          autoUpdate = true;
          brewfile = true;
          lockfiles = true;
    };
      };

      # Custom fonts
      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = ["JetBrainsMono"]; })
      ];

      # Mac system preferences

      system.defaults = {
        dock = {
          # auto show and hide dock
          autohide = true;
          # remove delay for showing dock
          autohide-delay = 0.0;
          # how fast is the dock showing animation
          autohide-time-modifier = 0.2;
          expose-animation-duration = 0.2;
          tilesize = 48;
          launchanim = false;
          static-only = false;
          show-recents = false;
          show-process-indicators = true;
          orientation = "bottom";
          mru-spaces = false;
        };
        dock.persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/Applications/Arc.app"
          "/System/Applications/Messages.app"
          "/Applications/WhatsApp.app"
          "/Applications/Slack.app"
          "/Applications/Spark Desktop.app"
          "/Applications/ChatGPT.app"
          "/Applications/Figma.app"
          "/Applications/Notion.app"
          "/Applications/Notion Calendar.app"
          "/Applications/Sourcetree.app"
          "/Applications/Cursor.app"
          "/System/Applications/Utilities/Terminal.app"
          "/System/Applications/iPhone Mirroring.app"
        ];
        NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";
          ApplePressAndHoldEnabled = true;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          "com.apple.trackpad.scaling" = 2.5;
        };

      CustomUserPreferences = {
          NSGlobalDomain = {
            # Add a context menu item for showing the Web Inspector in web views
            WebKitDeveloperExtras = true;
          };
          "com.apple.finder" = {
            ShowExternalHardDrivesOnDesktop = true;
            ShowHardDrivesOnDesktop = true;
            ShowMountedServersOnDesktop = true;
            ShowRemovableMediaOnDesktop = true;
            _FXSortFoldersFirst = true;
            # When performing a search, search the current folder by default
            FXDefaultSearchScope = "SCcf";
          };
          "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          "com.apple.screensaver" = {
            # Require password immediately after sleep or screen saver begins
            askForPassword = 1;
            askForPasswordDelay = 0;
          };
          "com.apple.screencapture" = {
            location = "~/Desktop";
            type = "png";
            
          };
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
          "com.apple.print.PrintingPrefs" = {
            # Automatically quit printer app once the print jobs complete
            "Quit When Finished" = true;
          };
          "com.apple.SoftwareUpdate" = {
            AutomaticCheckEnabled = true;
            # Check for software updates daily, not just once per week
            ScheduleFrequency = 1;
            # Download newly available updates in background
            AutomaticDownload = 1;
            # Install System data files & security updates
            CriticalUpdateInstall = 1;
          };
          "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
          # Prevent Photos from opening automatically when devices are plugged in
          "com.apple.ImageCapture".disableHotPlug = true;
          # Turn on app auto-update
          "com.apple.commerce".AutoUpdate = true;
        };
      };


      # Fixing mac symlink applications
      system.activationScripts.applications.text = let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in
      pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
          '';

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh = {
        enable = true;
        enableBashCompletion = true;
        enableCompletion = true;
      };
      users.users.mike = {
        name = "mike";
        home = "/Users/mike";
    };

      # ZSH init
 
      # programs.zsh.initExtraFirst = ''
      #   # Amazon Q pre block. Keep at the top of this file.
      #   # If you come from bash you might have to change your $PATH.
      #   # export PATH=$HOME/bin:/usr/local/bin:$PATH

      #   # Path to your oh-my-zsh installation.
      #   export ZSH="$HOME/.oh-my-zsh"

      #   # Set name of the theme to load --- if set to "random", it will
      #   # load a random theme each time oh-my-zsh is loaded, in which case,
      #   # to know which specific one was loaded, run: echo $RANDOM_THEME
      #   # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
      #   ZSH_THEME="robbyrussell"

      #   # Set list of themes to pick from when loading at random
      #   # Setting this variable when ZSH_THEME=random will cause zsh to load
      #   # a theme from this variable instead of looking in $ZSH/themes/
      #   # If set to an empty array, this variable will have no effect.
      #   # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

      #   # Uncomment the following line to use case-sensitive completion.
      #   # CASE_SENSITIVE="true"

      #   # Uncomment the following line to use hyphen-insensitive completion.
      #   # Case-sensitive completion must be off. _ and - will be interchangeable.
      #   # HYPHEN_INSENSITIVE="true"

      #   # Uncomment one of the following lines to change the auto-update behavior
      #   # zstyle ':omz:update' mode disabled  # disable automatic updates
      #   # zstyle ':omz:update' mode auto      # update automatically without asking
      #   # zstyle ':omz:update' mode reminder  # just remind me to update when it's time

      #   # Uncomment the following line to change how often to auto-update (in days).
      #   # zstyle ':omz:update' frequency 13

      #   # Uncomment the following line if pasting URLs and other text is messed up.
      #   # DISABLE_MAGIC_FUNCTIONS="true"

      #   # Uncomment the following line to disable colors in ls.
      #   # DISABLE_LS_COLORS="true"

      #   # Uncomment the following line to disable auto-setting terminal title.
      #   # DISABLE_AUTO_TITLE="true"

      #   # Uncomment the following line to enable command auto-correction.
      #   # ENABLE_CORRECTION="true"

      #   # Uncomment the following line to display red dots whilst waiting for completion.
      #   # You can also set it to another string to have that shown instead of the default red dots.
      #   # e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
      #   # Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
      #   # COMPLETION_WAITING_DOTS="true"

      #   # Uncomment the following line if you want to disable marking untracked files
      #   # under VCS as dirty. This makes repository status check for large repositories
      #   # much, much faster.
      #   # DISABLE_UNTRACKED_FILES_DIRTY="true"

      #   # Uncomment the following line if you want to change the command execution time
      #   # stamp shown in the history command output.
      #   # You can set one of the optional three formats:
      #   # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
      #   # or set a custom format using the strftime function format specifications,
      #   # see 'man strftime' for details.
      #   # HIST_STAMPS="mm/dd/yyyy"

      #   # Would you like to use another custom folder than $ZSH/custom?
      #   # ZSH_CUSTOM=/path/to/new-custom-folder

      #   # Which plugins would you like to load?
      #   # Standard plugins can be found in $ZSH/plugins/
      #   # Custom plugins may be added to $ZSH_CUSTOM/plugins/
      #   # Example format: plugins=(rails git textmate ruby lighthouse)
      #   # Add wisely, as too many plugins slow down shell startup.
      #   plugins=(git poetry)

      #   source $ZSH/oh-my-zsh.sh

      #   # User configuration

      #   # export MANPATH="/usr/local/man:$MANPATH"

      #   # You may need to manually set your language environment
      #   # export LANG=en_US.UTF-8

      #   # Preferred editor for local and remote sessions
      #   # if [[ -n $SSH_CONNECTION ]]; then
      #   #   export EDITOR='vim'
      #   # else
      #   #   export EDITOR='mvim'
      #   # fi

      #   # Compilation flags
      #   # export ARCHFLAGS="-arch x86_64"

      #   # Set personal aliases, overriding those provided by oh-my-zsh libs,
      #   # plugins, and themes. Aliases can be placed here, though oh-my-zsh
      #   # users are encouraged to define aliases within the ZSH_CUSTOM folder.
      #   # For a full list of active aliases, run `alias`.
      #   #
      #   # Example aliases
      #   # alias zshconfig="mate ~/.zshrc"
      #   # alias ohmyzsh="mate ~/.oh-my-zsh"
      #   # SSH
      #   eval "$(ssh-agent -s)"
      #   ssh-add ~/.ssh/id_rsa

      #   # NVM
      #   export NVM_DIR=~/.nvm
      #   source $(brew --prefix nvm)/nvm.sh
      #   export ANDROID_HOME=$HOME/Library/Android/sdk
      #   export PATH=$PATH:$ANDROID_HOME/platform-tools
      #   export PATH=$PATH:$ANDROID_HOME/tools
      #   export PATH=$PATH:$ANDROID_HOME/tools/bin
      #   export PATH=$PATH:$ANDROID_HOME/emulator
      #   # NVM
      #   export NVM_DIR=~/.nvm
      #   source $(brew --prefix nvm)/nvm.sh
      #   export ANDROID_HOME=$HOME/Library/Android/sdk
      #   export PATH=$PATH:$ANDROID_HOME/platform-tools
      #   export PATH=$PATH:$ANDROID_HOME/tools
      #   export PATH=$PATH:$ANDROID_HOME/tools/bin
      #   export PATH=$PATH:$ANDROID_HOME/emulator
      #   # NVM
      #   export NVM_DIR=~/.nvm
      #   source $(brew --prefix nvm)/nvm.sh
      #   export ANDROID_HOME=$HOME/Library/Android/sdk
      #   export PATH=$PATH:$ANDROID_HOME/platform-tools
      #   export PATH=$PATH:$ANDROID_HOME/tools
      #   export PATH=$PATH:$ANDROID_HOME/tools/bin
      #   export PATH=$PATH:$ANDROID_HOME/emulator
      #   # NVM
      #   export NVM_DIR=~/.nvm
      #   source $(brew --prefix nvm)/nvm.sh
      #   export ANDROID_HOME=$HOME/Library/Android/sdk
      #   export PATH=$PATH:$ANDROID_HOME/platform-tools
      #   export PATH=$PATH:$ANDROID_HOME/tools
      #   export PATH=$PATH:$ANDROID_HOME/tools/bin
      #   export PATH=$PATH:$ANDROID_HOME/emulator

      #   # SSH
      #   eval "$(ssh-agent -s)"
      #   ssh-add ~/.ssh/id_rsa

      #   # Amazon Q post block. Keep at the bottom of this file.


      # '';

      # programs.fish.enable = true;
 
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.activationScripts.postUserActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
    
    
    
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            # enableRosetta = true;

            # User owning the Homebrew prefix
            user = "mike";

            # Automatically migrate existing Homebrew installations
            autoMigrate = true;
          };
        }
      ];
    };

    # Enable sudo authentication with Touch ID  
    security.pam.enableSudoTouchIdAuth = true;

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."macbookpro".pkgs;
  };

  
}
