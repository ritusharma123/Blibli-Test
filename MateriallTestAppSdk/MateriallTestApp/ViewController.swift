//
//  ViewController.swift
//  MateriallTestApp
//
//  Created by Ritu on 11/09/21.
//

import UIKit

class ViewController: UIViewController {
    let clientId : String = "blibli-client2"
    @IBOutlet var txtResponse: UITextView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stopLoading()
        Materiall.framework.authenticate()
    }
    
   @IBAction @objc func apiAction(sender:UIButton!) {
        self.txtResponse.text = "Loading..."
        //self.view.bringSubviewToFront(self.spinner)
        self.startLoading()
        Materiall.framework.authorizationTokenGenerate(ClienID: clientId);
        Materiall.framework.setCount(value: 8)
        Materiall.framework.setSortBy(value: "Relevance")
        Materiall.framework.setCategoryID(value: "54817")
        Materiall.framework.setSearchQuery(value: "polycotton t shirt")
        Materiall.framework.setXRequestID(value: "123")
        Materiall.framework.setFilter(value: "color_matFilter:Red OR color_matFilter:Blue")
        Materiall.framework.getRecommendedProductCategory(clientID: clientId, userID: "xyz-xyz-xyz", sessionId: "ses-xuz-abc", page: 2, pagetype: "categoryPage", template: "blibli") { response in
            DispatchQueue.main.async { [weak self] in
                self?.stopLoading()
                self?.txtResponse.text = String(describing:response)
            }
        }
   }

    func startLoading(){
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.spinner?.bringSubviewToFront(self.view)
            self.spinner?.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func stopLoading(){
        DispatchQueue.main.async {
            self.view.endEditing(false)
            self.spinner?.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
}

