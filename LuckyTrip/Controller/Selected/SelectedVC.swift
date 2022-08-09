//
//  SelectedVC.swift
//  LuckyTrip
//
//  Created by Sun on 2022/8/10.
//

import UIKit
import AVKit
import HCVimeoVideoExtractor

class SelectedVC: UIViewController {

    @IBOutlet weak var back_btn: UIButton!
    @IBOutlet weak var search_btn: UIButton!
    @IBOutlet weak var number_lbl: UILabel!
    @IBOutlet weak var names_lbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isLaunch = Bool()
    var destinations = [Destination]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        init_UI()
        setupCollectionView()
    }
    
    @IBAction func back_btn_click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func search_btn_click(_ sender: Any) {
        self.navigationController?.pushViewController(PickerVC(), animated: true)
    }
    
    // MARK: - Play Video
    func playVideo(_ videoUrl: String) {
        guard let url = URL(string: videoUrl) else { return }
        
        HCVimeoVideoExtractor.fetchVideoURLFrom(url: url, completion: { (video: HCVimeoVideo?, error:Error?) -> Void in
            if let err = error {
               print("Error = \(err.localizedDescription)")
               return
            }
            guard let vid = video else {
                print("Invalid video object")
                return
            }
            print("Title = \(vid.title), url = \(vid.videoURL), thumbnail = \(vid.thumbnailURL)")
            guard let videoURL = vid.videoURL[.Quality540p] else { return }
            DispatchQueue.main.async {
                let player = AVPlayer(url: videoURL)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.present(playerController, animated: true) {
                    player.play()
                }
            }
        })
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "DestinationCell", bundle: nil), forCellWithReuseIdentifier: "DestinationCell")
        collectionView!.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func init_UI() {
        number_lbl.text = "\(destinations.count)"
        names_lbl.text = destinations.map({$0.iata_code}).joined(separator: ", ")
        
        back_btn.isHidden = isLaunch
        search_btn.layer.cornerRadius = 5
        search_btn.layer.masksToBounds = true
    }
}

// MARK: - UICollectionView
extension SelectedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return destinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DestinationCell", for: indexPath) as! DestinationCell
        
        let destination = destinations[indexPath.row]
        cell.destination = destination
        cell.select = false
        cell.playAction = {
            self.playVideo(destination.video)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width-40, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
