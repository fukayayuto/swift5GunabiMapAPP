//
//  AnalyticsModel.swift
//  swift5GunabiMapAPP
//
//  Created by 深谷祐斗 on 2020/08/20.
//  Copyright © 2020 yuto fukaya. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol DoneCatchDataProtocol {

    //規則を決める
    func catchData(arrayData:Array<ShopData>,resultCount:Int)

}

class AnalyticsModel {
    
    
    //外部から渡ってくる緯度
    var idoValue:Double?
    //外部から渡ってくる経度
    var keidoValue:Double?
    var urlString:String?
        
    var shopDataArray = [ShopData]()
    var doneCatchDataProtocol:DoneCatchDataProtocol?
    
    init(latitude:Double,longitude:Double,url:String){
        
        idoValue = latitude
        keidoValue = longitude
        urlString = url
    }
    
    func setData(){
            
//        https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=8c43960c672d3bf67ddb816618427a7a&latitude=35.645736&longitude=139.74757499999998&range=3&hit_per_page=50&freeword=%E5%B1%85%E9%85%92%E5%B1%8B
  
        //インディケーター回す
        
        let encordeUrlString:String = urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(encordeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            (response) in
            
            print(response)
            switch response.result{
            
            case .success:
                do {
                    let json:JSON =  try JSON(data: response.data!)
                    
                    print(json.debugDescription)
                    
//                    let totalHitCount = json["total_hit_count"].int
                    for i in 0...20 - 1{

                        
                        let shopData = ShopData(latitude: json["rest"][i]["latitude"].string, longitude: json["rest"][i]["latitude"].string, url: json["rest"][i]["url"].string, name: json["rest"][i]["name"].string, tel: json["rest"][i]["tel"].string)
//                        
                        self.shopDataArray.append(shopData)
                        print(self.shopDataArray)
                    }

                    //インディケーター閉じる
                    self.doneCatchDataProtocol?.catchData(arrayData: self.shopDataArray,resultCount:19)
                    
                }catch{
                    // error handling
                }
                
                break
                
            case .failure(_): break
                
            }
        }
        
    }

}

