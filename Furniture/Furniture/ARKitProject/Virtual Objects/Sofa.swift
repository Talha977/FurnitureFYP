//
//  Sofa.swift
//  ARKitProject
//
//  Created by Danyal on 25/02/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class Sofa: VirtualObject {

    override init() {
        super.init(modelName: "sofa", fileExtension: "scn", thumbImageFilename: "cup", title: "Sofa")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
