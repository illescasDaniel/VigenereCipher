//
//  ViewController.swift
//  VigenereCipher
//
//  Created by Daniel Illescas Romero on 10/03/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {

	enum TextFieldsTags: Int {
		case key, alphabet, plainText, ciphertext
	}
	
	// MARK: - Properties
	
	@IBOutlet weak var keyTextField: NSTextField!
	@IBOutlet weak var alphabetTextField: NSTextField!
	@IBOutlet weak var plainTextTextField: NSTextField!
	@IBOutlet weak var ciphertextTextField: NSTextField!
	
	var requiredFields: [NSTextField?] {
		return [keyTextField, alphabetTextField]
	}
	var nonRequiredFields: [NSTextField?] {
		return [plainTextTextField, ciphertextTextField]
	}
	
	@IBOutlet weak var ignoreCaseCheckbox: NSButton!
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		[keyTextField, alphabetTextField, plainTextTextField, ciphertextTextField].forEach({ $0.delegate = self })
		
		keyTextField.tag = TextFieldsTags.key.rawValue
		alphabetTextField.tag = TextFieldsTags.alphabet.rawValue
		plainTextTextField.tag = TextFieldsTags.plainText.rawValue
		ciphertextTextField.tag = TextFieldsTags.ciphertext.rawValue
		
		nonRequiredFields.forEach({ $0?.isEnabled = false })
	}

	// MARK: - Actions
	
	override func controlTextDidChange(_ obj: Notification) {
		
		let errorColor = CGColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 0.9)
		
		nonRequiredFields.forEach({ $0?.isEnabled = true })
		
		for requiredField in requiredFields {
			if requiredField?.stringValue.isEmpty == true {
				requiredField?.layer?.borderWidth = 2
				requiredField?.layer?.borderColor = errorColor
				nonRequiredFields.forEach({ $0?.isEnabled = false })
				return
			}
		}
		
		let ignoreCase = ignoreCaseCheckbox.state == .on
		
		if ignoreCase {
			keyTextField.stringValue = keyTextField.stringValue.uppercased()
			alphabetTextField.stringValue = alphabetTextField.stringValue.uppercased()
			plainTextTextField.stringValue = plainTextTextField.stringValue.uppercased()
			ciphertextTextField.stringValue = ciphertextTextField.stringValue.uppercased()
		}
		
		guard let currentTextField = obj.object as? NSTextField else { return }
		
		if currentTextField.tag != TextFieldsTags.alphabet.rawValue {
			
			currentTextField.layer?.borderWidth = 0
			
			for character in currentTextField.stringValue {
				if character != " " && !alphabetTextField.stringValue.contains(character) {
					currentTextField.layer?.borderWidth = 2
					currentTextField.layer?.borderColor = errorColor
					return
				}
			}
		}
		
		let key = keyTextField.stringValue
		let alphabet = alphabetTextField.stringValue
		
		if currentTextField.tag == TextFieldsTags.ciphertext.rawValue  || (!ciphertextTextField.stringValue.isEmpty && plainTextTextField.stringValue.isEmpty) {
			
			guard !ciphertextTextField.stringValue.isEmpty else { return }
			
			let ciphertext = ciphertextTextField.stringValue
			plainTextTextField.stringValue = VigenereCipher(key: key, alphabet: alphabet, ignoreCase: ignoreCase)?.decoded(text: ciphertext) ?? ""
		}
		else {
				
			guard !plainTextTextField.stringValue.isEmpty else { return }
			
			let textToCipher = plainTextTextField.stringValue
			ciphertextTextField.stringValue = VigenereCipher(key: key, alphabet: alphabet, ignoreCase: ignoreCase)?.encoded(text: textToCipher) ?? ""
		}
		
		//self.updateFields()
	}

	@IBAction func ignoreCaseCheckboxAction(_ sender: NSButton) {
		if sender.state == .on {
			keyTextField.stringValue = keyTextField.stringValue.uppercased()
			alphabetTextField.stringValue = alphabetTextField.stringValue.uppercased()
			plainTextTextField.stringValue = plainTextTextField.stringValue.uppercased()
			//self.updateFields()
		}
	}
	
	// MARK: - Convenience
	
	/*func updateFields() {
		
		guard !plainTextTextField.stringValue.isEmpty else { return }
		
		let key = keyTextField.stringValue
		let alphabet = alphabetTextField.stringValue
		let textToCipher = plainTextTextField.stringValue
		let ignoreCase = ignoreCaseCheckbox.state == .on
		
		ciphertextTextField.stringValue = VigenereCipher(key: key, alphabet: alphabet, ignoreCase: ignoreCase)?.encoded(text: textToCipher) ?? ""
	}*/
}
