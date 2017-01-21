# WMSKit
WMSKit is a kit to add WMS support to Swift 3 / iOS 10. 

## Usage
Add this line to your Podfile (replace the tag with current tag)
```
pod 'WMSKit', :git => 'https://github.com/forsen/WMSKit.git', :tag => '0.0.3'
```

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
