//
//  FavoriteViewController.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 29.03.2023.
//

import UIKit

// MARK: - FavouriteViewControllerProtocol
protocol FavouriteViewControllerProtocol: AnyObject {
    func setupUI()
    func reloadData()
    func pushDetailViewController(with movie: Movie)
}

// MARK: - FavouriteViewController
final class FavouriteViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Public properties
    var presenter: FavouriteViewPresenterProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getMovies()
    }
}

// MARK: - FavouriteViewControllerProtocol implementation
extension FavouriteViewController: FavouriteViewControllerProtocol {
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(MoviesTableViewCell.self)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func pushDetailViewController(with movie: Movie) {
        let detailViewController = DetailViewController.instantiateFromStoryboard()
        let presenter = DetailViewPresenter(view: detailViewController, movie: movie)
        detailViewController.presenter = presenter
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource implementation
extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.movies.count == 0 {
            self.tableView.setEmptyMessage(Constants.favouriteMovie)
        } else {
            self.tableView.restore()
        }
        return presenter.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(MoviesTableViewCell.self, indexPath: indexPath)
        cell.delegate = self
        
        let movie = presenter.movies[indexPath.row]
        cell.configure(movieName: movie.trackName.notNil,
                       genre: movie.primaryGenreName.notNil,
                       year: DateHelper.convertDate(from: movie.releaseDate.notNil).notNil,
                       imageUrl: movie.artworkUrl100.notNil,
                       isFavourite: MoviesManager.shared.contains(movie))
        return cell
    }
}

// MARK: - UITableViewDelegate implementation
extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = presenter.movies[indexPath.row]
        presenter.cellDidTapped(movie: movie)
    }
}

// MARK: - MoviesTableViewCellDelegate implementation
extension FavouriteViewController: MoviesTableViewCellDelegate {
    func favouriteButtonTapped(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.favouriteButtonTapped(for: indexPath.row)
    }
}
