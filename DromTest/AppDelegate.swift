//
//  AppDelegate.swift
//  DromTest
//
//  Created by Дягилев Георгий Сергеевич on 09.03.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = self.makeRootViewController()
		window?.makeKeyAndVisible()
		return true
	}
}

private extension AppDelegate
{
	func makeRootViewController() -> UIViewController {
		let service = ImageService()
		let interactor = Interactor(service: service)
		let presenter = Presenter(interactor: interactor)
		let rootVC = MainViewController(presenter: presenter)
		return rootVC
	}
}

