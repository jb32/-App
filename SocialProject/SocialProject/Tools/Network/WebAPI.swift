//
//  ZYYWebAPI.swift
//  TyreProject
//
//  Created by ZYY on 2017/7/12.
//  Copyright © 2017年 ZYY. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

extension UIImageView {
    
    func setWebImage(with urlString: String?, placeholder: UIImage? = nil) {
        if let urlString = urlString, let url = URL(string: urlString) {
            self.af_cancelImageRequest()
            self.af_setImage(withURL: url, placeholderImage: placeholder)
            return
        }
        self.image = placeholder
    }
}

struct WebAPI {
    //MARK: - Constants
    private static let STATUS_CODE: String = "status"
    private static let ERROR_MSG: String = "msg"
    private static let DATA: String = "data"
    private static let ACCESS_TOKEN: String = "access_token"
    private static let UPLOAD_IMAGE: String = "social_img"
    private static let UPLOAD_IMAGE_URL: String = "img_path"
    
    //是否允许答应调试信息
    static var isPrintEnable: Bool = true
    
    private enum WebStatusCode: Int {
        case fine = 200 //正常
        case invalideToken = 1020001
        case invalide = 1020006
        case networkNotReachable = -1
    }
    
    //MARK: - Type Alias
    typealias CompleteHandler = (_ isSuccess: Bool, _ response: Any?, _ error: NetworkError?) -> Void
    typealias ProgressHandler = (_ progress: Progress) -> Void
    
    //MARK: - Private Functions
    private static func print(url: String, parameters: Parameters, responseJSON: JSON, timeline: Timeline) {
        #if DEBUG
            if WebAPI.isPrintEnable {
                Swift.print("--------------------")
                Swift.print("### Request URL ###")
                Swift.print(url)
                Swift.print("### Request Parameters ###")
                Swift.print(parameters)
                Swift.print("### Response JSON ###")
                Swift.print(responseJSON)
                Swift.print("### Total Duration ###")
                Swift.print(timeline)
                Swift.print("--------------------")
            }
        #endif
    }
    
    //MARK: - Public Functions
    static func send<R: RequestType>(_ request: R, completeHandler: ((_ isSuccess: Bool, _ response: R.ResponsType?, _ error: NetworkError?) -> Void)? = nil) {
        
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, appDelegate.reachabilityManager.isReachable == true else {
                completeHandler?(false, nil, NetworkError(errorCode: WebStatusCode.networkNotReachable.rawValue, errorMsg: "当前无网络连接"))
                return
            }
        }
        
        var request = request
        Alamofire.request(request).responseData { (responseData) in
            if let data = responseData.data {
                let json = try? JSON(data: data)
                
                WebAPI.print(url: request.host + request.path,
                             parameters: request.parameters,
                             responseJSON: json ?? JSON(),
                             timeline: responseData.timeline)
                
                if let json = json, let codeStr = json[STATUS_CODE].string, let statusCode = Int(codeStr), let status = WebStatusCode(rawValue: statusCode) {
                    let dataJSON = json[DATA]
                    
                    switch status {
                    case .fine:
                        completeHandler?(true, R.ResponsType.parse(dataJSON), nil)
                        //                    case WebStatusCode.invalideToken.rawValue, WebStatusCode.invalide.rawValue:
                        //                        if IS_LOGIN {
                        //                            //token失效后会返回最新token，存储token后重新调用接口
                        //                            let new_token = dataJSON[ACCESS_TOKEN].stringValue
                        //                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOGINNotification"), object: nil)
                        //                            //修改请求参数token为最新
                        //                            request.parameters["token"] = new_token
                        //                            WebAPI.send(request) { (secIsSuccess, secResponse, secError) in
                        //                                if secIsSuccess {
                        //                                    completeHandler?(true, secResponse, nil)
                        //                                } else {
                        //                                    completeHandler?(false, nil, secError)
                        //                                }
                        //                            }
                        //                        } else {
                        //                            if ((statusCode >= 1020001) && (statusCode <= 1020008)) || (statusCode == 2110015) {
                        //                                completeHandler?(false, nil, NetworkError(errorCode: statusCode, errorMsg: "Token失效"))
                        //                            }
                    //                        }
                    default:
                        completeHandler?(false, nil, NetworkError(errorCode: statusCode,
                                                                  errorMsg: json[ERROR_MSG].stringValue))
                    }
                    return
                }
                completeHandler?(false, nil, NetworkError())
            }
        }
    }
    
    static func upload(_ uploadRequest: UploadPhotoRequest, progressHandler: ProgressHandler? = nil, completeHandler: CompleteHandler? = nil) {
        guard uploadRequest.datas.count > 0 else {
            return
        }
        let urlString: String = uploadRequest.host + uploadRequest.path
        Swift.print("--------------------")
        Swift.print("### Upload URL ###")
        Swift.print(urlString)
        Swift.print("### Upload Files Count ###")
        Swift.print(uploadRequest.datas.count)
        Swift.print("### Upload Progress ###")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            uploadRequest.datas.forEach { (eachData) in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMddHHmmss"
                let fileName = formatter.string(from: Date()) + ".jpg"
                multipartFormData.append(eachData, withName: UPLOAD_IMAGE, fileName: fileName, mimeType: "image/jpeg")
            }

            if let data = try? JSONSerialization.data(withJSONObject: uploadRequest.parameters, options: []) {
                let jsonParamStr = String(data: data, encoding: .utf8)!
                let enJsonParamStr = NSString.urlEncodedString(jsonParamStr)
                let encodedParam = ["id": userID, "file": enJsonParamStr]

                for (key, value) in encodedParam {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }
        }, with: uploadRequest, encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(let uploadRequest, _, _):
                uploadRequest.uploadProgress { (progress: Progress) in
                    Swift.print("progress: \(progress.fractionCompleted)")
                    progressHandler?(progress)
                    }.responseData { (responseData) in
                        if let data = responseData.data {
                            var json: JSON = JSON()
                            do {
                                json = try JSON(data: data)
                            } catch {}
                            Swift.print("### Upload Finished ###")
                            Swift.print(json)
                            Swift.print("--------------------")
                            if let result = json["msg"].string, result == "上传成功" {
                                completeHandler?(true, json[DATA][UPLOAD_IMAGE_URL].string, nil)
                            } else {
                                let errorCode = json["status"].intValue
                                let errorMsg = json["msg"].stringValue
                                completeHandler?(false, nil, NetworkError(errorCode: errorCode, errorMsg: errorMsg))
                            }
                            return
                        }
                        Swift.print("### Upload Failed ###")
                        Swift.print("--------------------")
                        completeHandler?(false, nil, NetworkError())
                }
            case .failure(let error):
                completeHandler?(false, nil, NetworkError(errorMsg: error.localizedDescription))
            }
        })
    }
    
    static func download(with urlString: String, progressHandler: ProgressHandler? = nil, completeHandler: CompleteHandler? = nil) {
        let destination: DownloadRequest.DownloadFileDestination = { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentURL.appendingPathComponent(response.suggestedFilename!)
            let options: DownloadRequest.DownloadOptions = [.removePreviousFile, .createIntermediateDirectories]
            return (fileURL, options)
        }
        Alamofire.download(urlString, to: destination).downloadProgress { (progress) in
            progressHandler?(progress)
            }.responseData { (responseData) in
                switch responseData.result {
                case .success(let data):
                    completeHandler?(true, data, nil)
                case .failure(let error):
                    completeHandler?(false, responseData.resumeData, NetworkError(errorMsg: error.localizedDescription))
                }
        }
    }
}
