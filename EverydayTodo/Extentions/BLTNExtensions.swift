////
////  BTNBExtensions.swift
////  EverydayTodo
////
////  Created by Tony Jung on 2020/12/18.
////
//
//import Foundation
//import BLTNBoard
//
//class GerbilPageItem: BLTNPageItem {
//
//    public private(set) var textField: UITextField!
//
//    override init(title: String) {
//        super.init(title: "Title")
//         self.descriptionText = "Description"
//         self.actionButtonTitle = "Ok"
//         self.isDismissable = true
//         self.alternativeButtonTitle = "Cancel"
//
//        self.presentationHandler = { (_ item: BLTNItem) in
//            self.textField?.becomeFirstResponder() // open the keyboard
//        }
//    
//    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
//        var contentViews = [UIView]()
//        
//            let textField = interfaceBuilder.makeTextField(delegate: self)
//            textField.returnKeyType = .done
//            textField.spellCheckingType = .no
//            textField.autocorrectionType = .no
//            textField.autocapitalizationType = .none
//            textField.placeholder = "username"
//            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//            contentViews.append(textField)
//            self.textField = textField
//        
//        return contentViews
//    }
//}
//
//extension GerbilPageItem: UITextFieldDelegate {
//    
//    @objc func textFieldDidChange(textField: UITextField) {
//        textField.text = textField.text?.lowercased()
//       // actionButton?.isEnabled = textField.text?.trim().isValidUsername() ?? false
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let text = textField.text, text.isEmpty == false {
//            textField.resignFirstResponder()
//            return true
//        } else {
//            textField.backgroundColor = .red
//            return false
//        }
//    }
//}
