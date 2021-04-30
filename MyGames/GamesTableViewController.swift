//
//  GamesTableViewController.swift
//  MyGames
//
//  Created by Beatriz Castro on 27/04/21.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {
    
    var fetchedResultController:NSFetchedResultsController<Game>!
    var label = UILabel()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Você não tem jogos cadastrados"
        label.textAlignment = .center
        
        loadGames()
    }
    
    func loadGames(){
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
             
        // definindo criterio da ordenacao de como os dados serao entregues
        let gameTitleSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [gameTitleSortDescriptor]
             
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
             
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let count = fetchedResultController?.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {
          return cell
        }
             
        cell.prepare(with: game)
        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "gameSegue" {
            let vc = segue.destination as! GameViewController

            if let games = fetchedResultController.fetchedObjects {
                vc.game = games[tableView.indexPathForSelectedRow!.row]
            }

        }
    }

}

extension GamesTableViewController: NSFetchedResultsControllerDelegate {
 
    // sempre que algum objeto for modificado esse metodo sera notificado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
     
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    // Delete the row from the data source
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            default:
                tableView.reloadData()
        }
    }
}
