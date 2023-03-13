//
//  ViewController.swift
//  Project1
//
//  Created by Samuel on 2022-10-17.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    var picDictionary = [String: Int]()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Storm Viewer"
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
        
        //Project 9 - Challenge 1: Modify so that loading NSSL bundles will be done in the background
        performSelector(inBackground: #selector(loadPhotos), with: nil)
    }
    
    @objc func loadPhotos() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                
                
                pictures.append(item)
                pictures.sort()
                
                picDictionary[item] = 0
                 
                
            }
        }
        

        print(pictures)
        
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)

        //Project 9 Challenge 1. Modify reloadData() on the table view once loading has finished
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)

        let picture = pictures[indexPath.row]
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Shown times: \(picDictionary[picture]!)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            
            let picture = pictures[indexPath.row]
            picDictionary[picture]! += 1
            save()
            tableView.reloadData()
            
            
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
        
    }
    
    
    @objc func shareApp(_ sender: UIButton) {
            
            // text to share
            let text = "Hey everyone! Check out this app"
            
            // set up activity view controller
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
            
            
        }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(picDictionary),
           let savedPictures = try? jsonEncoder.encode(pictures) {
            
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "picDictionary")
            defaults.set(savedPictures, forKey: "pictures")
        }
            
        else {
            print("Failed to save data.")
        }
        
    }
        
        
    }

