//
//  ZYYWebRequest.swift
//  TyreProject
//
//  Created by ZYY on 2017/7/12.
//  Copyright © 2017年 ZYY. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//MARK: - RequestError
struct NetworkError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    let errorCode: Int
    let errorMsg: String
    
    init() {
        self.errorCode = 0
        self.errorMsg = "网络错误"
    }
    
    init(errorMsg: String) {
        self.errorCode = 0
        self.errorMsg = errorMsg
    }
    
    init(errorCode: Int, errorMsg: String) {
        self.errorCode = errorCode
        self.errorMsg = errorMsg
    }
    
    var debugDescription: String {
        Swift.print("--------------------")
        Swift.print("### 错误代码: \(self.errorCode) ###")
        Swift.print("### 错误信息: \(self.errorMsg) ###")
        Swift.print("--------------------")
        return self.errorMsg
    }
}

//MARK: - RequestType
protocol RequestType: URLRequestConvertible {
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get set }
    var paramEncoding: URLEncoding { get }
    
    associatedtype ResponsType: JSONParsable
}

extension RequestType {
    var host: String {
        return ROOT_API_HOST
    }
    var method: HTTPMethod {
        return .post
    }
    var paramEncoding: URLEncoding {
        return .default
    }
    
    func asURLRequest() throws -> URLRequest {
        if let url = URL(string: host + path) {
            let request = try URLRequest(url: url, method: self.method)
            //            let jsonParamData = try JSONSerialization.data(withJSONObject: self.parameters, options: [])
            //            let jsonParamString = String(data: jsonParamData, encoding: .utf8)!
            //            let encodedParam = ["data":jsonParamString.desEncoded]
            let encodedURLRequest = try self.paramEncoding.encode(request, with: self.parameters)
            return encodedURLRequest
        }
        throw AFError.invalidURL(url: host + path)
    }
}

// MARK: - 获取验证码与校验模块
// 发送短信验证码
struct SendMsgRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/sendAuthenticationCode"
    var parameters: Parameters
    typealias ResponsType = JSON
    
    init(mobile: String) {
        self.parameters = ["mobile": mobile]
    }
}

// 检查短信验证码
struct CheckMsgCodeRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/codeVerification"
    var parameters: Parameters
    typealias ResponsType = JSON
    init(mobile: String, code: String) {
        self.parameters = ["mobile": mobile, "code": code]
    }
}

// MARK: 登录注册
// 登录
struct LoginRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/appUserSignIn"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(mobile: String, password: String) {
        self.parameters = ["mobile": mobile, "password": password.md5Hashed]
    }
}

// 注册
struct RegisterRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/userRegistration"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(name: String, mobile: String, loginPassword: String, refereeId: String, code: String) {
        self.parameters = ["name": name, "mobile": mobile, "loginPassword": loginPassword.md5Hashed, "refereeId": refereeId, "code": code]
    }
//    init(name: String, mobile: String, sex: String, address: String, loginPassword: String, industry: String, autograph: String, dateOfBirth: String, refereeId: String) {
//        self.parameters = ["name": name, "mobile": mobile, "sex": sex, "address": address, "loginPassword": loginPassword.md5Hashed, "industry": industry, "autograph": autograph, "dateOfBirth": dateOfBirth, "refereeId": refereeId]
//    }
}

// 修改密码
struct ChangePasswordRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/userUpdatePassword"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(code: String, mobile: String, password: String) {
        self.parameters = ["code": code, "mobile": mobile, "loginPassword": password.md5Hashed]
    }
}

// 圈子类别
struct CircleTypeRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/getCircleType"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<CircleModel>
    
    init() {
        self.parameters = ["id": ""]
    }
}

// 选择圈子
struct ChooseCircleRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/circleType"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(circleType: Int, ID: String) {
        self.parameters = ["id": ID, "circleType": circleType]
    }
}

