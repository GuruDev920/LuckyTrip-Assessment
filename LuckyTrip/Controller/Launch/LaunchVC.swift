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

        check_saved()
    }
    
    func check_saved() {
        let destinations = Destination.getSaved()
        if destinations.count > 0 {
            let vc = SelectedVC()
            vc.isLaunch = true
            vc.destinations = destinations
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.navigationController?.pushViewController(PickerVC(), animated: true)
        }
    }
}
