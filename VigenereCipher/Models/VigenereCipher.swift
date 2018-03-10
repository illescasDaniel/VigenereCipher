//
//  VigenereCipher.swift
//  VigenereCipher
//
//  Created by Daniel Illescas Romero on 10/03/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

typealias VigenereCipher = VigenèreCipher
struct VigenèreCipher {
	
	var alphabet: String
	var key: String
	
	init() {
		self.key = "DANIEL"
		self.alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	}
	
	init?(key: String, alphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ", ignoreCase: Bool = false) {
		
		let finalAlphabet = ignoreCase ? alphabet.uppercased() : alphabet
		let finalKey = ignoreCase ? key.uppercased() : key
		
		let keyCharactersContainedInTheAlphabet = (finalKey.filter({ !finalAlphabet.contains($0) }) as [Character]).count == 0
		guard keyCharactersContainedInTheAlphabet else { return nil }
		
		self.key = finalKey
		self.alphabet = finalAlphabet
	}
	
	func encoded(text: String, ignoringCase: Bool = false) -> String? {
		
		let finalText = ignoringCase ? text.uppercased() : text
		let finalAlphabet = ignoringCase ? alphabet.uppercased() : alphabet
		let finalKey = ignoringCase ? key.uppercased() : key
		
		let charactersNotEqualToTheAlphabet = (finalText.filter({ !finalAlphabet.contains($0) && $0 != " " }) as [Character]).count
		guard charactersNotEqualToTheAlphabet == 0 else { return nil }
		
		var encodedString = ""
		
		var validIndex = 0
		for (_, character) in finalText.enumerated() {
			
			if character == " " {
				encodedString.append(" ")
				continue
			}
			
			let correspondingKeyChar = finalKey[validIndex % finalKey.count]
			
			if let charIndexInAlphabet = finalAlphabet.index(of: character)?.encodedOffset,
				let encodedCharIndexInAlphabet = finalAlphabet.index(of: correspondingKeyChar)?.encodedOffset {
				
				let encodedIndex = (charIndexInAlphabet + encodedCharIndexInAlphabet) % self.alphabet.count
				encodedString.append(finalAlphabet[encodedIndex])
			}
			
			validIndex += 1
		}
		
		return encodedString
	}
	
	func decoded(text: String, ignoringCase: Bool = false) -> String? {
		
		let finalText = ignoringCase ? text.uppercased() : text
		let finalAlphabet = ignoringCase ? alphabet.uppercased() : alphabet
		let finalKey = ignoringCase ? key.uppercased() : key
		
		let charactersNotEqualToTheAlphabet = (finalText.filter({ !finalAlphabet.contains($0) && $0 != " " }) as [Character]).count
		guard charactersNotEqualToTheAlphabet == 0 else { return nil }
		
		var encodedString = ""
		
		var validIndex = 0
		for (_, character) in finalText.enumerated() {
			
			if character == " " {
				encodedString.append(" ")
				continue
			}
			
			let correspondingKeyChar = finalKey[validIndex % finalKey.count]
			
			if let charIndexInAlphabet = finalAlphabet.index(of: character)?.encodedOffset,
				let encodedCharIndexInAlphabet = finalAlphabet.index(of: correspondingKeyChar)?.encodedOffset {
				
				let encodedIndex = (charIndexInAlphabet - encodedCharIndexInAlphabet)
				let encodedIndexWithModulus = encodedIndex % self.alphabet.count
				let finalIndex = (encodedIndex < 0) ? (encodedIndex + self.alphabet.count) : encodedIndexWithModulus
				encodedString.append(finalAlphabet[finalIndex])
			}
			
			validIndex += 1
		}
		
		return encodedString
	}
}
