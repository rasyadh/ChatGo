//
//  UIViewControllerExtension.swift
//  ChatGo
//
//  Created by Rasyadh Abdul Aziz on 07/03/19.
//  Copyright © 2019 rasyadh. All rights reserved.
//

import UIKit

enum CustomBarButtonStyle {
    case menuEllipsis,
    search,
    filter,
    cart,
    close,
    add,
    edit,
    
    cancel,
    save,
    notification,
    trash
}

enum ToolbarPickerType {
    case country,
    gender,
    birthDate
}

extension UIViewController {
    func configureTransparentNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func showNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func hideNavigationBarShadow() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func showNavigationBarShadow() {
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    
    func showTabBarTopBorder(_ color: CGColor, _ height: CGFloat = 1.0) {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height)
        topBorder.backgroundColor = color
        tabBarController?.tabBar.layer.addSublayer(topBorder)
        tabBarController?.tabBar.clipsToBounds = true
    }
    
    func omitNavBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    func hideNavBackButton() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func setNavigationItemTitleSubtitle(title: String, subtitle: String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        titleLabel.text = title.uppercased()
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        return titleView
    }
    
    func createBarButtonItem(_ style: CustomBarButtonStyle) -> UIBarButtonItem {
        let menuButton = UIBarButtonItem()
        menuButton.tintColor = UIColor.white
        menuButton.target = self
        menuButton.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 15, weight: .semibold)], for: .normal)
        
        switch style {
        case .menuEllipsis:
            menuButton.image = #imageLiteral(resourceName: "IconNavEllipsis")
            menuButton.action = #selector(menuEllipsisBarButtonTouchUpInside(_:))
            
        case .close:
            menuButton.image = #imageLiteral(resourceName: "IconNavClose")
            menuButton.action = #selector(closeBarButtonTouchUpInside(_:))
            
        case .cancel:
            menuButton.title = "Cancel"
            menuButton.action = #selector(cancelBarButtonTouchUpInside(_:))
            
        case .save:
            menuButton.title = "Save"
            menuButton.action = #selector(saveBarButtonTouchUpInside(_:))
            
        case .notification:
            //            menuButton.imageInsets = UIEdgeInsetsMake(0, 36, 0, 0)
            //            menuButton.image = #imageLiteral(resourceName: "IconNavNotifications")
            //            menuButton.action = #selector(notificationsBarButtonTouchUpInside(_:))
            //            let notifButton = BadgeButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            //            notifButton.setupSubviews()
            //            notifButton.addTarget(self, action: #selector(notificationsBarButtonTouchUpInside(_:)), for: .touchUpInside)
            //            menuButton.customView = notifButton
            break
            
        case .trash:
            menuButton.image = #imageLiteral(resourceName: "IconNavTrash")
            menuButton.action = #selector(trashBarButtonTouchUpInside(_:))
            
        default:
            break
        }
        
        return menuButton
    }
    
    
    // MARK: - Bar Button Action handlers
    @objc func closeBarButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func menuEllipsisBarButtonTouchUpInside(_ sender: Any) {}
    @objc func cancelBarButtonTouchUpInside(_ sender: Any) {}
    @objc func saveBarButtonTouchUpInside(_ sender: Any) {}
    @objc func notificationsBarButtonTouchUpInside(_ sender: Any) {}
    @objc func trashBarButtonTouchUpInside(_ sender: Any) {}
    
    // Toolbar Picker
    func createToolbarPicker(_ type: ToolbarPickerType) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var done = UIBarButtonItem()
        switch type {
        case .country:
            done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(countryPickerTouchUpInside(_:)))
        case .gender:
            done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(genderPickerTouchUpInside(_:)))
        case .birthDate:
            done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(birthDatePickerTouchUpInside(_:)))
        }
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPickerTouchUpInside(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancel, space, done], animated: false)
        
        return toolbar
    }
    
    @objc func cancelPickerTouchUpInside(_ sender: Any) {
        self.view.endEditing(true)
    }
    @objc func countryPickerTouchUpInside(_ sender: Any) {}
    @objc func genderPickerTouchUpInside(_ sender: Any) {}
    @objc func birthDatePickerTouchUpInside(_ sender: Any) {}
}
