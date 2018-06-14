//
//  ViewController.swift
//  CollectionViewDemo
//
//  Created by 张思槐 on 2018/6/14.
//  Copyright © 2018年 demo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var images = ["Yosemite 1", "Yosemite 2", "Yosemite 3", "Yosemite 4", "Yosemite 5",
                  "Yosemite 1", "Yosemite 2", "Yosemite 3", "Yosemite 4", "Yosemite 5",
                  "Yosemite 1", "Yosemite 2", "Yosemite 3", "Yosemite 4", "Yosemite 5"]
    var imageCache = [IndexPath: UIImage]()
    
    var serialQueue: DispatchQueue!

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            collectionView.dataSource = self
            collectionView.prefetchDataSource = self
            collectionView.collectionViewLayout = ImageCollectionViewLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.serialQueue = DispatchQueue(label: "Decode Image Queue")
        
    }
    
    func imageURL(_ name: String) -> URL {
        return Bundle.main.url(forResource: name, withExtension: "jpg")!
    }
    
    // 创建缩略图以降低内存的使用
    func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
        
        //创建imageSource的时候先不要对图片进行解码
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        //创建thumbnail的时候直接解码
        let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                 kCGImageSourceShouldCacheImmediately: true,
                                 kCGImageSourceCreateThumbnailWithTransform: true,
                                 kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        
        //生成图片
        let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
        return UIImage(cgImage: downsampledImage)
        
    }

}

extension ViewController: UICollectionViewDataSourcePrefetching {
    // 在 collectionView(_:cellForItemAt:) 中调用downsample方法会因为图片解码造成卡顿
    // 通过下面方法提前准备好数据，可以避免图片解码造成的卡顿
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if (self.imageCache.keys.contains(indexPath)) { return }
            serialQueue.async {
                let imageURL = self.imageURL(self.images[indexPath.item])
                let downsampledImage = self.downsample(imageAt: imageURL, to:CGSize(width: 1024, height: 1024) , scale: 1.0)
                DispatchQueue.main.async {
                    self.update(at: indexPath, with: downsampledImage)
                }
            }
        }
    }
    
    func update(at indexPath: IndexPath, with image: UIImage) {
        self.imageCache[indexPath] = image
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        if let downsampledImage = self.imageCache[indexPath] {
            cell.imageView.image = downsampledImage
        }
        else {
            let imagePath = Bundle.main.path(forResource: self.images[indexPath.item], ofType: "jpg")!
            let image = UIImage(contentsOfFile: imagePath)
            cell.imageView.image = image
        }
        return cell
    }
}

// MARK: Layout
class ImageCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        let screenSize = UIScreen.main.bounds.size
        let itemWidth = floor((screenSize.width - minimumInteritemSpacing) / 2)
        let itemHeight: CGFloat = 200
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        minimumLineSpacing = 20
        minimumInteritemSpacing = 20
    }
}



