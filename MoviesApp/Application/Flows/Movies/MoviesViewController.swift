//
//  MainViewController.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 29.03.2023.
//

import UIKit

// MARK: - MoviesViewControllerProtocol
protocol MoviesViewControllerProtocol: AnyObject {
    func setupUI()
    func reloadData()
    func pushDetailViewController(with movie: Movie)
    func showLoader()
    func hideLoader()
    func createAlert(with message: String)
}

// MARK: - MoviesViewController
final class MoviesViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Public properties
    var presenter: MoviesViewPresenterProtocol!
    
    // MARK: - Private properties
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
}

// MARK: - MoviesViewControllerProtocol implementation
extension MoviesViewController: MoviesViewControllerProtocol {
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(MoviesTableViewCell.self)
        tableView.keyboardDismissMode = .onDrag
        searchBar.delegate = self
        addLoader(activityIndicator: activityIndicator)
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
    
    func showLoader() {
        showLoaderIndicator(activityIndicator: activityIndicator)
    }
    
    func hideLoader() {
        hideLoaderIndicator(activityIndicator: activityIndicator)
    }
    
    func createAlert(with message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.okButtonTitle,
                                                style: .cancel,
                                                handler: nil))
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource implementation
extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.movies.count == 0 {
            self.tableView.setEmptyMessage(Constants.searchMovie)
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
extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = presenter.movies[indexPath.row]
        presenter.cellDidTapped(movie: movie)
    }
}

// MARK: - UISearchBarDelegate implementation
extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchMovie(by: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - MoviesTableViewCellDelegate implementation
extension MoviesViewController: MoviesTableViewCellDelegate {
    func favouriteButtonTapped(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.favouriteButtonTapped(for: indexPath.row)
    }
}
