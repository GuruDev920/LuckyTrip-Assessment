//
//  PickerVC.swift
//  LuckyTrip
//
//  Created by Li on 2022/8/9.
//

import UIKit
import AVKit
import HCVimeoVideoExtractor

class PickerVC: UIViewController {

    @IBOutlet weak var country_sort_img: UIImageView!
    @IBOutlet weak var city_sort_img: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var destinations = [Destination]()
    private var selected = [Destination]()
    
    private var country_sort = Bool()
    private var city_sort = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        init_data()
        setupCollectionView()
    }
    
    // MARK: - Sort
    @IBAction func sort_btn_click(_ sender: UIButton) {
        if sender.tag == 0 { // country
            country_sort = !country_sort
            country_sort_img.image = UIImage(systemName: country_sort ? "increase.indent" : "decrease.indent")
            destinations = destinations.sorted{country_sort ? ($0.country_name < $1.country_name) : ($0.country_name > $1.country_name)}
        } else {
            city_sort = !city_sort
            city_sort_img.image = UIImage(systemName: city_sort ? "increase.indent" : "decrease.indent")
            destinations = destinations.sorted{city_sort ? ($0.city < $1.city) : ($0.city > $1.city)}
        }
        collectionView.reloadData()
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
    
    func init_data() {
        Services.getDestinations(type: .none, value: "") { (result, error) in
            if error != nil {
                return
            }
            self.destinations.removeAll()
            for item in result!["destinations"].arrayValue {
                self.destinations.append(Destination(item))
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionView
extension PickerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return destinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DestinationCell", for: indexPath) as! DestinationCell
        
        let destination = destinations[indexPath.row]
        cell.destination = destination
        cell.select = selected.map({$0.id}).contains(destination.id)
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
        
        let destination = destinations[indexPath.row]
        if selected.map({$0.id}).contains(destination.id) {
            selected = selected.filter{$0.id != destination.id}
        } else {
            selected.append(destination)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}
