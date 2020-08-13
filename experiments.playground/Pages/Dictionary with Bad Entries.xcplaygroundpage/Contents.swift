import Foundation

struct Item: Codable {
    let id: String
    let title: String
}

let jsonData = """
{
   "asdf": {
      "id": "asdf",
      "title": "asdf"
   },
   "qwerty":{
      "title": "asdf"
   }
}
""".data(using: .utf8)

print(try? JSONDecoder().decode([String: Item].self, from: jsonData!))
print(try? JSONDecoder().decode([String: Item?].self, from: jsonData!))

struct Corruptible<T: Decodable>: Decodable {
    let value: T?
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try? container.decode(T.self)
    }
}

let items = try JSONDecoder()
    .decode([String: Corruptible<Item>].self, from: jsonData!)
    .compactMapValues { $0.value }
print(items)
