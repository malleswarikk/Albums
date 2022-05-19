//
//  ViewController.swift
//  Albums
//
//  Created by Malleswari on 17/05/22.
//

import UIKit

let albumCell = "AlbumCell"

class AlbumsViewController: UITableViewController {
    let viewModel = AlbumsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Albums"
        
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.startAnimating()
        self.tableView.backgroundView = spinner
        
        viewModel.getAlbums {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: albumCell, for: indexPath)
        cell.textLabel?.text = viewModel.albums[indexPath.row].title
        return cell
    }
}


