#!/usr/bin/env bash

COMPUTER_NAME="$1"

###############################################################################
# 📱 Dock
###############################################################################

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock tilesize -int 42
defaults write com.apple.dock largesize -int 52
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock show-process-indicators -bool true

## Adjust Dock apps

defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-apps -array-add '{
	GUID = 1706943345;
	"tile-data" = {
		book = <626f6f6b e8020000 00000410 30000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 08020000 0c000000 01010000 4170706c 69636174 696f6e73 11000000 01010000 476f6f67 6c652043 68726f6d 652e6170 70000000 08000000 01060000 04000000 18000000 08000000 04030000 d4010000 00000000 08000000 04030000 f91c6e00 00000000 08000000 01060000 44000000 54000000 08000000 00040000 41c2195e f9800000 18000000 01020000 02000000 00000000 0f000000 00000000 00000000 00000000 08000000 01090000 66696c65 3a2f2f2f 06000000 01010000 53797374 656d0000 08000000 04030000 0050065e 3a000000 08000000 00040000 41c1f013 8a49e636 24000000 01010000 36384230 37343337 2d453746 332d3437 31352d38 4130442d 36413837 37383636 41344643 18000000 01020000 81000000 01000000 ef130000 01000000 00000000 00000000 01000000 01010000 2f000000 00000000 01050000 b9000000 01020000 37303234 36313737 36346464 64636263 38363030 34663063 66386264 66633365 33636239 38356461 3b30303b 30303030 30303030 3b303030 30303030 303b3030 30303030 30303b30 30303030 30303030 30303030 3032303b 636f6d2e 6170706c 652e6170 702d7361 6e64626f 782e7265 61642d77 72697465 3b30313b 30313030 30303034 3b303030 30303030 30303036 65316366 393b3031 3b2f6170 706c6963 6174696f 6e732f67 6f6f676c 65206368 726f6d65 2e617070 00000000 a8000000 feffffff 01000000 00000000 0d000000 04100000 34000000 00000000 05100000 64000000 00000000 10100000 84000000 00000000 40100000 74000000 00000000 02200000 30010000 00000000 05200000 a4000000 00000000 10200000 b4000000 00000000 11200000 e4000000 00000000 12200000 c4000000 00000000 13200000 d4000000 00000000 20200000 10010000 00000000 30200000 3c010000 00000000 80f00000 44010000 00000000>;
		"bundle-identifier" = "com.google.Chrome";
		"dock-extra" = 0;
		"file-data" = {
			"_CFURLString" = "file:///Applications/Google%20Chrome.app/";
			"_CFURLStringType" = 15;
		};
		"file-label" = "Google Chrome";
		"file-mod-date" = 3668457203;
		"file-type" = 1;
		"parent-mod-date" = 26692596336025;
	};
	"tile-type" = "file-tile";
}'
defaults write com.apple.dock persistent-apps -array-add '{
	GUID = 1992394298;
	"tile-data" = {
		book = <626f6f6b dc020000 00000410 30000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 fc010000 0c000000 01010000 4170706c 69636174 696f6e73 09000000 01010000 536c6163 6b2e6170 70000000 08000000 01060000 04000000 18000000 08000000 04030000 8d010000 00000000 08000000 04030000 c0d80c00 00000000 08000000 01060000 3c000000 4c000000 08000000 00040000 41c0aeb3 f3000000 18000000 01020000 02000000 00000000 0f000000 00000000 00000000 00000000 08000000 01090000 66696c65 3a2f2f2f 0c000000 01010000 536f6d61 63686967 756e4844 08000000 04030000 008088e0 2e000000 08000000 00040000 41c0bf74 ef2f0619 24000000 01010000 43353444 35374542 2d394543 352d3430 38452d39 4439412d 41423738 33363042 30314638 18000000 01020000 81000000 01000000 ef130000 01000000 00000000 00000000 01000000 01010000 2f000000 00000000 01050000 b1000000 01020000 63636539 64343638 38306439 38373634 38326239 61613061 62643262 37653731 35633230 62393666 3b30303b 30303030 30303030 3b303030 30303030 303b3030 30303030 30303b30 30303030 30303030 30303030 3032303b 636f6d2e 6170706c 652e6170 702d7361 6e64626f 782e7265 61642d77 72697465 3b30313b 30313030 30303036 3b303030 30303030 30303030 63643863 303b3031 3b2f6170 706c6963 6174696f 6e732f73 6c61636b 2e617070 00000000 a8000000 feffffff 01000000 00000000 0d000000 04100000 2c000000 00000000 05100000 5c000000 00000000 10100000 7c000000 00000000 40100000 6c000000 00000000 02200000 2c010000 00000000 05200000 9c000000 00000000 10200000 ac000000 00000000 11200000 e0000000 00000000 12200000 c0000000 00000000 13200000 d0000000 00000000 20200000 0c010000 00000000 30200000 38010000 00000000 80f00000 40010000 00000000>;
		"bundle-identifier" = "com.tinyspeck.slackmacgap";
		"dock-extra" = 0;
		"file-data" = {
			"_CFURLString" = "file:///Applications/Slack.app/";
			"_CFURLStringType" = 15;
		};
		"file-label" = Slack;
		"file-mod-date" = 0;
		"file-type" = 1;
		"parent-mod-date" = 0;
	};
	"tile-type" = "file-tile";
}'
defaults write com.apple.dock persistent-apps -array-add '{
	GUID = 1706943353;
	"tile-data" = {
		book = <626f6f6b f0020000 00000410 30000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 10020000 0c000000 01010000 4170706c 69636174 696f6e73 16000000 01010000 56697375 616c2053 74756469 6f20436f 64652e61 70700000 08000000 01060000 04000000 18000000 08000000 04030000 d4010000 00000000 08000000 04030000 66336600 00000000 08000000 01060000 48000000 58000000 08000000 00040000 41c21496 fc000000 18000000 01020000 02000000 00000000 0f000000 00000000 00000000 00000000 08000000 01090000 66696c65 3a2f2f2f 06000000 01010000 53797374 656d0000 08000000 04030000 0050065e 3a000000 08000000 00040000 41c1f013 8a49e636 24000000 01010000 36384230 37343337 2d453746 332d3437 31352d38 4130442d 36413837 37383636 41344643 18000000 01020000 81000000 01000000 ef130000 01000000 00000000 00000000 01000000 01010000 2f000000 00000000 01050000 be000000 01020000 39383732 65306364 62653236 64363634 35343235 32366666 34613635 66356630 33373539 34626635 3b30303b 30303030 30303030 3b303030 30303030 303b3030 30303030 30303b30 30303030 30303030 30303030 3032303b 636f6d2e 6170706c 652e6170 702d7361 6e64626f 782e7265 61642d77 72697465 3b30313b 30313030 30303034 3b303030 30303030 30303036 36333336 363b3031 3b2f6170 706c6963 6174696f 6e732f76 69737561 6c207374 7564696f 20636f64 652e6170 70000000 a8000000 feffffff 01000000 00000000 0d000000 04100000 38000000 00000000 05100000 68000000 00000000 10100000 88000000 00000000 40100000 78000000 00000000 02200000 34010000 00000000 05200000 a8000000 00000000 10200000 b8000000 00000000 11200000 e8000000 00000000 12200000 c8000000 00000000 13200000 d8000000 00000000 20200000 14010000 00000000 30200000 40010000 00000000 80f00000 48010000 00000000>;
		"bundle-identifier" = "com.microsoft.VSCode";
		"dock-extra" = 0;
		"file-data" = {
			"_CFURLString" = "file:///Applications/Visual%20Studio%20Code.app/";
			"_CFURLStringType" = 15;
		};
		"file-label" = "Visual Studio Code";
		"file-mod-date" = 3667830520;
		"file-type" = 1;
		"parent-mod-date" = 51706485868096;
	};
	"tile-type" = "file-tile";
}'
defaults write com.apple.dock persistent-apps -array-add '{
	GUID = 1706943357;
	"tile-data" = {
		book = <626f6f6b d8020000 00000410 30000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 f8010000 0c000000 01010000 4170706c 69636174 696f6e73 09000000 01010000 69546572 6d2e6170 70000000 08000000 01060000 04000000 18000000 08000000 04030000 d4010000 00000000 08000000 04030000 b1583400 00000000 08000000 01060000 3c000000 4c000000 08000000 00040000 41c1fa5d c3000000 18000000 01020000 02000000 00000000 0f000000 00000000 00000000 00000000 08000000 01090000 66696c65 3a2f2f2f 06000000 01010000 53797374 656d0000 08000000 04030000 0050065e 3a000000 08000000 00040000 41c1f013 8a49e636 24000000 01010000 36384230 37343337 2d453746 332d3437 31352d38 4130442d 36413837 37383636 41344643 18000000 01020000 81000000 01000000 ef130000 01000000 00000000 00000000 01000000 01010000 2f000000 00000000 01050000 b1000000 01020000 30666631 66323630 30313436 35363762 36393238 32356637 63646166 30313930 30333637 35623933 3b30303b 30303030 30303030 3b303030 30303030 303b3030 30303030 30303b30 30303030 30303030 30303030 3032303b 636f6d2e 6170706c 652e6170 702d7361 6e64626f 782e7265 61642d77 72697465 3b30313b 30313030 30303034 3b303030 30303030 30303033 34353862 313b3031 3b2f6170 706c6963 6174696f 6e732f69 7465726d 2e617070 00000000 a8000000 feffffff 01000000 00000000 0d000000 04100000 2c000000 00000000 05100000 5c000000 00000000 10100000 7c000000 00000000 40100000 6c000000 00000000 02200000 28010000 00000000 05200000 9c000000 00000000 10200000 ac000000 00000000 11200000 dc000000 00000000 12200000 bc000000 00000000 13200000 cc000000 00000000 20200000 08010000 00000000 30200000 34010000 00000000 80f00000 3c010000 00000000>;
		"bundle-identifier" = "com.googlecode.iterm2";
		"dock-extra" = 0;
		"file-data" = {
			"_CFURLString" = "file:///Applications/iTerm.app/";
			"_CFURLStringType" = 15;
		};
		"file-label" = iTerm;
		"file-mod-date" = 3664393350;
		"file-type" = 1;
		"parent-mod-date" = 51706485868096;
	};
	"tile-type" = "file-tile";
}'
defaults write com.apple.dock persistent-apps -array-add '{
  GUID = 1706943393;
  "tile-data" = {
      book = <626f6f6b e0020000 00000410 30000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00020000 0c000000 01010000 4170706c 69636174 696f6e73 0d000000 01010000 42697477 61726465 6e2e6170 70000000 08000000 01060000 04000000 18000000 08000000 04030000 d4010000 00000000 08000000 04030000 a83c6300 00000000 08000000 01060000 40000000 50000000 08000000 00040000 41c21527 21000000 18000000 01020000 02000000 00000000 0f000000 00000000 00000000 00000000 08000000 01090000 66696c65 3a2f2f2f 06000000 01010000 53797374 656d0000 08000000 04030000 0050065e 3a000000 08000000 00040000 41c1f013 8a49e636 24000000 01010000 36384230 37343337 2d453746 332d3437 31352d38 4130442d 36413837 37383636 41344643 18000000 01020000 81000000 01000000 ef130000 01000000 00000000 00000000 01000000 01010000 2f000000 00000000 01050000 b5000000 01020000 38313166 65656435 32323762 63636532 35393335 30663836 61633466 33303435 63393863 65643233 3b30303b 30303030 30303030 3b303030 30303030 303b3030 30303030 30303b30 30303030 30303030 30303030 3032303b 636f6d2e 6170706c 652e6170 702d7361 6e64626f 782e7265 61642d77 72697465 3b30313b 30313030 30303034 3b303030 30303030 30303036 33336361 383b3031 3b2f6170 706c6963 6174696f 6e732f62 69747761 7264656e 2e617070 00000000 a8000000 feffffff 01000000 00000000 0d000000 04100000 30000000 00000000 05100000 60000000 00000000 10100000 80000000 00000000 40100000 70000000 00000000 02200000 2c010000 00000000 05200000 a0000000 00000000 10200000 b0000000 00000000 11200000 e0000000 00000000 12200000 c0000000 00000000 13200000 d0000000 00000000 20200000 0c010000 00000000 30200000 38010000 00000000 80f00000 40010000 00000000>;
      "bundle-identifier" = "com.bitwarden.desktop";
      "dock-extra" = 0;
      "file-data" = {
          "_CFURLString" = "file:///Applications/Bitwarden.app/";
          "_CFURLStringType" = 15;
      };
      "file-label" = Bitwarden;
      "file-mod-date" = 3667904322;
      "file-type" = 1;
      "parent-mod-date" = 247965016939807;
  };
  "tile-type" = "file-tile";
}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{
  GUID = 1706943396;
  "tile-data" =             {
      book = <626f6f6b d8020000 00000410 30000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 f8010000 0c000000 01010000 4170706c 69636174 696f6e73 0c000000 01010000 57686174 73417070 2e617070 08000000 01060000 04000000 18000000 08000000 04030000 d4010000 00000000 08000000 04030000 dbb77400 00000000 08000000 01060000 3c000000 4c000000 08000000 00040000 41c1f480 e4800000 18000000 01020000 02000000 00000000 0f000000 00000000 00000000 00000000 08000000 01090000 66696c65 3a2f2f2f 06000000 01010000 53797374 656d0000 08000000 04030000 0050065e 3a000000 08000000 00040000 41c1f013 8a49e636 24000000 01010000 36384230 37343337 2d453746 332d3437 31352d38 4130442d 36413837 37383636 41344643 18000000 01020000 81000000 01000000 ef130000 01000000 00000000 00000000 01000000 01010000 2f000000 00000000 01050000 b4000000 01020000 38333836 39623163 39656166 33366137 30386239 65393432 32316461 35333432 31623764 31306666 3b30303b 30303030 30303030 3b303030 30303030 303b3030 30303030 30303b30 30303030 30303030 30303030 3032303b 636f6d2e 6170706c 652e6170 702d7361 6e64626f 782e7265 61642d77 72697465 3b30313b 30313030 30303034 3b303030 30303030 30303037 34623764 623b3031 3b2f6170 706c6963 6174696f 6e732f77 68617473 6170702e 61707000 a8000000 feffffff 01000000 00000000 0d000000 04100000 2c000000 00000000 05100000 5c000000 00000000 10100000 7c000000 00000000 40100000 6c000000 00000000 02200000 28010000 00000000 05200000 9c000000 00000000 10200000 ac000000 00000000 11200000 dc000000 00000000 12200000 bc000000 00000000 13200000 cc000000 00000000 20200000 08010000 00000000 30200000 34010000 00000000 80f00000 3c010000 00000000>;
      "bundle-identifier" = WhatsApp;
      "dock-extra" = 0;
      "file-data" =                 {
          "_CFURLString" = "file:///Applications/WhatsApp.app/";
          "_CFURLStringType" = 15;
      };
      "file-label" = WhatsApp;
      "file-mod-date" = 3663624905;
      "file-type" = 1;
      "parent-mod-date" = 51302759423395;
  };
  "tile-type" = "file-tile";
}'
defaults write com.apple.dock persistent-apps -array-add '{
  GUID = 1706943392;
  "tile-data" =             {
      book = <626f6f6b d8020000 00000410 30000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 f8010000 0c000000 01010000 4170706c 69636174 696f6e73 0c000000 01010000 54656c65 6772616d 2e617070 08000000 01060000 04000000 18000000 08000000 04030000 d4010000 00000000 08000000 04030000 a9887400 00000000 08000000 01060000 3c000000 4c000000 08000000 00040000 41c2190d f3800000 18000000 01020000 02000000 00000000 0f000000 00000000 00000000 00000000 08000000 01090000 66696c65 3a2f2f2f 06000000 01010000 53797374 656d0000 08000000 04030000 0050065e 3a000000 08000000 00040000 41c1f013 8a49e636 24000000 01010000 36384230 37343337 2d453746 332d3437 31352d38 4130442d 36413837 37383636 41344643 18000000 01020000 81000000 01000000 ef130000 01000000 00000000 00000000 01000000 01010000 2f000000 00000000 01050000 b4000000 01020000 37353839 36383931 64653233 36333363 30336435 31356537 65616363 65353564 35356433 38346365 3b30303b 30303030 30303030 3b303030 30303030 303b3030 30303030 30303b30 30303030 30303030 30303030 3032303b 636f6d2e 6170706c 652e6170 702d7361 6e64626f 782e7265 61642d77 72697465 3b30313b 30313030 30303034 3b303030 30303030 30303037 34383861 393b3031 3b2f6170 706c6963 6174696f 6e732f74 656c6567 72616d2e 61707000 a8000000 feffffff 01000000 00000000 0d000000 04100000 2c000000 00000000 05100000 5c000000 00000000 10100000 7c000000 00000000 40100000 6c000000 00000000 02200000 28010000 00000000 05200000 9c000000 00000000 10200000 ac000000 00000000 11200000 dc000000 00000000 12200000 bc000000 00000000 13200000 cc000000 00000000 20200000 08010000 00000000 30200000 34010000 00000000 80f00000 3c010000 00000000>;
      "bundle-identifier" = "ru.keepcoder.Telegram";
      "dock-extra" = 0;
      "file-data" =                 {
          "_CFURLString" = "file:///Applications/Telegram.app/";
          "_CFURLStringType" = 15;
      };
      "file-label" = Telegram;
      "file-mod-date" = 3668415719;
      "file-type" = 1;
      "parent-mod-date" = 247965016939807;
  };
  "tile-type" = "file-tile";
}'
defaults write com.apple.dock persistent-apps -array-add '{
  GUID = 2882508106;
  "tile-data" =             {
      book = <626f6f6b e8020000 00000410 30000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 08020000 0c000000 01010000 4170706c 69636174 696f6e73 16000000 01010000 53797374 656d2050 72656665 72656e63 65732e61 70700000 08000000 01060000 04000000 18000000 08000000 04030000 d4010000 00000000 08000000 04030000 14170100 00000000 08000000 01060000 48000000 58000000 08000000 00040000 41c12961 d3800000 18000000 01020000 02000000 00000000 0f000000 00000000 00000000 00000000 08000000 01090000 66696c65 3a2f2f2f 06000000 01010000 53797374 656d0000 08000000 04030000 0050065e 3a000000 08000000 00040000 41c1f013 8a49e636 24000000 01010000 36384230 37343337 2d453746 332d3437 31352d38 4130442d 36413837 37383636 41344643 18000000 01020000 81000000 01000000 ef130000 01000000 00000000 00000000 01000000 01010000 2f000000 00000000 01050000 b8000000 01020000 31323436 34326661 61386366 38306666 39653164 34323335 31653731 33656433 38393063 65633334 3b30303b 30303030 30303030 3b303030 30303030 303b3030 30303030 30303b30 30303030 30303030 30303030 3031613b 636f6d2e 6170706c 652e6170 702d7361 6e64626f 782e7265 61643b30 313b3031 30303030 30343b30 30303030 30303030 30303131 3731343b 30353b2f 6170706c 69636174 696f6e73 2f737973 74656d20 70726566 6572656e 6365732e 61707000 a8000000 feffffff 01000000 00000000 0d000000 04100000 38000000 00000000 05100000 68000000 00000000 10100000 88000000 00000000 40100000 78000000 00000000 02200000 34010000 00000000 05200000 a8000000 00000000 10200000 b8000000 00000000 11200000 e8000000 00000000 12200000 c8000000 00000000 13200000 d8000000 00000000 20200000 14010000 00000000 30200000 40010000 00000000 81f00000 48010000 00000000>;
      "bundle-identifier" = "com.apple.systempreferences";
      "dock-extra" = 1;
      "file-data" =                 {
          "_CFURLString" = "file:///Applications/System%20Preferences.app/";
          "_CFURLStringType" = 15;
      };
      "file-label" = "System Preferences";
      "file-mod-date" = 3637001383;
      "file-type" = 41;
      "parent-mod-date" = 17131992630321;
  };
  "tile-type" = "file-tile";
}'


