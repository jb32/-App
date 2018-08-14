//
//  ProjectDetaiController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/7.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class ProjectDetaiController: ZYYBaseViewController {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    var model: ProjectModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = model?.title
        authorLabel.text = model?.author
        timeLabel.text = model?.add_time
        self.showBlurHUD()
        webView.loadHTMLString((model?.content)!, baseURL: nil)
        webView.scalesPageToFit = true
//        do {
//            let html = (model?.content)!
//            //      print(html)
//
//            // 获取所有img src中的src链接，并将src更改名称
//            // 这里直接采用同步获取数据，异步也是一样的道理，为了方便写demo，仅以同步加载图片为例。
//            // 另外，这不考虑清除缓存的问题。
//            do {
//                let regex = try NSRegularExpression(pattern: "<img\\ssrc[^>]*/>", options: .allowCommentsAndWhitespace)
//
//                let result = regex.matches(in: html, options: .reportCompletion, range: NSMakeRange(0, html.characters.count))
//
//                var content = html as NSString
//                var sourceSrcs: [String: String] = ["": ""]
//
//                for item in result {
//                    let range = item.range(at: 0)
//
//                    let imgHtml = content.substring(with: range) as NSString
//                    var array = [""]
//
//                    if imgHtml.range(of: "src=\"").location != NSNotFound {
//                        array = imgHtml.components(separatedBy: "src=\"")
//                    } else if imgHtml.range(of: "src=").location != NSNotFound {
//                        array = imgHtml.components(separatedBy: "src=")
//                    }
//
//                    if array.count >= 2 {
//                        var src = array[1] as NSString
//                        if src.range(of: "\"").location != NSNotFound {
//                            src = src.substring(to: src.range(of: "\"").location) as NSString
//
//                            // 图片链接正确解析出来
//                            print(src)
//
//                            let localUrl = Image_Path + (src as String)
//
//                            // 记录下原URL和本地URL
//                            // 如果用异步加载图片的方式，先可以提交将每个URL起好名字，由于这里使用的是原URL的md5作为名称，
//                            // 因此每个URL的名字是固定的。
//                            sourceSrcs[src as String] = localUrl
//                        }
//                    }
//                }
//
//                for (src, localUrl) in sourceSrcs {
//                    if !localUrl.isEmpty {
//                        content = content.replacingOccurrences(of: src as String, with: localUrl, options: NSString.CompareOptions.literal, range: NSMakeRange(0, content.length)) as NSString
//                    }
//                }
//
//                print(content as String)
//                webView.loadHTMLString(content as String, baseURL: nil)
//                webView.scalesPageToFit = true
//            } catch {
//                print("match error")
//            }
//        } catch {
//            print("load html error")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProjectDetaiController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideBlurHUD()
    }
}
