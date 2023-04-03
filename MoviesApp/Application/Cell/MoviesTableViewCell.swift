//
//  MoviesTableViewCell.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 30.03.2023.
//

import UIKit
import Kingfisher

// MARK: - MoviesTableViewCellDelegate
protocol MoviesTableViewCellDelegate: AnyObject {
    func favouriteButtonTapped(cell: UITableViewCell)
}

// MARK: - MoviesTableViewCell
final class MoviesTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!
    
    // MARK: - Public properties
    weak var delegate: MoviesTableViewCellDelegate?
    
    // MARK: - Private properties
    private var isFavourite = false
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
        movieNameLabel.text = nil
        genreLabel.text = nil
        yearLabel.text = nil
        favouriteButton.setImage(UIImage(systemName: "heart"),
                                 for: .normal)
    }
    
    // MARK: - Public method
    func configure(movieName: String,
                   genre: String,
                   year: String,
                   imageUrl: String,
                   isFavourite: Bool) {
        movieImage.kf.setImage(with: URL(string: imageUrl))
        movieNameLabel.text = movieName
        genreLabel.text = genre
        yearLabel.text = year
        self.isFavourite = isFavourite
        favouriteButton.setImage(UIImage(systemName: isFavourite ? "heart.fill" : "heart"),
                                 for: .normal)
    }
    
    // MARK: - IBAction
    @IBAction private func onFavouriteButton(_ sender: UIButton) {
        isFavourite.toggle()
        favouriteButton.setImage(UIImage(systemName: isFavourite ? "heart.fill" : "heart"),
                                 for: .normal)
        delegate?.favouriteButtonTapped(cell: self)
    }
}
