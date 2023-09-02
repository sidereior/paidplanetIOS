
import SwiftUI

struct GlowModifier: ViewModifier {
    var radius: CGFloat = 10.0
    var color: Color = .green
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: radius)
            .overlay(
                content
                    .foregroundColor(color)
                    .blur(radius: radius)
            )
            .mask(content)
    }
}

extension View {
    func glowEffect(radius: CGFloat = 10.0, color: Color = .green) -> some View {
        self.modifier(GlowModifier(radius: radius, color: color))
    }
}
