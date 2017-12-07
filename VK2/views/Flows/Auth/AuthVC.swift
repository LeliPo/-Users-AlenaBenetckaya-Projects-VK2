//
//  AuthVC.swift
//  GBVK
//
//  Created by Алёна Бенецкая on 03.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import UIKit
import WebKit

class AuthVC: UIViewController {
    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    var environment: Environment {
        return EnvironmentImp.Debug()
    }
    
    lazy var router: AuthRouter = AuthRouter(environment: environment)
    
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showLogin()
    }
    
    func showLogin() {
        do {
            let request = try router.login().asURLRequest()
            webView.load(request)
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toApp", let tabsVC = segue.destination as? TabsVCImp {
            tabsVC.token = token
        }
    }

}

extension AuthVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {
                
                decisionHandler(.allow)
                return
        }
        
        let params = parse(paramters: fragment)
        
        guard let token = params["access_token"] else {
            print("токен не обнаружен")
            return
        }
        
        self.token = token
        
        decisionHandler(.cancel)
        performSegue(withIdentifier: "toApp", sender: nil)
    }
    
    func parse(paramters: String) -> [String: String] {
        
        let params = paramters
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        return params
    }
}

