//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController {
    let productID = "com.omarassidi.InspoQuotes.PremiumQuotes"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(QuoteTableViewCell.self, forCellReuseIdentifier: "QuoteCell")
        SKPaymentQueue.default().add(self)
        if isPurchased() {
            showPremiumQuotes()
        }
        
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isPurchased() ? quotesToShow.count : quotesToShow.count + 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as! QuoteTableViewCell
        if indexPath.row >= quotesToShow.count {
            cell.textLabel?.text = "Get more quotes..."
            cell.textLabel?.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.bindCellWithItem(quote: quotesToShow[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= quotesToShow.count {
            buyPremiumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKMutablePayment()
            request.productIdentifier = productID
            SKPaymentQueue.default().add(request)
        } else {
            print("User cannot make payment")
        }
    }
    
    private func showPremiumQuotes() {
        UserDefaults.standard.set(true, forKey: productID)
        navigationItem.setRightBarButton(nil, animated: true)
        quotesToShow.append(contentsOf: premiumQuotes)
    }
    
    private func isPurchased() -> Bool {
        return UserDefaults.standard.bool(forKey: productID)
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension QuoteTableViewController: SKPaymentTransactionObserver {
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Restored")
        showPremiumQuotes()
        tableView.reloadData()
    }
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: any Error) {
        print("Restore completed failed with \(error.localizedDescription)")
        showPremiumQuotes()
        tableView.reloadData()
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transation in transactions {
            switch transation.transactionState {
            case .purchased:
                print("Purchased")
                showPremiumQuotes()
                tableView.reloadData()
                SKPaymentQueue().finishTransaction(transation)
            case .failed:
                if let error = transation.error {
                    print("Failed due to error \(error.localizedDescription)")
                }
                showPremiumQuotes()
                tableView.reloadData()
                SKPaymentQueue().finishTransaction(transation)
            case .restored:
                SKPaymentQueue().finishTransaction(transation)
            case .purchasing:
                print("Purchasing")
            default:
                print("Else \(transation.transactionState)")
                break
            }
        }
    }
    
    
}
