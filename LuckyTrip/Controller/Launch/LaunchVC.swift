//
//  LaunchVC.swift
//  LuckyTrip
//
//  Created by Li on 2022/8/9.
//

import UIKit

class LaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.pushViewController(PickerVC(), animated: true)
    }
}
