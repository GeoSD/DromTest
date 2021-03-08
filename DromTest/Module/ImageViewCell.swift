//
//  ImageViewCell.swift
//  DromTest
//
//  Created by Дягилев Георгий Сергеевич on 09.03.2021.
//

import UIKit

class ImageViewCell: UICollectionViewCell
{
	static let cellId = String(describing: self)

	private let imageView = UIImageView()

	private var imageViewCenterXConstraint = NSLayoutConstraint()
	private let activityIndicator = UIActivityIndicatorView()

	override var isSelected: Bool {
		didSet {
			UIView.animate(withDuration: 1) { [weak self] in
				guard let self = self else { return }
				NSLayoutConstraint.deactivate([
					self.imageViewCenterXConstraint
				])
				NSLayoutConstraint.activate([
					self.imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: self.bounds.width * 2)
				])
				self.layoutIfNeeded()
			}
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .clear

		self.imageView.contentMode = .scaleAspectFill
		self.imageView.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(self.imageView)

		self.activityIndicator.color = .black
		self.activityIndicator.hidesWhenStopped = true
		self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(self.activityIndicator)

		self.imageViewCenterXConstraint = self.imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)

		NSLayoutConstraint.activate([
			self.imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
			self.imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
			self.imageViewCenterXConstraint,
			self.imageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),

//			self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//			self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
//			self.imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
//			self.imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),

			self.activityIndicator.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
			self.activityIndicator.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor)
		])
		self.contentView.clipsToBounds = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func startLoad() {
		DispatchQueue.main.async {
			self.activityIndicator.startAnimating()
			self.activityIndicator.isHidden = false
			self.imageView.image = nil
		}
	}

	func endLoad(image: UIImage?) {
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
			self.imageView.image = image
		}
	}
}
