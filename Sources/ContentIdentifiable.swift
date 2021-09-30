/// Represents the value that identified for differentiate.
public protocol ContentIdentifiable {
    /// A type representing the identifier.
    associatedtype DifferenceIdentifier: Hashable

    /// An identifier value for difference calculation.
    var differenceIdentifier: DifferenceIdentifier { get }
}

public extension ContentIdentifiable where Self: Hashable {
    /// The `hashValue` as an identifable identifier
    @inlinable
    var differenceIdentifier: Int {
        return hashValue
    }
}
