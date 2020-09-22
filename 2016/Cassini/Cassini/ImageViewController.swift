//
//  ImageViewController.swift
//  Cassini
//
//  Created by In Taek Cho on 2020-09-22.
//

import UIKit

class ImageViewController: UIViewController {
    
    var imageURL: URL? {
        didSet {
            image = nil
            fetchImage()
        }
    }
    private var imageView = UIImageView()
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
//            print(scrollView.contentSize)
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
//            print(scrollView.contentSize)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        imageURL = URL(string: DemoURL.Stanford)
    }
    
    private func fetchImage() {
        if let url = imageURL {
            if let imageData = try? Data(contentsOf: url) {
                image = UIImage(data: imageData)
            }
        }
    }
}
 
