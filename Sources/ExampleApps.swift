//
//  File 2.swift
//  
//
//  Created by 顾超 on 2024/02/29.
//

import Foundation
import OpenAI

private func askChatGPT(messages: [Chat], openAI: OpenAI) async throws -> String? {
    let query = ChatQuery(model: .gpt4_turbo_preview, messages: messages)
    let response = try await openAI.chats(query: query)
    return response.choices.first?.message.content
}

enum NewsGenerator {
    static func assistJournalist(
        facts: [String],
        tone: String,
        wordsLength: Int,
        style: String,
        openAI: OpenAI
    ) async throws {
        let promptRole = "You are an assistant for journalists. Your task is to write articles, based on the FACTS that are given to you. You should respect the instruction: the TONE, the LENGTH, and the STYLE."
        let facts = facts.joined(separator: ", ")
        let prompt = """
        \(promptRole)
        FACTS: \(facts)
        TONE: \(tone)
        LENGTH: \(wordsLength) words
        STYLE: \(style)
        """
        guard let result = try await askChatGPT(
            messages: [.init(role: .user, content: prompt)],
            openAI: openAI
        ) else { return }
        print(result)
    }
}

enum VideoSummarizer {
    static func summarize(
        openAI: OpenAI
    ) async throws {
        guard let fileURL = Bundle.module.url(forResource: "video_transcripts", withExtension: "txt") else { return }
        let contents = try String(contentsOf: fileURL)
        guard let result = try await askChatGPT(
            messages: [
                .init(role: .system, content: "You are a helpful assistant"),
                .init(role: .user, content: "Summarize the following text"),
                .init(role: .assistant, content: "Yes."),
                .init(role: .user, content: contents)
            ],
            openAI: openAI
        ) else { return }
        print(result)
    }
}
