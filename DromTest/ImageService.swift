//
//  ImageService.swift
//  DromTest
//
//  Created by Дягилев Георгий Сергеевич on 09.03.2021.
//

import UIKit

typealias ImageResult = Result<UIImage, LoadError>

protocol IImageService
{
	var getSourceUrls: [String] { get }
	func loadImage(_ url: URL, _ completion: @escaping (ImageResult) -> Void) -> UUID?
	func cancelLoad(_ uuid: UUID)
	func resetCache()
}

final class ImageService
{
	private var loadedImages: [URL: UIImage] = [:]
	private var runningRequests: [UUID: URLSessionDataTask] = [:]
}

extension ImageService: IImageService
{
	var getSourceUrls: [String] {
		return [
			"https://images7.alphacoders.com/867/867279.jpg",
			"https://images8.alphacoders.com/463/463477.jpg",
			"https://images6.alphacoders.com/613/613924.jpg",
			"https://images2.alphacoders.com/703/703553.jpg",
			"https://images2.alphacoders.com/159/159692.jpg",
			"https://images8.alphacoders.com/867/867237.jpg"
		]
	}

	func loadImage(_ url: URL, _ completion: @escaping (ImageResult) -> Void) -> UUID? {
		if let image = loadedImages[url] {
			completion(.success(image))
			return nil
		}

		let uuid = UUID()

		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			defer {
				self.runningRequests.removeValue(forKey: uuid)
			}
			if let data = data, let image = UIImage(data: data) {
				self.loadedImages[url] = image
				completion(.success(image))
				return
			}
			guard let error = error else {
				completion(.failure(.unKnown))
				return
			}
			guard (error as NSError).code == NSURLErrorCancelled else {
				completion(.failure(.cancelled))
				return
			}
		}
		task.resume()

		runningRequests[uuid] = task
		return uuid
	}

	func cancelLoad(_ uuid: UUID) {
		runningRequests[uuid]?.cancel()
		runningRequests.removeValue(forKey: uuid)
	}

	func resetCache() {
		self.loadedImages = [:]
	}
}
