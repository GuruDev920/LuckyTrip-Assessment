//
//  DestinationCell.swift
//  LuckyTrip
//
//  Created by Li on 2022/8/9.
//

import UIKit

class DestinationCell: UICollectionViewCell {

    @IBOutlet weak var back_view: UIView!
    @IBOutlet weak var thumbnail_img: UIImageView!
    @IBOutlet weak var play_btn: UIButton!
    @IBOutlet weak var city_lbl: UILabel!
    @IBOutlet weak var country_lbl: UILabel!
    @IBOutlet weak var check_img: UIImageView!
    
    var playAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        back_view.clipsToBounds = true
        back_view.layer.cornerRadius = 10
        back_view.layer.borderWidth = 1
        back_view.layer.borderColor = UIColor.lightGray.cgColor
        
        thumbnail_img.backgroundColor = UIColor.lightGray
    }
    
    var destination: Destination! = nil {
        didSet {
            thumbnail_img.kf_setImage(destination.image, "")
            play_btn.isHidden = destination.video.isEmpty
            city_lbl.text = destination.city
            country_lbl.text = destination.country_name
        }
    }
    
    var select: Bool = false {
        didSet {
            check_img.isHidden = !select
        }
    }
    
    @IBAction func play_btn_click(_ sender: UIButton) {
        self.playAction?()
    }
}
