//
//  ViewController.swift
//  Doubles
//
//  Created by Vincent Cubit on 11/22/21.
//


import UIKit
import Photos
import PhotosUI


final class SecondViewController: UIViewController {
    
    
    private let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collection.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.id)
        return collection
    }()
    
    
    private let first = ViewController()
    
    
//    override var isEditing: Bool {
//        didSet {
//            isEditing = !isEditing
//        }
//    }
    
    
    
    
    
    // This should equal the images that are inside of the file manager documents directory
    var data: [ UIImage ] = [
        
    ] {
        didSet {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collection)
        self.collection.delegate = self
        self.collection.dataSource = self
        
        
        self.view.backgroundColor = .systemBackground
        
        let flexibleSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        let trash = UIBarButtonItem(systemItem: .trash)
        trash.target = self
        trash.action = #selector(self.removeCollectionItem)
        let plus = UIBarButtonItem(systemItem: .add)
        plus.target = self
        plus.action = #selector(self.openPhotos)
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.toolbarItems = [ flexibleSpace, trash, flexibleSpace, plus ]
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        
        self.getImages(images: &self.data)
        print(self.data.count)
        
        
    }
    
    
    @objc func openPhotos() {
        var configPicker = PHPickerConfiguration(photoLibrary: .shared())
        configPicker.selectionLimit = 12
        configPicker.filter = .images
        let vc = PHPickerViewController(configuration: configPicker)
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true) {
            if self.isEditing {
                self.isEditing = false
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collection.frame = self.view.bounds
    }
    
    
    func sendData() -> [ UIImage ] {
        print("Data sent")
        return self.data
    }
    
    
    @objc private func removeCollectionItem() {
        if let selectedCells = self.collection.indexPathsForSelectedItems {
              let items = selectedCells.map { $0.item }.sorted().reversed()
              for item in items {
                self.data.remove(at: item)
              }
            self.collection.deleteItems(at: selectedCells)
            }
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.collection.allowsMultipleSelection = editing
        if self.isEditing {
            print(true)
        } else {
            print(false)
        }
    }


}


extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.data.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.id,
                                                            for: indexPath) as? CustomCell else { return UICollectionViewCell() }
        if self.data.count != 0 {
            cell.configure(image: self.data[indexPath.row])
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
    
    
    
}


extension SecondViewController: PHPickerViewControllerDelegate {
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    
        
        dismiss(animated: true)
        let group = DispatchGroup()
        var max = false
        
        
        
        var count = 0
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                defer {
                    group.leave()
                }
                
                
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                
                
                if( self?.data.count)! < 12 {
                    count += 1
                    self?.saveImage(image: image, withName: "image-\(count)")
                } else {
                    max = true
                }
                
                
            }
            
            
        }
        
        
        // Main thread
        group.notify(queue: .main) {
            if max {
                print("Max reached")
            }
            
        
            self.collection.reloadData()
            
            
        }

        
    }
    
    
}


extension UIViewController {
    
    
    func saveImage(image: UIImage, withName name: String) {

        
        let imageData = NSData(data: image.jpegData(compressionQuality: 0.7)!)
       let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,  FileManager.SearchPathDomainMask.userDomainMask, true)
       let docs = paths[0] as NSString
        print(docs)
       let name = name + NSUUID().uuidString + ".jpg"
       let fullPath = docs.appendingPathComponent(name)
       _ = imageData.write(toFile: fullPath, atomically: true)
        
        
   }
    
    
    func getImages(images: inout [ UIImage ]) {
        
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for imageURL in directoryContents where imageURL.pathExtension == "jpg" {
            if let image = UIImage(contentsOfFile: imageURL.path) {
                images.append(image)
            } else {
               fatalError("Can't create image from file \(imageURL)")
            }
        }
        
        
    }
    
    
}

