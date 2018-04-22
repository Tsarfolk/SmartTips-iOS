import Foundation

private var contacts: [String] = ["+803123821", "Koszhemarina street, 89", "fax: bla bla bla"]

final class Contact {
    var name: String = ""
}

extension Contact: SampleDataProvider {
    static var sampleData: Contact {
        let contact = Contact()
        contact.name = contacts[sampleDataProviderCounter % contacts.count]
        return contact
    }
}
