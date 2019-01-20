//
//  AlertHelper.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 1/18/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import Foundation
import UIKit

class CustomAlert {
    func showAlert (headingAlert: String, messageAlert: String, actionTitle: String, viewController: UIViewController, handleAction: @escaping (_ action: UIAlertAction) -> ()) {
        var alert: UIAlertController = UIAlertController(title: headingAlert, message: messageAlert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: handleAction))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
