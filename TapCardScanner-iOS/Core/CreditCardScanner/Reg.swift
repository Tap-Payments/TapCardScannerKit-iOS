import Foundation

public struct Regex: ExpressibleByStringLiteral {
    private let pattern: String

    private var nsRegularExpression: NSRegularExpression? {
        return try? NSRegularExpression(pattern: pattern)
    }

    public typealias StringLiteralType = String

    public init(stringLiteral value: StringLiteralType) {
        pattern = value
    }

    public init(_ string: String) {
        pattern = string
    }

    public func matches(in string: String) -> [String] {
        let ranges = nsRegularExpression?
            .matches(in: string, options: [], range: searchRange(for: string))
            .compactMap { Range($0.range, in: string) }
            ?? []

        return ranges
            .map { string[$0] }
            .map(String.init)
    }

    public func hasMatch(in string: String) -> Bool {
        return firstMatch(in: string) != nil
    }

    public func firstMatch(in string: String) -> String? {
        guard
            let match = nsRegularExpression?.firstMatch(
                in: string,
                options: [],
                range: searchRange(for: string)
            ),
            let matchRange = Range(match.range, in: string)
        else {
            return nil
        }

        return String(string[matchRange])
    }

    private func searchRange(for string: String) -> NSRange {
        return NSRange(location: 0, length: string.utf16.count)
    }
}

// MARK: Operator related

infix operator =~
infix operator !~

extension Regex {
    public static func =~ (string: String, regex: Regex) -> Bool {
        return regex.hasMatch(in: string)
    }

    public static func =~ (regex: Regex, string: String) -> Bool {
        return regex.hasMatch(in: string)
    }

    public static func !~ (string: String, regex: Regex) -> Bool {
        return !regex.hasMatch(in: string)
    }

    public static func !~ (regex: Regex, string: String) -> Bool {
        return !regex.hasMatch(in: string)
    }
}
