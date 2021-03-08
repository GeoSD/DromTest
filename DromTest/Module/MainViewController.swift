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

class MainViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

extension MainViewController: IMainViewController
{
	func refresh() {
		
	}
}
