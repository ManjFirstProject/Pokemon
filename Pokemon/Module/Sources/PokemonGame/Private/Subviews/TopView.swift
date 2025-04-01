import SwiftUI
import Designs

struct TopView: View {
    @Binding var optionSelected: Bool
    let score: Int
    let url: URL?
    let name: String?

    var body: some View {
        VStack {
            Text("Score: \(score)")
                .padding(.bottom, 60)
                .font(Typography.title.font)
                .foregroundColor(.yellow)
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .colorMultiply(optionSelected ? .white : .black)
                    .opacity(optionSelected ? 1.0 : 0.9)
            } placeholder: {
                ProgressView()
            }
            Text(optionSelected ? (name ?? "") : "")
                .font(Typography.header.font)
                .foregroundStyle(.yellow)
        }
    }
}
