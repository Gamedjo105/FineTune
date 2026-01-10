// FineTune/Views/DesignSystem/DesignTokens.swift
import SwiftUI

/// Design System tokens for FineTune UI
/// Centralized values for colors, typography, spacing, dimensions, and animations
enum DesignTokens {

    // MARK: - Colors

    enum Colors {
        // MARK: Background & Surface

        /// Clear background - relies on .ultraThinMaterial
        static let surfaceBackground = Color.clear

        /// Row card background - darker than container
        static let rowCard = Color.white.opacity(0.08)

        /// Row card hover - slightly brighter
        static let rowCardHover = Color.white.opacity(0.12)

        /// Row active/pressed state
        static let rowActive = Color.white.opacity(0.14)

        // MARK: Slider

        /// Slider track background (unfilled)
        static let sliderTrack = Color.white.opacity(0.12)

        /// Slider filled track
        static let sliderFill = Color.white.opacity(0.7)

        /// Slider thumb color
        static let sliderThumb = Color.white

        /// Unity marker on slider
        static let unityMarker = Color.white.opacity(0.4)

        // MARK: VU Meter

        /// VU meter green segments (levels 1-5)
        static let vuGreen = Color(red: 0.20, green: 0.78, blue: 0.40)

        /// VU meter yellow segments (levels 6-7)
        static let vuYellow = Color(red: 0.95, green: 0.75, blue: 0.20)

        /// VU meter orange segment (level 8 warning)
        static let vuOrange = Color(red: 0.95, green: 0.50, blue: 0.20)

        /// VU meter red segment (peak/clip)
        static let vuRed = Color(red: 0.90, green: 0.25, blue: 0.25)

        /// VU meter unlit bar color
        static let vuUnlit = Color.white.opacity(0.08)

        // MARK: Text

        /// Primary text color
        static let textPrimary = Color.primary

        /// Secondary text color
        static let textSecondary = Color.secondary

        /// Tertiary/subtle text color
        static let textTertiary = Color.secondary.opacity(0.6)

        // MARK: Interactive

        /// Default interactive element color
        static let interactiveDefault = Color.white.opacity(0.7)

        /// Hovered interactive element color
        static let interactiveHover = Color.white.opacity(0.9)

        /// Active/pressed interactive element color
        static let interactiveActive = Color.white

        /// Mute button active (muted state)
        static let mutedIndicator = Color.red.opacity(0.85)

        /// Default device indicator
        static let defaultDevice = Color.blue

        // MARK: Picker

        /// Device picker button background
        static let pickerBackground = Color.white.opacity(0.08)

        /// Device picker hover background
        static let pickerHover = Color.white.opacity(0.12)
    }

    // MARK: - Typography

    enum Typography {
        /// Section header text (e.g., "OUTPUT DEVICES")
        static let sectionHeader = Font.system(size: 11, weight: .semibold)

        /// App/device name in rows
        static let rowName = Font.system(size: 13, weight: .regular)

        /// Bold variant for default device name
        static let rowNameBold = Font.system(size: 13, weight: .medium)

        /// Volume percentage display
        static let percentage = Font.system(size: 11, weight: .medium, design: .monospaced)

        /// Small caption text
        static let caption = Font.system(size: 10, weight: .regular)

        /// Device picker text
        static let pickerText = Font.system(size: 11, weight: .regular)
    }

    // MARK: - Spacing

    enum Spacing {
        /// 2pt - Extra extra small
        static let xxs: CGFloat = 2

        /// 4pt - Extra small
        static let xs: CGFloat = 4

        /// 8pt - Small
        static let sm: CGFloat = 8

        /// 12pt - Medium
        static let md: CGFloat = 12

        /// 16pt - Large
        static let lg: CGFloat = 16

        /// 20pt - Extra large
        static let xl: CGFloat = 20

        /// 24pt - Extra extra large
        static let xxl: CGFloat = 24
    }

    // MARK: - Dimensions

    enum Dimensions {
        /// Main popup width
        static let popupWidth: CGFloat = 540

        /// Max height for scrollable content
        static let maxScrollHeight: CGFloat = 400

        /// Corner radius for popup
        static let cornerRadius: CGFloat = 12

        /// Corner radius for buttons/pickers
        static let buttonRadius: CGFloat = 6

        /// App/device icon size
        static let iconSize: CGFloat = 22

        /// Small icon size (in pickers, buttons)
        static let iconSizeSmall: CGFloat = 14

        /// Minimal slider track height
        static let sliderTrackHeight: CGFloat = 4

        /// Slider thumb diameter
        static let sliderThumbSize: CGFloat = 14

        /// Minimum slider width
        static let sliderMinWidth: CGFloat = 120

        /// VU meter total width
        static let vuMeterWidth: CGFloat = 28

        /// VU meter bar height
        static let vuMeterBarHeight: CGFloat = 10

        /// VU meter bar spacing
        static let vuMeterBarSpacing: CGFloat = 2

        /// Number of VU meter bars
        static let vuMeterBarCount: Int = 8

        /// Percentage text width
        static let percentageWidth: CGFloat = 36

        /// Minimum touch/click target
        static let minTouchTarget: CGFloat = 24

        /// Device picker min width
        static let pickerMinWidth: CGFloat = 100
    }

    // MARK: - Animation

    enum Animation {
        /// Standard spring for UI interactions
        static let spring = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.75)

        /// Quick spring for small elements
        static let quick = SwiftUI.Animation.spring(response: 0.2, dampingFraction: 0.8)

        /// Gentle spring for larger movements
        static let gentle = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.7)

        /// Hover transition duration
        static let hover = SwiftUI.Animation.easeOut(duration: 0.15)

        /// VU meter level change animation
        static let vuMeterLevel = SwiftUI.Animation.linear(duration: 0.05)

        /// VU meter peak decay animation
        static let vuMeterDecay = SwiftUI.Animation.easeOut(duration: 0.3)

        /// Slider thumb appear/disappear
        static let thumbReveal = SwiftUI.Animation.easeOut(duration: 0.12)
    }

    // MARK: - Timing

    enum Timing {
        /// VU meter update interval (30fps)
        static let vuMeterUpdateInterval: TimeInterval = 1.0 / 30.0

        /// VU meter peak hold duration before decay
        static let vuMeterPeakHold: TimeInterval = 0.3
    }
}
