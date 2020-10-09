//
//  MapViewController.swift
//  swift5GunabiMapAPP
//
//  Created by 深谷祐斗 on 2020/08/20.
//  Copyright © 2020 yuto fukaya. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import Alamofire

class MapViewController:UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,DoneCatchDataProtocol{
 
        /*
         
         課題:このコードを全て読んで構造を理解した上で、JSON解析を下記URLから緯度、経度、店名、電話番号を取得してください。
         取得するとpinが打たれます。
         
         
         https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=8c43960c672d3bf67ddb816618427a7a&latitude=35.645736&longitude=139.74757499999998&range=3&hit_per_page=50&freeword=%E5%B1%85%E9%85%92%E5%B1%8B
         */

        //ぐるなびAPI
        //7d8a12fd7e2a722ce6adbfacdb223f21
        
        
        /*
         
         https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=8c43960c672d3bf67ddb816618427a7a&latitude=35.645736&longitude=139.74757499999998&range=3&hit_per_page=50&freeword=居酒屋
         
         */
        
        @IBOutlet weak var mapView: MKMapView!
        @IBOutlet weak var textField: UITextField!
        var shopDataArray = [ShopData]()
        
        
        var idoValue = Double()
        var keidoValue = Double()
        var totalHitCount = Int()
        let locationManager = CLLocationManager()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            startUpdatingLocation()
            configureSubviews()
            
            let annotation = MKPointAnnotation()
            // 緯度経度を指定
//            annotation.coordinate = CLLocationCoordinate2DMake(,)
            
            // タイトル、サブタイトルを設定
            annotation.title = "000000"
            annotation.subtitle = "0000"
            
            // mapViewに追加
            mapView.addAnnotation(annotation)
            
        }
        
        func addAnnotation(shopData:[ShopData]) {
            
            print(totalHitCount)
            for i in 0...totalHitCount - 1{
                print(i)
                print(shopData[i].latitude!)
                
                if shopData[i].latitude!.isEmpty != true{
                // ピンの生成
                let annotation = MKPointAnnotation()
                // 緯度経度を指定
                annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(shopData[i].latitude!)!, CLLocationDegrees(shopData[i].longitude!)!)
                
                // タイトル、サブタイトルを設定
                annotation.title = shopData[i].name
                annotation.subtitle = shopData[i].tel
                
                // mapViewに追加
                mapView.addAnnotation(annotation)
                }
            }
            
            textField.resignFirstResponder()

        }
     
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
            //タップした情報をもとに詳細ページへ
        
            let annotation = view.annotation
            let title = annotation?.title
            let subtitle = annotation?.subtitle
            
            print(title)
            print(subtitle)
            
            
            //画面遷移
        }
        
        func startUpdatingLocation() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                break
            }
            locationManager.startUpdatingLocation()
        }
        
        func configureSubviews() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
            
            mapView.delegate = self
            mapView.mapType = .standard
            mapView.userTrackingMode = .follow
            mapView.userTrackingMode = .followWithHeading
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
              let location = locations.first
              let latitude = location?.coordinate.latitude
              let longitude = location?.coordinate.longitude
                
            idoValue = latitude!
            keidoValue = longitude!
              print("latitude: \(latitude!)\nlongitude: \(longitude!)")
          }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            let alert = UIAlertController(title: nil, message: "位置情報の取得に失敗しました", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }

        func catchData(arrayData: Array<ShopData>,resultCount:Int) {
            shopDataArray = arrayData
            totalHitCount = resultCount
            addAnnotation(shopData: shopDataArray)
        }

        
        @IBAction func search(_ sender: Any) {
      
            let urlString = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=8c43960c672d3bf67ddb816618427a7a&latitude=\(idoValue)&longitude=\(keidoValue)&range=3&hit_per_page=100&freeword=\(textField.text!)"
            let analyticsModel = AnalyticsModel(latitude: idoValue, longitude: keidoValue,url: urlString)
            analyticsModel.doneCatchDataProtocol = self
            analyticsModel.setData()
            
            
            
    //        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ responce in
    //
    //            switch responce.result{
    //
    //            case .success:
    //
    //            let json:JSON = JSON(responce.data as Any)
    //            print(json)
    //            idoValue = json["rest"][0]["latitude"].double
    //            keidoValue = json["rest"][0]["longitude"].double
    //            let shopName = json["rest"][0]["name"].string
    //            let tel:String = json["rest"][0]["tel"].string
                
                
                
                
    //
    //
    //            ShopData.init(latitude: idoValue, longitude: keidoValue, url: urlString, name: <#T##String?#>, tel: <#T##String?#>)
                
        }
        
    }


