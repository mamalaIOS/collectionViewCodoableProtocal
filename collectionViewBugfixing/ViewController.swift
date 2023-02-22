//
//  ViewController.swift
//  collectionViewBugfixing
//
//  Created by Amel Sbaihi on 1/26/23.
//

import UIKit

class ViewController: UICollectionViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let cellReuseID = "Person"
    var people = [Person]()
    
    
    //MARK: vc lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let defaults = UserDefaults.standard
        
        if let decodedData = defaults.object(forKey: "people") as? Data {
            
           
            let jsonDecoder = JSONDecoder()
            
            do {
                
               people = try jsonDecoder.decode([Person].self, from: decodedData)
            }
            
            catch {
                print ("there was an error boom. ")
            }
            
        }
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    
    //MARK: COLLECTIONVIEW DATA SOURCE METHODS
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as? PersonCell else {fatalError("this mf crashing my app")}
        let person = people[indexPath.item]
        cell.name.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 7
        cell.layer.cornerRadius = 7
        return cell
        
    }
    
    
    
    
    
    
    
    
    
    //MARK: method that allows the user to selecte an image from photo library

    
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true )
        
        
    }
    
    //MARK: UIImagePickerControllerDelegate methode which does the following :
    
   
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            
            try? jpegData.write(to: imagePath)
            
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        save()
        
        dismiss(animated: true)
        
        
    }
    
    //MARK: documentDirectory methode
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
   //MARK: tableview delegate methods
 
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let alert = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        
        alert.addAction( UIAlertAction(title: "cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak self, weak alert ] _ in
            
            
            guard let newName = alert?.textFields?[0].text else {return}
            person.name = newName
            self?.collectionView.reloadData()
            
            self?.save()
            
           
        }))
        
        present(alert, animated: true )
        
        
    }
    
    
    func save () {
        
     
        
        let jsonEncoder = JSONEncoder()
       
        if let savedData = try? jsonEncoder.encode(people)
        
        {
            
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
            
        }
        
        else {
            print("failed to encode data")
            
        }
        
        
        
    }
    
    

}
