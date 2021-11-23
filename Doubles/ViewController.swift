//
//  ViewController.swift
//  Doubles
//
//  Created by Vincent Cubit on 11/22/21.
//


import UIKit


final class ViewController: UIViewController {
    
    
    private let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collection.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.id)
        return collection
    }()
    
    
    var data: [ UIImage ] = [
        
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collection)
        self.collection.delegate = self
        self.collection.dataSource = self
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.goToNext))
        self.navigationItem.rightBarButtonItem = next
        
        
        let second = SecondViewController()
        self.data = second.sendData()
        print(self.data)
                
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collection.frame = self.view.bounds
    }
    
    
    @objc func goToNext() {
        let second = SecondViewController()
        self.navigationController?.pushViewController(second, animated: true)
    }
    
    
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
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

