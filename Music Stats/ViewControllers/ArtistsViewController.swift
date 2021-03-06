//
//  ArtistsViewController.swift
//  Music Stats
//
//  Created by Zac Garby on 28/03/2018.
//  Copyright © 2018 Zac Garby. All rights reserved.
//

import UIKit

class ArtistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var chart: PieChartView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var data: [(String, Double)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        table.isHidden = true
        chart.isHidden = true
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let fetchedData = getData(category: { song in song.artist }) else {
            performSegue(withIdentifier: "data-error", sender: nil)
            return
        }
        
        chart.load(data: fetchedData)
        data = fetchedData
        table.reloadData()
        table.setNeedsLayout()
        
        table.isHidden = false
        chart.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath) as! ArtistCell
        let name = cell.name.text
        
        chart.selected = name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "artist cell") as! ArtistCell
        let (name, count) = data[indexPath.row]
        
        if let proportion = chart.getPercentage(of: name) {
            let percentage = proportion * 100
            cell.name.text = name
            cell.percentage.text = "\(round(percentage * 10) / 10)% (\(Int(count)) tracks)" // rounded to 2 d.p.
            cell.colour.fill = chart.colour(for: name)!
        }
        
        return cell
    }
}

