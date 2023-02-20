//
//  CodeTextField.swift
//  PhoneVerificationController-PhoneVerificationControllerResources
//
//  Created by 三輪航大 on 2023/02/19.
//

import UIKit

open class CodeTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var deleteAction: (() -> Void)? = nil
    
    open override func deleteBackward() {
        if let _text = text, _text.isEmpty {
            deleteAction?()
        }
        super.deleteBackward()
    }
}
