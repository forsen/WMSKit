//
//  WMSTileOverlay.swift
//  WMSKit
//
//  Created by Erik Haider Forsen on 20/01/2017.
//  Copyright © 2017 Erik Haider Forsen. All rights reserved.
//

import Foundation
import MapKit


extension String {

    func stringByAppendingPathComponent(path: String) -> String {

        let nsSt = self as NSString

        return nsSt.appendingPathComponent(path)
    }
}


public class WMSTileOverlay : MKTileOverlay {

    let TILE_CACHE = "TILE_CACHE"

    var url: String
    var useMercator: Bool
    let wmsVersion: String
    var alpha: CGFloat = 1.0

    public init(urlArg: String, useMercator: Bool, wmsVersion: String) {
        self.url = urlArg
        self.useMercator = useMercator
        self.wmsVersion = wmsVersion
        super.init(urlTemplate: url)
    }

    func xOfColumn(column: Int, zoom: Int) -> Double {
        let x = Double(column)
        let z = Double(zoom)
        return x / pow(2.0, z) * 360.0 - 180
    }

    func yOfRow(row: Int, zoom: Int) -> Double {
        let y = Double(row)
        let z = Double(zoom)
        let n = M_PI - 2.0 * M_PI * y / pow(2.0, z)
        return 180.0 / M_PI * atan(0.5 * (exp(n) - exp(-n)))
    }


    func mercatorXofLongitude(lon: Double) -> Double {
        return lon * 20037508.34 / 180
    }

    func mercatorYofLatitude(lat: Double) -> Double {
        var y = log(tan((90 + lat) * M_PI / 360)) / (M_PI / 180)
        y = y * 20037508.34 / 180
        return y
    }

    public override func url(forTilePath path: MKTileOverlayPath) -> URL {
        var left = xOfColumn(column: path.x, zoom: path.z)
        var right = xOfColumn(column: path.x+1, zoom: path.z)
        var bottom = yOfRow(row: path.y+1, zoom: path.z)
        var top = yOfRow(row: path.y, zoom: path.z)
        if(useMercator){
            left   = mercatorXofLongitude(lon: left) // minX
            right  = mercatorXofLongitude(lon: right) // maxX
            bottom = mercatorYofLatitude(lat: bottom) // minY
            top    = mercatorYofLatitude(lat: top) // maxY
        }

        var resolvedUrl = "\(self.url)"
        if(wmsVersion.contains("1.3")) {
            resolvedUrl += "&BBOX=\(bottom),\(left),\(top),\(right)"
        } else {
            resolvedUrl += "&BBOX=\(left),\(bottom),\(right),\(top)"
        }

        return URL(string: resolvedUrl)!
    }

    func tileZ(zoomScale: MKZoomScale) -> Int {
        let numTilesAt1_0 = MKMapSizeWorld.width / 256.0
        let zoomLevelAt1_0 = log2(Float(numTilesAt1_0))
        let zoomLevel = max(0, zoomLevelAt1_0 + floor(log2f(Float(zoomScale)) + 0.5))
        return Int(zoomLevel)
    }

    func createPathIfNecessary(path: String) -> Void {
        let fm = FileManager.default
        if(!fm.fileExists(atPath: path)) {
            do {
                try fm.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print(error)
            }
        }
    }

    func cachePathWithName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let cachesPath: String = paths as String
        let cachePath = cachesPath.stringByAppendingPathComponent(path: name)
        createPathIfNecessary(path: cachesPath)
        createPathIfNecessary(path: cachePath)

        return cachePath
    }

    func getFilePathForURL(url: URL, folderName: String) -> String {
        return cachePathWithName(name: folderName).stringByAppendingPathComponent(path: "\(url.hashValue)")
    }

    func cacheUrlToLocalFolder(url: URL, data: NSData, folderName: String) {
        let localFilePath = getFilePathForURL(url: url, folderName: folderName)
        do {
            try data.write(toFile: localFilePath)
        } catch let error {
            print(error)
        }
    }

    public override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        let url1 = self.url(forTilePath: path)
        let filePath = getFilePathForURL(url: url1, folderName: TILE_CACHE)

        let file = FileManager.default

        if file.fileExists(atPath: filePath) {
            let tileData =  try? NSData(contentsOfFile: filePath, options: .dataReadingMapped)
            result(tileData as Data?, nil)
        } else {
            let request = NSMutableURLRequest(url: url1)
            request.httpMethod = "GET"

            let session = URLSession.shared
            session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in

                if error != nil {
                    print("Error downloading tile")
                    result(nil, error)
                }
                else {
                    do {
                        try data?.write(to: URL(fileURLWithPath: filePath))
                    } catch let error {
                        print(error)
                    }
                    result(data, nil)
                }
            }).resume()
        }
    }
}
