//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Marwa Abou Niaaj on 3/29/17.
//  Copyright © 2017 Marwa Abou Niaaj. All rights reserved.
//

import UIKit

private let cellIdentifier = "MemeTableViewCell"

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MemeTableViewCell
        
        let meme = memes[indexPath.row]
        
        //Configure the cell...
        cell.memeImageView.image = meme.image
        cell.setText(top: meme.top, bottom: meme.bottom)
        cell.memeTitle.text = meme.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailVC.meme = memes[indexPath.row]
        memeDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            if let memesTableView = self.tableView {
                (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: indexPath.row)
                memesTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
}