// 修改用户坐标
struct LocationRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/appUserCoordinate"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(ID: String, longitude: Double, latitude: Double) {
        self.parameters = ["id": ID, "longitude": longitude, "latitude": latitude]
    }
}

// MARK: 人脉
// 根据圈子对人脉进行分类
struct CircleRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/getAccountById"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<UserModel>
    
    init(ID: String, type: String) {
        self.parameters = ["id": ID, "circleType": type]
    }
}

// MARK: 发现
// 直销品牌
struct BrandRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/directSellingBrand"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<ProjectModel>
    
    init() {
        self.parameters = ["act": ""]
    }
}

// 发现父类
struct ParentRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/newProjectType"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<ParentModel>
    
    init() {
        self.parameters = ["id": ""]
    }
}

// 项目列表
struct ProjectRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/newProjectDetails"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<ProjectModel>
    
    init(ID: String) {
        self.parameters = ["id": ID]
    }
}

// MARK: 动态
// 好友动态
struct DynamicRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/getBuddyDynamics"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<DynamicModel>
    
    init(userId: String) {
        self.parameters = ["userId": userId]
    }
}

// 点赞
struct PraiseRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/addPraseNumber"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(ID: String, userLoginId: String) {
        self.parameters = ["id": ID, "userLoginId": userLoginId]
    }
}

// 转发
struct TransmitRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/addForwardPraseNumber"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(ID: String, loginId: String) {
        self.parameters = ["id": ID, "loginId": loginId]
    }
}

// 收藏
struct CollectRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/myDynamics/app/addCollectionDynamics"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(ID: String, dynamicsId: String) {
        self.parameters = ["id": ID, "dynamicsId": dynamicsId]
    }
}

// 热门
struct HotRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/getHot"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<DynamicModel>
    
    init() {
        self.parameters = ["id": ""]
    }
}

// 推荐
struct RecommendRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/getRecommend"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<DynamicModel>
    
    init() {
        self.parameters = ["id": ""]
    }
}

// 项目
struct ProjectListRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/getProject"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<DynamicModel>
    
    init(type: String) {
        self.parameters = ["type": type]
    }
}

// 咨询
struct InformationListRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/getInformation"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<DynamicModel>
    
    init() {
        self.parameters = ["id": ""]
    }
}

// 添加评论
struct CommentRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/addComment"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(comment: String, loginId: String, movementId: String) {
        self.parameters = ["comment": comment, "loginId": loginId, "movementId": movementId]
    }
}

// 评论列表
struct CommentListRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/ShowAllComments"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<CommentModel>
    
    init(movementId: String) {
        self.parameters = ["movementId": movementId]
    }
}

// 发表动态
struct PublishRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/addDynamic"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(userid: String, type: String, comment: String, file: [Data]) {
        self.parameters = ["id": userid, "type": type, "comment": comment, "file": file]
    }
}

// MARK: 我的
// 用户信息
struct UserInfoRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/getUserInfo"
    var parameters: Parameters
    
    typealias ResponsType = UserModel
    
    init(ID: String) {
        self.parameters = ["id": ID]
    }
}

// 修改用户信息
struct UpdateUserInfoRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/userInfoUpdata"
    var parameters: Parameters
    
    typealias ResponsType = UserModel
    
    init(ID: String, name: String, sex: String, address: String, industry: String, autograph: String, dateOfBirth: String) {
        self.parameters = ["id": ID, "name": name, "sex": sex, "address": address, "industry": industry, "autograph": autograph, "dateOfBirth": dateOfBirth]
    }
}

// 我的直推
struct DirectPushRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/getMyStraightPush"
    var parameters: Parameters
    
    typealias ResponsType = DirectPushModel
    
    init(ID: String) {
        self.parameters = ["id": ID]
    }
}

// 会员特权
struct MemberRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/memberRoot"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<MemberModel>
    
    init() {
        self.parameters = ["id": ""]
    }
}