# Add a spacer to the left side of the Dock (where the applications are)
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

###############################################################################
# 🎛 Mission Control
###############################################################################

defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Top left screen corner → Show application windows
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0

# Top right screen corner → Mission Control
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0

# Bottom left screen corner → Notification Center
defaults write com.apple.dock wvous-bl-corner -int 3
defaults write com.apple.dock wvous-bl-modifier -int 0

# Bottom right screen corner → Desktop
defaults write com.apple.dock wvous-br-corner -int 5
defaults write com.apple.dock wvous-br-modifier -int 0

killall Dock

###############################################################################
# ⌨️ Keyboard
###############################################################################

defaults write -g KeyRepeat -int 3
defaults write -g InitialKeyRepeat -int 15

# Disable press-and-hold for keys in favour of key repeat
defaults write -g ApplePressAndHoldEnabled -bool true

# Shortcut to maximize window
defaults write -g NSUserKeyEquivalents -dict-add "Zoom" -string "@~^f"

# Disable automatic modifications of entered text
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

###############################################################################
# 🖥️️ Screen
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
defaults write com.apple.screensaver tokenRemovalAction -int 0

###############################################################################
# 🖱️ Mouse
###############################################################################

# Increase speed
defaults write -g com.apple.mouse.scaling 5

# Disable secondary button on click
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode OneButton

