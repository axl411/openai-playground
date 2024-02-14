import OpenAI
import Foundation

@main
struct Entry {
  static func main() async throws {
      let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? {
          fatalError()
      }()
      
      let openAI = OpenAI(apiToken: apiKey)

      let query = ChatQuery(
          model: .gpt3_5Turbo,
          messages: [
              Chat(role: .user, content: "Hello World!")
          ]
      )

      let result = try await openAI.chats(query: query)
      print(result.choices[0].message.content!)
  }
}
