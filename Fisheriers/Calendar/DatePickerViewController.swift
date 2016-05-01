//
//  DatePickerViewController.swift
//  Fisheriers
//
//  Created by Lost on 21/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//


class DatePickerViewController: BasicViewController {

    override func dateOk()
    {
        if masterViewController.isKindOfClass(LiveTableViewController)
        {
            let vc = masterViewController as! LiveTableViewController
            vc.date = super.dateSelected
        }
    }
}