# Disable swipe with one single finger gesture to go back while browsing
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseOneFingerDoubleTapGesture 0

###############################################################################
# 💻 Trackpad
###############################################################################

# Tracking Speed: from 0 to 3
defaults write -g com.apple.trackpad.scaling -float 3

# Enable tap to click for the current user and the login screen. (Don't have to press down on the trackpad -- just tap it.)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.mouse.tapBehavior -int 1

# Trackpad: map two fingers tap to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1

###############################################################################
# 📂 Finder
###############################################################################

defaults write com.apple.finder DisableAllAnimations -bool true
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string 'file://$HOME/'
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FinderSpawnTab -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder QLEnableTextSelection -bool TRUE

# Toolbar icons
defaults write com.apple.finder 'NSToolbar Configuration Browser' '{
    "TB Default Item Identifiers" =     (
        "com.apple.finder.BACK",
        NSToolbarFlexibleSpaceItem,
        "com.apple.finder.SWCH",
        "com.apple.finder.ARNG",
        "com.apple.finder.ACTN",
        "com.apple.finder.SHAR",
        "com.apple.finder.LABL",
        NSToolbarFlexibleSpaceItem,
        NSToolbarFlexibleSpaceItem,
        "com.apple.finder.SRCH"
    );
    "TB Display Mode" = 2;
    "TB Icon Size Mode" = 1;
    "TB Is Shown" = 1;
    "TB Item Identifiers" =     (
        "com.apple.finder.BACK",
        NSToolbarFlexibleSpaceItem,
        "com.apple.finder.SWCH",
        "com.apple.finder.ARNG",
        NSToolbarSpaceItem,
        "com.apple.finder.NFLD",
        NSToolbarFlexibleSpaceItem,
        "com.apple.finder.SRCH"
    );
    "TB Size Mode" = 1;
}'

