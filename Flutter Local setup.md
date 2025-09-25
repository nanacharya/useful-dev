flutter setup
- install andriod studio xocode
- Install brew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
- Add homebrew to shell
   Or add the command after above command provided for next step

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"

 - Install flutter
  brew install flutter
 flutter doctor --android-licenses and accept it

sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
brew install cocoapods
pod setup

Andirod stuido issue 
   ✅ 1. Fix: Android Toolchain (cmdline-tools missing)

You’re missing the Android SDK command-line tools.

👉 Option A: Install via Android Studio

Open Android Studio

Go to Preferences > Appearance & Behavior > System Settings > Android SDK

Click on the SDK Tools tab

Check ✅ Android SDK Command-line Tools (latest)

Click Apply → OK 


- Test flutter 
  flutter doctor
  Make sure all are green
  
  fix if you see any issue
  
  





- clone https://github.com/aratheunseen/flutter-task-manager
- Import Gradle setting 

<img width="1306" height="770" alt="image" src="https://github.com/user-attachments/assets/d9f09e45-a68e-471a-877c-c794cbfa680b" />
- flutter pub get 
if you see version issue then update pubspec.yaml

environment:
  sdk: ">=2.17.0 <4.0.0"

  flutter pub upgrade --major-versions


