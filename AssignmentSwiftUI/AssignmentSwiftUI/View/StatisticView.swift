//
//  StatisticView.swift
//  AssignmentSwiftUI
//
//  Created by Satish Rajpurohit on 19/12/24.
//

import SwiftUI

// MARK: - StatisticView
/// A view to display statistics related to visible cat breeds, like the total count and most frequent characters.
struct StatisticView: View {
    @Binding var visibleBreeds: [CatBreed]
    @StateObject private var statisticViewModel = StatisticViewModel()
    var body: some View {
        Text("Total Visible Items: \(visibleBreeds.count)")
        let topThreeFrequentCharacters = statisticViewModel.getTop3FrequentCharacters(visibleBreeds: visibleBreeds)
        ForEach(topThreeFrequentCharacters, id: \.0) { char, count in
            Text("\(char): \(count)")
                .font(.headline)
        }
    }
}
