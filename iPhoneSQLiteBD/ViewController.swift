//
//  ViewController.swift
//  iPhoneSQLiteBD
//
//  Created by Артем on 3/29/19.
//  Copyright © 2019 Артем. All rights reserved.
//

import UIKit
import SQLite3


class ViewController: UIViewController {
    
    var fm = FileManager.default
    var path = ""
    var url: URL?
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //url = getURL(path: path)
        //print(url!)
        
        //db = createDB(url!)
        //print(db!)
        
        //createTable()
        //madeInsert("Nikolay")
        
        sqlite3_close(db)
    }
    
    @IBAction func buttons(_ sender: UIButton) {
//        db = createDB(getURL(path: path))
//        print("hopa")
        getTextFromAlert()
        
    }
    
    
    func getURL(path: String) -> URL {
        var url = URL(fileURLWithPath: "")
        
        do {
            url = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(path)
        } catch {
            print(error.localizedDescription)
        }
        
        return url
    }
    
    
    func createDB(_ getUrl: URL) -> OpaquePointer? {
        var db: OpaquePointer? = nil //объявление пустого указателя на базу данных
        
        if sqlite3_open(getUrl.path, &db) == SQLITE_OK { //создать базу данных
            print("connect done \(getUrl.path)")
            return db
        } else {
            print("error create DB")
            exit(0)
        }
    }
    
    func createTable(){
        
        var table: OpaquePointer? = nil
        let newTable = """
        CREATE TABLE "MyTableFromXCode" (
        "ID"    INTEGER PRIMARY KEY AUTOINCREMENT,
        "Name"    TEXT NOT NULL UNIQUE
        );
"""
        
        if sqlite3_prepare_v2(self.db, newTable, -1, &table, nil) == SQLITE_OK {
            if sqlite3_step(table) == SQLITE_DONE {
                print("new table = \(newTable) cretead")
            } else {
                print("error")
            }
        } else {
            print("tableStateman could not prepare")
        }
        
        sqlite3_finalize(table)
    }
    
    func madeInsert(_ name: String) {
        var insert: OpaquePointer? = nil
        let insertString = """
        INSERT INTO MyTable (name) VALUES ('\(name)');
        """
        
        if sqlite3_prepare_v2(self.db, insertString, -1, &insert, nil) == SQLITE_OK {
            if sqlite3_step(insert) == SQLITE_DONE {
                print("new values = \(insertString) cretead")
            } else {
                print("error")
            }
        } else {
            print("value error")
        }
        sqlite3_finalize(insert)
        
    }
    
    
    func getTextFromAlert() {
        var name = String()
        
        let alert = UIAlertController(title: "Create Data Base", message: "Name", preferredStyle: .alert)
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alert] _ in
            let answer = alert.textFields![0]
            name = answer.text ?? ""
            self.db = self.createDB(self.getURL(path: name + ".db"))
        }
        alert.addAction(submitAction)
        self.present(alert, animated: true)
        
    }
    
    
}

