//
//  MainViewController.swift
//  DromTest
//
//  Created by Дягилев Георгий Сергеевич on 09.03.2021.
//

import UIKit

protocol IMainViewController
{
	func refresh()
}

class MainViewController: UINavigationController
{
	private enum Constants {
		static let cellSpacing: CGFloat = 10
	}

	private let presenter: IPresenter
	private let refreshControl = UIRefreshControl()

	lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.makeCollectionViewLayout())
		collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: ImageViewCell.cellId)
		collectionView.backgroundColor = .lightGray
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()

	init(presenter: IPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.configure()
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)

		guard previousTraitCollection != nil else { return }
		self.collectionView.collectionViewLayout.invalidateLayout()
		self.collectionView.collectionViewLayout = self.makeCollectionViewLayout()
	}
}

extension MainViewController: IMainViewController
{
	func refresh() {
		self.collectionView.reloadData()
	}
}

extension MainViewController: UICollectionViewDataSource
{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.presenter.numberOfItems
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.cellId,
															for: indexPath) as? ImageViewCell else {
			assertionFailure("Unable to cast cell!")
			return UICollectionViewCell()
		}
		self.presenter.willDisplay(cell: cell, at: indexPath.row)
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		self.presenter.didEndDisplaying(at: indexPath.row)
	}
}

extension MainViewController: UICollectionViewDelegate
{
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
			self.presenter.selectItem(at: indexPath.row) {
				collectionView.deleteItems(at: [indexPath])
			}
		}
	}
}

private extension MainViewController
{
	func makeCollectionViewLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewFlowLayout()
		let cellWidthHeightConstant: CGFloat = UIScreen.main.bounds.width - Constants.cellSpacing * 2

		layout.scrollDirection = .vertical
		layout.minimumInteritemSpacing = Constants.cellSpacing
		layout.minimumLineSpacing = Constants.cellSpacing
		layout.itemSize = CGSize(width: cellWidthHeightConstant, height: cellWidthHeightConstant)
		layout.sectionInset = UIEdgeInsets(top: Constants.cellSpacing,
										   left: Constants.cellSpacing,
										   bottom: Constants.cellSpacing,
										   right: Constants.cellSpacing)
		return layout
	}

	func configure() {
		self.view.backgroundColor = .white
		self.view.addSubview(self.collectionView)

		NSLayoutConstraint.activate([
			self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
			self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
			self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
			self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
		])

		self.collectionView.refreshControl = self.refreshControl
		self.refreshControl.attributedTitle = NSAttributedString(string: "Reloading...")
		self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
	}

	@objc
	func refreshData() {
		self.presenter.refreshData(vc: self)
		self.refreshControl.endRefreshing()
	}
}
