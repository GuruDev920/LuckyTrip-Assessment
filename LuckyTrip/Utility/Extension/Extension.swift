//
//  Extension.swift
//  LuckyTrip
//
//  Created by Li on 2022/8/9.
//

import Foundation
import Kingfisher

// MARK: - UIImageView
extension UIImageView {
    func kf_setImage(_ url: String, _ placeholder_img: String) {
        let img_url = URL(string: url.replacingOccurrences(of: " ", with: "%20"))
        let processor = DownsamplingImageProcessor(size: self.frame.size) |> RoundCornerImageProcessor(cornerRadius: 0)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: img_url, placeholder: UIImage(named: placeholder_img), options: [.processor(processor),.scaleFactor(UIScreen.main.scale),.transition(.fade(1)),.cacheOriginalImage])
    }
}

// MARK: - UITextField
extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
