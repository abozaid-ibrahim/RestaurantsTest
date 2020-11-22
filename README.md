# TakeawayTest

## Building And Running The Project (Requirements)
* Swift 5.0+
* Xcode 11.5+
* iOS 13.0+

# Getting Started
- If this is your first time encountering swift/ios development, please follow [the instructions](https://developer.apple.com/support/xcode/) to setup Xcode and Swift on your Mac.
- To setup cocoapods for dependency management, make use of [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started)

## Setup Configs
- Checkout master branch to run latest version
- Open the terminal and navigate to the project root directory.
- Make sure you have cocoapods setup, then run: pod install
- Open the project by double clicking the `TakeawayTest.xcworkspace` file
- Select the build scheme which can be found right after the stop button on the top left of the IDE
- [Command(cmd)] + R - Run app
```
// App Settings
APP_NAME = TakeawayTest
PRODUCT_BUNDLE_IDENTIFIER = abozaid.TakeawayTest

#targets:
* TakeawayTest
* TakeawayTestTests
* TakeawayTestUITests

```

# Build and or run application by doing:
* Select the build scheme which can be found right after the stop button on the top left of the IDE
* [Command(cmd)] + B - Build app
* [Command(cmd)] + R - Run app

## Architecture
This application uses the Model-View-ViewModel (refered to as MVVM) UI architecture,


## Structure

### SupportingFiles
- Group app shared fils, like app delegate, assets, info.plist, ...etc

### Modules
- Include seperate modules, components, extensions, ...etc.

### Scenes
- Group of app scenes.

#### Screen shots:

![Restaurants (dark) ](https://github.com/abuzeid-ibrahim/TakeawayTest/Screenshots/main_dark.png?raw=true)
![Restaurants (light) ](https://github.com/abuzeid-ibrahim/TakeawayTest/Screenshots/main.png?raw=true)

![Sorting (dark) ](https://github.com/abuzeid-ibrahim/TakeawayTest/Screenshots/filter_dark.png?raw=true)
![sorting (light) ](https://github.com/abuzeid-ibrahim/TakeawayTest/Screenshots/filter.png?raw=true)
