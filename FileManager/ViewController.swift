//
//  ViewController.swift
//  FileManager
//
//  Created by Александр Рахимов on 05.05.2024.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    
    let viewModel = ViewModel()
    let imageView = UIImageView()
    let buttonSave = UIButton()
    let buttonRead = UIButton()
    var anyCancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        subscription()
        setImageView()
        setButtonSave()
        setButtonRead()
        viewModel.loadData()
    }
    
    private func subscription() {
        anyCancellable = viewModel.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] data in
                guard let self,
                      let data = self.viewModel.data else { return }
                self.imageView.image = UIImage(data: data)
            })
    }


    private func setImageView() {
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.center = self.view.center
        self.view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setButtonSave() {
        buttonSave.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        buttonSave.center.x = self.view.center.x
        buttonSave.center.y = self.view.bounds.maxY - 150
        self.view.addSubview(buttonSave)
        buttonSave.backgroundColor = .black
        
        let action = UIAction { [weak self] _ in
            self?.viewModel.save()
            self?.imageView.image = nil
        }
        buttonSave.addAction(action, for: .touchUpInside)
    }
    
    private func setButtonRead() {
        buttonRead.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        buttonRead.center.x = self.view.center.x
        buttonRead.center.y = self.view.bounds.maxY - 50
        self.view.addSubview(buttonRead)
        buttonRead.backgroundColor = .cyan
        
        let action = UIAction { [weak self] _ in
            self?.viewModel.read()
        }
        buttonRead.addAction(action, for: .touchUpInside)
    }
}


