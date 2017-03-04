//
//  SettingsViewController.swift
//  at.me
//
//  Created by Joel Rorseth on 2017-03-01.
//  Copyright © 2017 Joel Rorseth. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UITableViewController {
    
    private lazy var usersRef: FIRDatabaseReference = FIRDatabase.database().reference().child("users")
    
    private enum UserAttribute {
        case none, displayName, email, firstName, lastName, password
    }
    
    private var currentAttributeChanging: UserAttribute = UserAttribute.none

    // ==========================================
    // ==========================================
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // ==========================================
    // ==========================================
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // ==========================================
    // ==========================================
    func dismissPopup() {
        self.view.endEditing(true)

        // Animate the popup off screen (downwards), fade view back in from dimmed state
        UIView.animate(withDuration: 0.9, animations: {
            
            self.view.viewWithTag(1000)?.frame.origin.y = 3000
            self.view.viewWithTag(2000)?.alpha = 0.0
            
        }, completion: { completion in
            
            // Remove popup view and dimmed view once completed animation
            self.view.viewWithTag(1000)?.removeFromSuperview()
            self.view.viewWithTag(2000)?.removeFromSuperview()
            
            return
        })
    }
    
    // ==========================================
    // ==========================================
    func changeSaved() {
        
        // Find text field with changed attribute, unwrap
        if let textfield = self.view.viewWithTag(4000) as? UITextField {
            print(textfield.text!)
            
            // TODO: Lookup and change user attribute if suitable
            
        }
        
    }
    
    // MARK: Table View
    // ==========================================
    // ==========================================
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var attributePrompt: String = ""
        
        // Determine which attributes have been chosen for edit
        switch indexPath.row {
        case 0:
            currentAttributeChanging = .displayName
            attributePrompt = "display name"
            break
        case 1:
            currentAttributeChanging = .email
            attributePrompt = "email address"
            break
        case 2:
            currentAttributeChanging = .firstName
            attributePrompt = "first name"
            break
        case 3:
            currentAttributeChanging = .lastName
            attributePrompt = "last name"
            break
        case 4:
            currentAttributeChanging = .password
            attributePrompt = "password"
            break
        default:
            break
        }
        
        
        // Dimmed view appears on top of self.view, but under popup view
        let dimmedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        dimmedView.backgroundColor = UIColor.black
        dimmedView.alpha = 0.0
        dimmedView.tag = 2000
        
        // Custom view to contain the popup
        let popupView = UIView(frame: CGRect(x: 10, y: 3000, width: view.bounds.size.width - 20, height: 250))
        popupView.layer.cornerRadius = 5
        popupView.layer.opacity = 0.98
        popupView.alpha = 0.0
        popupView.backgroundColor = UIColor.white
        popupView.tag = 1000
        
        // Label is added to the popup view
        let label = UILabel(frame: CGRect(x: 0, y: 20, width: popupView.bounds.size.width, height: 20))
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont(name: "System", size: 14)
        label.text = "Enter a new \(attributePrompt)"
        
        // Text field is added to the popup view
        let textField = UITextField(frame: CGRect(x: 20, y: 50, width: popupView.bounds.size.width - 40, height: 34))
        textField.tag = 4000
        textField.borderStyle = .roundedRect
        textField.textColor = UIColor.darkGray
        textField.textColor = UIColor.black
        
        // Button is added to the popup view
        let button = UIButton(frame: CGRect(x: 30, y: popupView.bounds.size.height - 70, width: popupView.bounds.size.width - 60, height: 50))
        button.addTarget(self, action: #selector(changeSaved), for: UIControlEvents.touchUpInside)
        button.backgroundColor = UIColor.darkGray
        button.contentHorizontalAlignment = .center
        button.setTitle("Save Changes", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "System", size: 16)
        button.layer.cornerRadius = 5
        
        popupView.addSubview(label)
        popupView.addSubview(textField)
        popupView.addSubview(button)
        
        // Add gesture recognizer to handle tapping outside of keyboard
        dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        popupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        self.view.addSubview(dimmedView)
        self.view.addSubview(popupView)
        
        // Animate the custom popup in and dim the background
        UIView.animate(withDuration: 0.5, animations: {
            dimmedView.layer.opacity = 0.7
            popupView.alpha = 1.0
            popupView.frame.origin.y = 50
        })
        
    }
}