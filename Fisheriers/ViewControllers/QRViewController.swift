//
//  QRViewController.swift
//  Fisheriers
//
//  Created by ChaonengFeng on 29/4/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit
import QRCode

class QRViewController: UIViewController {
    @IBOutlet weak var qrImage: UIImageView!
    var code = "1234"
    override func viewDidLoad() {
        let qrCode = QRCode(code)
        qrImage.image = qrCode!.image
    }

}
