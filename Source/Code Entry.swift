//
//  Code Entry.swift
//  PhoneVerificationController
//
//  Created by David Jennes on 30/08/2017.
//  Copyright © 2017 Appwise. All rights reserved.
//

import UIKit

extension PhoneVerificationController: UITextFieldDelegate {
    
	@IBAction func enteredCodeCharacter(_ sender: CodeTextField) {

		// update field UI
		let filled = !(sender.text?.isEmpty ?? true)
		UIView.animate(withDuration: configuration.animationDuration) { [unowned self] in
			sender.backgroundColor = filled ? self.configuration.codeFieldBackgroundFilled : self.configuration.codeFieldBackgroundEmpty
		}

		// update the verify button
		let allFilled = !codeTextFields.contains { ($0.text?.isEmpty ?? true) }
		UIView.animate(withDuration: configuration.animationDuration) { [unowned self] in
			self.codeSendButton.isEnabled = allFilled
			self.codeSendButton.backgroundColor = allFilled ? self.configuration.buttonBackgroundEnabled : self.configuration.buttonBackgroundDisabled
		}

		// transfer responder to next field
		sender.resignFirstResponder()
		codeTextFields.first { $0.text?.isEmpty ?? true }?.becomeFirstResponder()
	}

	@IBAction func focusOnLastField() {
		if let last = codeTextFields.first(where: { $0.text?.isEmpty ?? true }) {
			last.becomeFirstResponder()
		} else {
			codeTextFields.last?.becomeFirstResponder()
		}
	}
    
    func pastePin(pin: String) {
        for (index, char) in pin.enumerated() {
            guard index < 6 else { return }
            codeTextFields[index].text = String(char)
            enteredCodeCharacter(codeTextFields[index])
        }
    }

    func keyboardInputShouldDelete(_ textField: CodeTextField) {
		guard let index = codeTextFields.firstIndex(of: textField), index > 0 else { return }
        codeTextFields[index].resignFirstResponder()
        UIView.animate(withDuration: configuration.animationDuration) { [unowned self] in
            self.codeTextFields[index - 1].backgroundColor = self.configuration.codeFieldBackgroundEmpty
        }
        codeTextFields[index - 1].text = ""
        codeTextFields[index - 1].becomeFirstResponder()
	}

	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let text = textField.text as NSString? else { return true }
        if (string.count > 1) && (string == UIPasteboard.general.string) {
            textField.resignFirstResponder()
            DispatchQueue.main.async { self.pastePin(pin: string) }
        }
		return text.replacingCharacters(in: range, with: string).count <= 1
	}

	@IBAction func tryAgain() {
        view.endEditing(true)
		UIView.animate(withDuration: configuration.animationDuration) { [unowned self] in
			self.phoneContainerView.isHidden = false
			self.phoneContainerView.alpha = 1
			self.codeContainerView.isHidden = true
			self.codeContainerView.alpha = 0
			self.codeSendButton.isEnabled = false
			self.codeSendButton.backgroundColor = self.configuration.buttonBackgroundDisabled
			self.codeActivityIndicator.stopAnimating()
		}
        phoneNumberField.becomeFirstResponder()
	}

	@IBAction func verifyCode(_ sender: Any) {
		let code = codeTextFields.reduce("") { $0 + ($1.text ?? "") }

		codeActivityIndicator.startAnimating()
		configuration.signIn(configuration.verificationID ?? "", code) { [weak self] error in
			guard let strongSelf = self else { return }

			strongSelf.codeActivityIndicator.stopAnimating()
			if let error = error {
				strongSelf.show(error: error, in: strongSelf.codeDescriptionLabel, original: L10n.Description.code)
			} else {
				strongSelf.codeDescriptionLabel.text = L10n.Message.success
				if let delegate = strongSelf.delegate {
					delegate.verified(phoneNumber: strongSelf.phoneNumber, controller: strongSelf)
				} else {
					strongSelf.dismiss(animated: true, completion: nil)
				}
			}
		}
	}
}
