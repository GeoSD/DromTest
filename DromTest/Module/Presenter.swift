//
//  Presenter.swift
//  DromTest
//
//  Created by Дягилев Георгий Сергеевич on 09.03.2021.
//

import UIKit

protocol IPresenter
{
	var numberOfItems: Int { get }

	func willDisplay(cell: ImageViewCell, at index: Int)
	func didEndDisplaying(at index: Int)
	func selectItem(at index: Int, completion: @escaping () -> Void)
	func refreshData(vc: IMainViewController)
}
final class Presenter
{
	private let interactor: IInteractor

	private var loadingItem: [Int: UUID] = [:]

	init(interactor: IInteractor) {
		self.interactor = interactor
	}
}

extension Presenter: IPresenter
{
	var numberOfItems: Int {
		return interactor.getNumberOfItems
	}

	func willDisplay(cell: ImageViewCell, at index: Int) {
		cell.startLoad()
		let uuid = self.interactor.startLoading(for: index) { result in
			switch result {
			case .success(let image):
				cell.endLoad(image: image)
			case .failure(let error):
				cell.endLoad(image: nil)
				print(error.localizedDescription)
			}
		}
		if let uuid = uuid {
			self.loadingItem[index] = uuid
		}
	}

	func didEndDisplaying(at index: Int) {
		guard let uuid = self.loadingItem[index] else {
			return
		}
		self.interactor.stopLoading(uuid: uuid)
	}

	func selectItem(at index: Int, completion: @escaping () -> Void) {
		self.interactor.removeSourceURL(at: index)
		completion()
	}

	func refreshData(vc: IMainViewController) {
		self.interactor.resetSource()
		self.loadingItem = [:]
		DispatchQueue.main.async {
			vc.refresh()
		}
	}
}
