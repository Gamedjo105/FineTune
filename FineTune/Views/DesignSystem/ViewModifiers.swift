// FineTune/Views/DesignSystem/ViewModifiers.swift
import SwiftUI

// MARK: - Hoverable Row Modifier

struct HoverableRowModifier: ViewModifier {
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius)
                    .fill(isHovered ? DesignTokens.Colors.rowCardHover : DesignTokens.Colors.rowCard)
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius)
                    .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
            )
            .onHover { hovering in
                isHovered = hovering
            }
            .animation(DesignTokens.Animation.hover, value: isHovered)
    }
}

// MARK: - Section Header Style Modifier

struct SectionHeaderStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(DesignTokens.Typography.sectionHeader)
            .foregroundStyle(DesignTokens.Colors.textTertiary)
            .tracking(1.2)
            .textCase(.uppercase)
    }
}

// MARK: - Percentage Text Style Modifier

struct PercentageTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(DesignTokens.Typography.percentage)
            .foregroundStyle(DesignTokens.Colors.textSecondary)
            .frame(width: DesignTokens.Dimensions.percentageWidth, alignment: .trailing)
    }
}

// MARK: - Icon Button Style Modifier

struct IconButtonStyleModifier: ViewModifier {
    let isActive: Bool
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
            .foregroundStyle(
                isActive
                    ? DesignTokens.Colors.mutedIndicator
                    : (isHovered ? DesignTokens.Colors.interactiveHover : DesignTokens.Colors.interactiveDefault)
            )
            .frame(minWidth: DesignTokens.Dimensions.minTouchTarget,
                   minHeight: DesignTokens.Dimensions.minTouchTarget)
            .contentShape(Rectangle())
            .onHover { hovering in
                isHovered = hovering
            }
            .animation(DesignTokens.Animation.hover, value: isHovered)
    }
}

// MARK: - View Extensions

extension View {
    /// Applies hoverable row styling with background highlight on hover
    func hoverableRow() -> some View {
        modifier(HoverableRowModifier())
    }

    /// Applies section header text styling (uppercase, spaced, tertiary color)
    func sectionHeaderStyle() -> some View {
        modifier(SectionHeaderStyleModifier())
    }

    /// Applies percentage display styling (monospace, secondary, fixed width)
    func percentageStyle() -> some View {
        modifier(PercentageTextModifier())
    }

    /// Applies icon button styling with hover state
    func iconButtonStyle(isActive: Bool = false) -> some View {
        modifier(IconButtonStyleModifier(isActive: isActive))
    }
}

// MARK: - Previews

#Preview("Hoverable Row") {
    VStack(spacing: 0) {
        HStack {
            Image(systemName: "music.note")
            Text("Spotify")
            Spacer()
            Text("75%")
        }
        .hoverableRow()

        HStack {
            Image(systemName: "video")
            Text("Zoom")
            Spacer()
            Text("100%")
        }
        .hoverableRow()
    }
    .padding()
    .background(.ultraThinMaterial)
    .environment(\.colorScheme, .dark)
}

#Preview("Section Header") {
    VStack(alignment: .leading, spacing: 16) {
        Text("Output Devices")
            .sectionHeaderStyle()

        Text("Apps")
            .sectionHeaderStyle()
    }
    .padding()
    .background(.ultraThinMaterial)
    .environment(\.colorScheme, .dark)
}

#Preview("Percentage Text") {
    HStack {
        Text("100%").percentageStyle()
        Text("75%").percentageStyle()
        Text("0%").percentageStyle()
    }
    .padding()
    .background(.ultraThinMaterial)
    .environment(\.colorScheme, .dark)
}
