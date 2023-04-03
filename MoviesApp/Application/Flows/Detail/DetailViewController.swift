//
//  DetailViewController.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 02.04.2023.
//

import UIKit
import Kingfisher

// MARK: - DetailViewControllerProtocol
protocol DetailViewControllerProtocol: AnyObject {
    func setupUI(with movie: Movie)
    func shareLink(for movie: Movie)
}

// MARK: - DetailViewController
final class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    
    // MARK: - Public properties
    var presenter: DetailViewPresenterProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded()
    }
    
    // MARK: - IBActions
    @IBAction private func onBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func onShareButton(_ sender: UIButton) {
        presenter.shareButtonTapped()
    }
}

// MARK: - DetailViewControllerProtocol implementation
extension DetailViewController: DetailViewControllerProtocol {
    func setupUI(with movie: Movie) {
        movieImage.kf.setImage(with: URL(string: movie.artworkUrl100.notNil))
        nameLabel.text = movie.trackName
        genreLabel.text = movie.primaryGenreName
        yearLabel.text = DateHelper.convertDate(from: movie.releaseDate.notNil)
        descriptionTextView.text = movie.longDescription
    }
    
    func shareLink(for movie: Movie) {
        let items = [movie.trackViewUrl]
        let activityVC = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(activityVC, animated: true)
    }
}
