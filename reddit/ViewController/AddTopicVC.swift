//
//  AddTopicVC.swift
//  reddit
//
//  Created by Cheah Bee Kim on 5/5/18.
//  Copyright © 2018 Cheah Bee Kim. All rights reserved.
//

import UIKit

protocol AddTopicVCDelegate: class {
    func addTopicVCDidTapCancel(
        _ viewController: AddTopicVC
    )
    
    func addTopicVC(
        _ viewController: AddTopicVC,
        didAdd topic: Topic
    )
}

class AddTopicVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    //
    weak var delegate: AddTopicVCDelegate?
    let viewModel = AddTopicVCViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupListener()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Setup
    private func setupView() {
        
    }
    
    private func setupNavBar() {
        let itemCancel = UIBarButtonItem(
            title: NSLocalizedString("Cancel", comment: ""),
            style: .done,
            target: self,
            action: #selector(actionCancel)
        )
        
        let itemAdd = UIBarButtonItem(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(actionAdd)
        )
        
        navigationItem.leftBarButtonItem = itemCancel
        navigationItem.rightBarButtonItem = itemAdd
    }
    
    private func setupListener() {
        viewModel.outputs.title.bind { [weak self] in
            self?.navigationItem.title = $0
        }
        
        viewModel.outputs.content.bind { [weak self] in
            self?.textView.text = $0
        }
        
        viewModel.outputs.notifyDelegateDidAdd.bind { [weak self] in
            guard let strongSelf = self else { return }
            
            if let topic = $0 {
                strongSelf.delegate?.addTopicVC(strongSelf, didAdd: topic)
            }
        }
        
        viewModel.outputs.notifyDelegateDidTapCancel.bind { [weak self] in
            guard let strongSelf = self else { return }
            
            if $0 != nil {
                strongSelf.delegate?.addTopicVCDidTapCancel(strongSelf)
            }
        }
        
        viewModel.outputs.error.bind { [weak self] in
            if let error = $0 {
                self?.presentError(error: error)
            }
        }
        
        textView.delegate = self
    }
    
    // MARK: - Action / Listener
    @IBAction func actionCancel() {
        viewModel.inputs.didTapCancel()
    }
    
    @IBAction func actionAdd() {
        viewModel.inputs.didTapAdd()
    }
    
    // MARK: - Navigation
    func presentError(error: Error) {
        viewModel.inputs.didDisplayError()
        
        let alert = UIAlertController(
            title: NSLocalizedString("Error", comment: ""),
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let actionOk = UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .default,
            handler: nil
        )
        
        alert.addAction(actionOk)
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension AddTopicVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.outputs.content.value = textView.text
    }
}
