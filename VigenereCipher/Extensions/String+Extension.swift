//
//  String+Extension.swift
//  VigenereCipher
//
//  Created by Daniel Illescas Romero on 10/03/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension String {
	subscript(safe index: Int) -> Character? {
		if index > 0 && index < count {
			let index = self.index(self.startIndex, offsetBy: index)
			return self[index]
		}
		return nil
	}
	subscript(_ index: Int) -> Character {
		let index = self.index(self.startIndex, offsetBy: index)
		return self[index]
	}
	
	var reversed: String {
		return String(self.reversed())
	}
}
