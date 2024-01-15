//
//  ColorSchemeModel.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 21.12.23.
//

import SwiftUI

public class ColorSchemeModel: ObservableObject {
    @AppStorage("selectedColorMode") var mode: String = "Dunkel"
}
