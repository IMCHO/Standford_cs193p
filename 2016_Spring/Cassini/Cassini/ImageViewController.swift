//
//  ImageViewController.swift
//  Cassini
//
//  Created by In Taek Cho on 2020-09-22.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: URL? {
        didSet {
            image = nil
//            print("firsift")
            if view.window != nil {
                print("first")
                fetchImage()
            }
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
            spinner?.stopAnimating()
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
//            print(scrollView.contentSize)
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
            print("second")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
//        contentView.addSubview(imageView)
//        imageURL = URL(string: DemoURL.Stanford)
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
//            print(spinner)
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.imageURL {
                            self.image = UIImage(data: imageData)
                        } else {
                            print("ignored data returned from url \(url)")
                        }
                    }
                } else {
                    self.spinner?.stopAnimating()
                }
            }
        }
    }
}
 
extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

