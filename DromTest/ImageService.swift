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
			"https://wallpapersmug.com/download/800x600/926dad/iron-man-superhero-4k.jpg",
			"https://wallpapersmug.com/download/800x600/371e97/iron-man-new-suit-artwork.jpg",
			"https://wallpapersmug.com/download/800x600/b83b9f/night-iron-man-4k-illustration.jpg",
			"https://wallpapersmug.com/download/800x600/4166f9/iron-man-minimal-art.jpg",
			"https://wallpapersmug.com/download/800x600/190a22/iron-man-armor-mark-vii.jpg",
			"https://wallpapersmug.com/download/800x600/d713f4/iron-man-and-captain-america-movie-artwork.jpg"
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
