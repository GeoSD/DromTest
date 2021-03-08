//
//  LoadError.swift
//  DromTest
//
//  Created by Дягилев Георгий Сергеевич on 09.03.2021.
//

import Foundation

enum LoadError: Error
{
	case cancelled
	case noUrl
	case unKnown
}

extension LoadError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .noUrl:
			return NSLocalizedString("Image URL is incorrect", comment: "")
		case .cancelled:
			return NSLocalizedString("Image loading was cancelled", comment: "")
		case .unKnown:
			return NSLocalizedString("Unknown error occured", comment: "")
		}
	}
}
