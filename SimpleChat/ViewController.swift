//
//  ViewController.swift
//  SimpleChat
//
//  Created by Khandker  Mahmudur Rahman on 10/9/24.
//

import UIKit
import IQKeyboardManagerSwift

class ViewController: UIViewController {
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    private let user: String = "user1"
    
    private var chatList: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true
//        DispatchQueue.global(qos: .utility).async {
//            self.chatList = self.loadChat(filename: "sample_chat_data") ?? []
//            self.chatList.forEach { chat in
//                print(chat)
//            }
//        }
        tfMessage.iq.toolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        tblChat.delegate = self
        tblChat.dataSource = self
        loadDummyData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    @IBAction func btnSendTap(_ sender: UIButton) {
        sendMessage()
    }
    
    func sendMessage() {
        guard let msg = tfMessage.text else {
            return
        }
        if msg.count > 0 {
            chatList.append(
                Chat(message: msg, user: user, timestamp: Date().timeIntervalSince1970)
            )
            DispatchQueue.main.async {
                self.tblChat.reloadData()
            }
        }
        tfMessage.text = ""
    }
    
    func loadChat(filename fileName: String) -> [Chat]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Chat].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    @objc
    func doneButtonClicked(_ sender: Any) {
        sendMessage()
    }
    
    func loadDummyData() {
        DispatchQueue.global(qos: .utility).async {
            let sampleChats = self.loadChat(filename: "sample_chat_data") ?? []
            
            for chat in sampleChats {
                print(chat)
                self.chatList.append(chat)
                DispatchQueue.main.async {
                    self.tblChat.reloadData()
                }
                sleep(1)
            }
        }
    }

}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chatList.count > 0 {
            let chat = chatList[indexPath.row]
            if chat.user == user {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SendBubbleTableViewCell") as! SendBubbleTableViewCell
                cell.lbMessage.text = chat.message
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveBubbleTableViewCell") as! ReceiveBubbleTableViewCell
                cell.lbMessage.text = chat.message
                return cell
            }
        }
        return UITableViewCell()
    }
    
}

