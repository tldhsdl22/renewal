//
//  Protocol.swift
//  GGBB_re
//
//  Created by 송시온 on 16/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import Foundation

protocol Terms1Delegate {
    func agreeTerms1(data: String)
}


protocol Terms2Delegate {
    func agreeTerms2(data: String)
}

protocol SegueProtocol {
    func compete()
}
