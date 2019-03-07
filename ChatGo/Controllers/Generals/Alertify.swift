//
//  Alertify.swift
//  ChatGo
//
//  Created by Rasyadh Abdul Aziz on 07/03/19.
//  Copyright © 2019 rasyadh. All rights reserved.
//

import UIKit

class Alertify: NSObject {
    static func displayAlert(title: String, message: String, sender: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
    
    static func displayConfirmationDialog(title: String, message: String, confirmTitle: String, sender: UIViewController, isDestructive: Bool = false, confirmCallback: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message
            , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if isDestructive {
            alert.addAction(UIAlertAction(title: confirmTitle, style: .destructive, handler: { action in
                if confirmCallback != nil {
                    confirmCallback!()
                }
            }))
        }
        else {
            alert.addAction(UIAlertAction(title: confirmTitle, style: .default, handler: { action in
                if confirmCallback != nil {
                    confirmCallback!()
                }
            }))
        }
        sender.present(alert, animated: true, completion: nil)
    }
}
