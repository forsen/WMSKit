# WMSKit
WMSKit is a Framework for iOS written in Swift. It provides WMS (Web Map Service) capability by subclassing MapKit's `MKTileOverlay`

## Usage
Easiest method is to use CocoaPods. Just add this line to your Podfile (replace the tag with current tag)
```
pod 'WMSKit'
```
And then run this command in a terminal
```
$ pod install
```

Alternatively you can clone this repository and build the framework with XCode, and then add it to your project manually.

When installed you can use it as follows:
```Swift
import WMSKit
...
var overlay = WMSTileOverlay(urlArg: <WMS URL>, useMercator: <BOOL>, wmsVersion: <WMSVERSION>)
mapView.add(overlay)
...
```

## Example project
See [WMSKitDemo](https://github.com/forsen/WMSKitDemo) for an example on how to use this kit. 

## License
This project is licensed under the MIT License – see the [LICENSE](../master/LICENSE) file for details

## Acknowledgments
* The project is based on [revilosun](https://github.com/revilosun)'s project [WmsMapKit_Swift](https://github.com/revilosun/WmsMapKit_Swift).
