//
//  ViewController.swift
//  LocalNotificationsUIKit
//
//  Created by Justin Hold on 2/28/24.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			title: "Register",
			style: .plain,
			target: self,
			action: #selector(registerLocal)
		)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Schedule",
			style: .plain,
			target: self,
			action: #selector(scheduleLocal)
		)
	}

	// MARK: - @OBJC FUNCTIONS
	/// Where we request permission to show notifications
	@objc func registerLocal() {
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
				if granted {
					print("Yay!")
				} else {
					print("FUCK!")
				}
		}
	}
	
	/// Notification details
	@objc func scheduleLocal() {
		
		let center = UNUserNotificationCenter.current()
		center.removeAllDeliveredNotifications()
		
		let content = UNMutableNotificationContent()
		content.title = "Late wake up call"
		content.body = "The early bird yada yada"
		content.categoryIdentifier = "alarm"
		content.userInfo = ["customData": "fizzBuzz"]
		content.sound = .default
		
		// Trigger
		var dateComponents = DateComponents()
		dateComponents.hour = 10
		dateComponents.minute = 30
		
//		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		center.add(request)
	}
	
	// MARK: - FUNCTIONS
	/// Button for user to tap. Requires: Parameter, Title, Options
	func registerCategories() {
		let center = UNUserNotificationCenter.current()
		center.delegate = self
		
		let show = UNNotificationAction(identifier: "show", title: "Tell me...", options: .foreground)
		let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
		
		center.setNotificationCategories([category])
	}
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void
	) {
		let userInfo = response.notification.request.content.userInfo
		
		if let customData = userInfo["customData"] as? String {
			print("Custom Data received: \(customData)")
			
			switch response.actionIdentifier {
			case UNNotificationDefaultActionIdentifier:
				// the user swiped to unlock
				print("Default Identifier")
			case "show":
				print("Show more info")
			default:
				break
			}
		}
		completionHandler()
	}
}

