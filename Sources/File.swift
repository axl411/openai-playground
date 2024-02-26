import OpenAI
import Foundation

@main
struct Entry {
    static func main() async throws {
        let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? {
            fatalError()
        }()
        
        let openAI = OpenAI(apiToken: apiKey)
        
//        try await helloWorld(openAI: openAI)
//        try await basic(openAI: openAI)
        try await textCompletionToFunction(openAI: openAI)
    }
    
    private static func helloWorld(openAI: OpenAI) async throws {
        let query = ChatQuery(
            model: .gpt3_5Turbo,
            messages: [
                Chat(role: .user, content: "Hello World!")
            ]
        )
        
        let result = try await openAI.chats(query: query)
        dump(result.choices)
    }
    
    private static func basic(openAI: OpenAI) async throws {
        let query = ChatQuery(
            model: .gpt3_5Turbo,
            messages: [
                Chat(role: .system, content: "You are a helpful teacher."),
                Chat(role: .user, content: "Are there other measures than time complexity for an algorithm?"),
                Chat(role: .assistant, content: "Yes, there are other measures than time complexity for an algorithm, such as space complexity."),
                Chat(role: .user, content: "What is it?"),
            ],
            maxTokens: 1000
        )
        
        let result = try await openAI.chats(query: query)
        dump(result)
    }
    
    private static func textCompletionToFunction(openAI: OpenAI) async throws {
        // example function
        func findProduct(query: String) -> [[String : Any]] {
            // execute query here
            let results = [
                ["name": "pen", "color": "blue", "price": 1.99],
                ["name": "pen", "color": "red", "price": 1.78]
            ]
            return results
        }
        
        let query = ChatQuery(
            model: .gpt3_5Turbo,
            messages: [Chat(role: .user, content: "I need the top 2 products where the price is less than 2.00")],
            functions: [
                .init(
                    name: "find_product",
                    description: "Get a list of pproducts from a sql query",
                    parameters: .init(
                        type: .object,
                        properties: [
                            "sql_query": .init(type: .string, description: "A SQL query")
                        ],
                        required: ["sql_query"]
                    )
                )
            ]
        )

        let result = try await openAI.chats(query: query)
        dump(result.choices.first!.message)
        
        let functionCall = result.choices.first(where: { $0.message.functionCall?.name == "find_product" })!.message.functionCall!
        let json = try JSONSerialization.jsonObject(with: functionCall.arguments!.data(using: .utf8)!) as! [String: Any]
        // sqlQuery == "SELECT * FROM products WHERE price < 2.00 ORDER BY price ASC LIMIT 2"
        let sqlQuery = json["sql_query"] as! String
        let myResult = findProduct(query: sqlQuery)
        print(myResult)
    }
}
