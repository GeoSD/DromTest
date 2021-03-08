//
//  Interactor.swift
//  DromTest
//
//  Created by Дягилев Георгий Сергеевич on 09.03.2021.
//

import Foundation

protocol IInteractor
{
	var getNumberOfItems: Int { get }

	func startLoading(for index: Int, completion: @escaping (ImageResult) -> Void) -> UUID?
	func stopLoading(uuid: UUID)
	func removeSourceURL(at index: Int)
	func resetSource()
}
final class Interactor
{
	private let service: IImageService
	private var currentSourceUrl: [String] = []

	init(service: IImageService) {
		self.service = service
		self.currentSourceUrl = self.service.getSourceUrls
	}


}

extension Interactor: IInteractor
{
	var getNumberOfItems: Int {
		return self.currentSourceUrl.count
	}

	func startLoading(for index: Int, completion: @escaping (ImageResult) -> Void) -> UUID? {
		guard let url = URL(string: self.currentSourceUrl[index]) else {
			completion(.failure(.noUrl))
			return nil
		}
		return self.service.loadImage(url, completion)
	}

	func stopLoading(uuid: UUID) {
		self.service.cancelLoad(uuid)
	}

	func removeSourceURL(at index: Int) {
		self.currentSourceUrl.remove(at: index)
	}

	func resetSource() {
		self.currentSourceUrl = self.service.getSourceUrls
		self.service.resetCache()
	}
}
