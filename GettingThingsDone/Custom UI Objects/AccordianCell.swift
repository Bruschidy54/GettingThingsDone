//
//  AccordianCell.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 6/4/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation

class AccordionCell {
    var items = [Item]()
    
    class Item {
        var isHidden: Bool
        // Use a generic to store item on cell
        var project: Project?
        var nextAction: NextAction?
        var unsorted: Bool
        var isChecked: Bool
        
        init(_ hidden: Bool = true, project: Project?, nextAction: NextAction?, unsorted: Bool, checked: Bool = false) {
            self.isHidden = hidden
            self.project = project
            self.nextAction = nextAction
            self.unsorted = unsorted
            self.isChecked = checked
        }
    }
    
    class HeaderProject: Item {
        init(project: Project) {
            super.init(false, project: project, nextAction: nil, unsorted: false, checked: false)
        }
        init() {
            super.init(false, project: nil, nextAction: nil, unsorted: true, checked: false)
        }
    }
    
    class SubNextAction: Item {
        init(nextAction: NextAction) {
            super.init(true, project: nil, nextAction: nextAction, unsorted: false, checked: false)
        }
    }
    
    
    
    
    func append(_ item: Item) {
        self.items.append(item)
    }
    
    func removeAll() {
        self.items.removeAll()
    }
    
    func expand(_ headerIndex: Int) {
        self.toggleVisible(headerIndex, isHidden: false)
    }
    
    func collapse(_ headerIndex: Int) {
        self.toggleVisible(headerIndex, isHidden: true)
    }
    
    private func toggleVisible(_ headerIndex: Int, isHidden: Bool) {
        var headerIndex = headerIndex
        headerIndex += 1
        
        while headerIndex < self.items.count && !(self.items[headerIndex] is HeaderProject) {
            self.items[headerIndex].isHidden = isHidden
            
            headerIndex += 1
        }
    }
}
