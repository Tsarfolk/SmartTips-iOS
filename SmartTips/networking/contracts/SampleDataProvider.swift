import Foundation
// for generating diverse data
var sampleDataProviderCounter: Int = 0

protocol SampleDataProvider {
    static var sampleData: Self { get }
}
