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

    @IBOutlet weak var search_country_img: UIImageView!
    @IBOutlet weak var search_city_img: UIImageView!
    @IBOutlet weak var search_text: UITextField!
    @IBOutlet weak var search_btn: UIButton!
    @IBOutlet weak var save_btn: UIButton!
    @IBOutlet weak var country_sort_img: UIImageView!
    @IBOutlet weak var city_sort_img: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var destinations = [Destination]()
    private var selected = [Destination]()
    private var type = SearchType.none
    
    private var search_country = Bool()
    private var search_city = Bool()
    
    private var sort_country = Bool()
    private var sort_city = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        init_UI()
        setupCollectionView()
    }
    
    // MARK: - Search Type
    @IBAction func type_btn_click(_ sender: UIButton) {
        if sender.tag == 0 { // country
            search_country = !search_country
        } else {
            search_city = !search_city
        }
        search_country_img.image = UIImage(systemName: search_country ? "dot.circle" : "circle")
        search_city_img.image = UIImage(systemName: search_city ? "dot.circle" : "circle")
        
        if search_country && search_city {
            type = .city_or_country
        } else if search_country {
            type = .country
        } else if search_city {
            type = .city
        } else {
            type = .none
        }
    }
    
    // MARK: - Search
    @IBAction func search_btn_click(_ sender: UIButton) {
        search()
    }
    
    func search() {
        Services.getDestinations(type: type, value: search_text.text!) { (result, error) in
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
    
    // MARK: - Save
    @IBAction func save_btn_click(_ sender: UIButton) {
        
    }
    
    // MARK: - Sort
    @IBAction func sort_btn_click(_ sender: UIButton) {
        if sender.tag == 0 { // country
            sort_country = !sort_country
            country_sort_img.image = UIImage(systemName: sort_country ? "increase.indent" : "decrease.indent")
            destinations = destinations.sorted{sort_country ? ($0.country_name < $1.country_name) : ($0.country_name > $1.country_name)}
        } else {
            sort_city = !sort_city
            city_sort_img.image = UIImage(systemName: sort_city ? "increase.indent" : "decrease.indent")
            destinations = destinations.sorted{sort_city ? ($0.city < $1.city) : ($0.city > $1.city)}
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
    
    func init_UI() {
        search_text.setLeftPaddingPoints(10)
        search_text.setRightPaddingPoints(10)
        search_text.delegate = self
        
        search_btn.layer.cornerRadius = 5
        search_btn.layer.masksToBounds = true
        
        save_btn.layer.cornerRadius = 5
        save_btn.layer.masksToBounds = true
        save_btn.isEnabled = false
        save_btn.alpha = 0.5
    }
}

// MARK: - UITextFieldDelegate
extension PickerVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        search()
        return true
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
        save_btn.isEnabled = selected.count > 2
        save_btn.alpha = selected.count > 2 ? 1 : 0.5
        collectionView.reloadItems(at: [indexPath])
    }
}