# Modify behaviour for "Save" modal window
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Enable spring loading for directories: https://www.youtube.com/watch?v=F9kdAxGe9SE
defaults write -g com.apple.springing.enabled -bool true
defaults write -g com.apple.springing.delay -float 0

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
killall Finder

# Show Sidebar, but remove the Tags section.
defaults write com.apple.finder ShowSidebar -bool true
defaults write com.apple.finder ShowRecentTags -bool false

###############################################################################
# 🔍 Spotlight
###############################################################################

# Limit number of things to index
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
	'{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
	'{"enabled" = 1;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 0;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 0;"name" = "FONTS";}' \
	'{"enabled" = 0;"name" = "MENU_OTHER";}'

# Load new settings before rebuilding the index
sudo killall mds > /dev/null 2>&1

# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null

# Rebuild the index from scratch
sudo mdutil -E / > /dev/null

# Do not search inside external drives (WIP)

###############################################################################
# 🌍 Safari & WebKit
###############################################################################

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write -g WebKitDeveloperExtras -bool true

defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

###############################################################################
# 🍎 Mac App Store
###############################################################################

defaults write com.apple.appstore ShowDebugMenu -bool true
defaults write com.apple.commerce AutoUpdate -bool true
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
# 📊 Activity Monitor
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# 📝 TextEdit
###############################################################################

# Use plain text as default format in TextEdit
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# 🎚️ Others
###############################################################################

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

defaults write -g AppleShowScrollBars -string "Always"
defaults write -g NSWindowResizeTime -float 0.001

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Font rendering for non-retina displays. More info: https://github.com/Microsoft/vscode/issues/51132
defaults write -g CGFontRenderingFontSmoothingDisabled -bool false

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName $COMPUTER_NAME
sudo scutil --set HostName $COMPUTER_NAME
sudo scutil --set LocalHostName $COMPUTER_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME

# Disable new disks requests for Time Machine
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Auto-play videos when opened with QuickTime Player
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Disable Wake for Wi-Fi network / Wake on Demand (more info: https://apple.stackexchange.com/questions/73764/what-is-the-wake-for-wifi-network-access-setting-in-energy-preferences)

# Enable dark mode
osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'
