
# react-native-error-manager

## Getting started

`$ npm install react-native-error-manager --save`

### Mostly automatic installation

`$ react-native link react-native-error-manager`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-error-manager` and add `RNErrorManager.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNErrorManager.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNErrorManagerPackage;` to the imports at the top of the file
  - Add `new RNErrorManagerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-error-manager'
  	project(':react-native-error-manager').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-error-manager/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-error-manager')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNErrorManager.sln` in `node_modules/react-native-error-manager/windows/RNErrorManager.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Error.Manager.RNErrorManager;` to the usings at the top of the file
  - Add `new RNErrorManagerPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNErrorManager from 'react-native-error-manager';

// TODO: What to do with the module?
RNErrorManager;
```
  