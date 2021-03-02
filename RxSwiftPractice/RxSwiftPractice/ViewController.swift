//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by 김기현 on 2021/01/26.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var itemAdd: UIBarButtonItem!
    
    private let bag = DisposeBag()
    private var images = BehaviorRelay<[UIImage]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images.asObservable().subscribe(onNext: { [weak self] photos in
            self?.updateUI(photos: photos)
        }).disposed(by: bag)
        
        images.subscribe(onNext: { [weak imagePreview] photos in
            guard let preview = imagePreview else { return }
            
            preview.image = UIImage.collage(images: photos, size: preview.frame.size)
        }).disposed(by: bag)
    }
    
    private func updateUI(photos: [UIImage]) {
        buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
        buttonClear.isEnabled = photos.count > 0
        itemAdd.isEnabled = photos.count < 6
        title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
    }
    
    @IBAction func actionClear(_ sender: Any) {
        images.accept([])
    }
    

    @IBAction func actionAdd(_ sender: Any) {
//        let newImages = images.value + [UIImage(named: "Barcelona.jpeg")!]
//        images.accept(newImages)
        
        let photosViewController = storyboard!.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
        photosViewController.selectedPhotos.subscribe(onNext: { [weak self] newImage in
            guard let images = self?.images else { return }
            images.accept(images.value + [newImage])
        }, onDisposed: {
            print("completed photo selection")
        }).disposed(by: bag)
        
        navigationController?.pushViewController(photosViewController, animated: true)
    }
    
}

