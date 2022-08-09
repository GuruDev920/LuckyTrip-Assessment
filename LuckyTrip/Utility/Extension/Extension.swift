//
//  Extension.swift
//  LuckyTrip
//
//  Created by Sun on 2022/8/9.
//

import Foundation
import Kingfisher

extension UIImageView {
    func kf_setImage(_ url: String, _ placeholder_img: String) {
        let img_url = URL(string: url.replacingOccurrences(of: " ", with: "%20"))
        let processor = DownsamplingImageProcessor(size: self.frame.size) |> RoundCornerImageProcessor(cornerRadius: 0)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: img_url, placeholder: UIImage(named: placeholder_img), options: [.processor(processor),.scaleFactor(UIScreen.main.scale),.transition(.fade(1)),.cacheOriginalImage])
    }
}
