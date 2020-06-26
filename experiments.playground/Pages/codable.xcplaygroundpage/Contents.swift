import Foundation

let jsonData = """
{
   "id":"asdf9a09sdf8adsf",
   "type":"incorporated",
   "registered_id":"123-4",
   "name":{
      "why_is_this_nested_in_here":"hello inc."
   },
   "business_number":5,
   "other_data":{
      "owner":"jane",
      "director":"john",
      "url":"https://www.google.ca/"
   }
}
""".data(using: .utf8)

enum ItemType: String, Codable {
    case soleProprietor = "sole_proprietor"
    case incorporated
}

// use this to isolate data without clear contract while maintaining type safety
struct OtherData: Codable {
    private let data: [String: String]
    
    var owner: String? {
        return data["owner"]
    }
    
    init(from decoder: Decoder) throws {
        let dataContainer = try decoder.singleValueContainer()
        self.data = try dataContainer.decode([String: String].self)
    }
}

struct MyItem: Codable {
    let id: String
    let type: ItemType
    let registeredId: String
    let name: String
    let businessNumber: Int?
    let otherData: OtherData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case registeredId = "registered_id"
        case name
        case businessNumber = "business_number"
        case otherData = "other_data"
    }
    
    enum NameKeys: String, CodingKey {
        case nameValue = "why_is_this_nested_in_here"
    }
    
    init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try dataContainer.decode(String.self, forKey: .id)
        self.type = try dataContainer.decode(ItemType.self, forKey: .type)
        self.registeredId = try dataContainer.decode(String.self, forKey: .registeredId)
        
        // flatten strange structures from backend
        let nameDataContainer = try dataContainer.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        self.name = try nameDataContainer.decode(String.self, forKey: .nameValue)
        
        self.businessNumber = try dataContainer.decodeIfPresent(Int.self, forKey: .businessNumber)
        self.otherData = try dataContainer.decodeIfPresent(OtherData.self, forKey: .otherData)
    }
}

let myItem = try JSONDecoder().decode(MyItem.self, from: jsonData!)
print(myItem.id)
print(myItem.type)
print(myItem.registeredId)
print(myItem.name)
print(myItem.businessNumber as Any)
print(myItem.otherData?.owner as Any)