// 相册上传
struct UploadPhotoRequest: RequestType {
    let host: String = ROOT_API_HOST
    var path: String = "/app/albumUploadFile"
    var parameters: Parameters
    let datas: [Data]
    
    typealias ResponsType = JSON
    
    init(ID: String, file: [Data], url: String) {
        self.datas = file
        self.parameters = ["id": ID]
        if url.length != 0 {
            path = url
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        if let url = URL(string: host + path) {
            let request = try URLRequest(url: url, method: self.method)
            return request
        }
        throw AFError.invalidURL(url: host + path)
    }
}

// 我的动态
struct MyDynamicRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/myDynamics/app/myDynamics"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<DynamicModel>
    
    init(ID: String) {
        self.parameters = ["id": ID]
    }
}

// 删除相册
struct DeletePhotoRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/app/albumUploadDelete"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(ID: String, imgUrl: String) {
        self.parameters = ["id": ID, "imgStr": imgUrl]
    }
}

// 我收藏的动态
struct CollectionListRequest: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/myDynamics/app/myCollectionDynamics"
    var parameters: Parameters
    
    typealias ResponsType = ObjectModelArray<DynamicModel>
    
    init(ID: String) {
        self.parameters = ["id": ID]
    }
}

/// 好友等关系列表
struct ContactRequest: RequestType {
    
    let host: String = ROOT_API_HOST
    let path: String = "/userRelation/app/selectUserRelation"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(id: Int, type: Int) {
        parameters = ["id": id, "type": type, "pageNum": 1, "numPerPage": 500]
    }
}
///搜索好友
struct SearchUserInfoReq: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/userRelation/app/searchForFriends"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(id: Int? = nil, mobile: String? = nil, name: String? = nil) {
        if let mobile = mobile {
            parameters = ["mobile": mobile]
        } else if let id = id {
            parameters = ["id": id]
        } else if let name = name {
            parameters = ["name": name]
        } else {
            parameters = [:]
        }
    }
}
/// 2018-08-10 19:08:47 添加关注
struct AttentionReq: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/userRelation/app/userAddUserRelation"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(id: String, otherId: String) {
        parameters = ["id": id, "othersId": otherId]
    }
}
/// 2018-08-10 19:08:47 取消关注
struct CancelAttentionReq: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/userRelation/app/userDeleteUserRelation"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(id: String, otherId: String) {
        parameters = ["id": id, "othersId": otherId]
    }
}
///添加黑名单
struct AddBlackReq: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/userRelation/app/userAddBlacklist"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(user id: String, otherId: String) {
        parameters = ["id": id, "pullBlackId": otherId]
    }
}
///删除黑名单
struct DeleteBlackReq: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/userRelation/app/userDeleteBlacklist"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(user id: String, otherId: String) {
        parameters = ["id": id, "pullBlackId": otherId]
    }
}
///黑名单
struct BlackListReq: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/userRelation/app/userBlacklistList"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(user id: String) {
        parameters = ["id": id]
    }
}
///搜索这个用户跟自己的主关系
struct RelationReq: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/userRelation/app/searchUserRelation"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(user id: String, otherId: String) {
        parameters = ["id": id, "othersId": otherId]
    }
}

struct AppClassReq: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/applicationStore/app/selectType"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init() {
        parameters = [:]
    }
}

struct AppAdReq: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/applicationStore/app/selectAdvertisement"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init() {
        parameters = [:]
    }
}

struct AppListReq: RequestType {
    let host: String = ROOT_API_HOST
    let path: String = "/applicationStore/app/searchApplicationStore"
    var parameters: Parameters
    
    typealias ResponsType = JSON
    
    init(classId: String?, search: String?) {
        if let search = search {
            parameters = ["search": search]
        }
        
        if let classId = classId {
            parameters = ["classId": classId]
        }
        parameters = [:]
    }
}
















