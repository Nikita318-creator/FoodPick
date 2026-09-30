import Foundation

final class QuizViewModel {

    let topic: QuizTopic
    private(set) var questions: [QuizQuestion]
    private(set) var currentIndex = 0
    private(set) var correctCount = 0

    /// Вопросы всегда берутся рандомом из общего массива, независимо от выбранного теста.
    /// В одном тесте 10–15 вопросов, варианты ответов тоже перемешиваются.
    init(topic: QuizTopic, bank: [QuizQuestion] = QuestionBank.all) {
        self.topic = topic
        let count = min(Int.random(in: 10...15), bank.count)
        self.questions = bank.shuffled().prefix(count).map { question in
            let correctText = question.options[question.correctAnswerIndex]
            let shuffled = question.options.shuffled()
            return QuizQuestion(
                text: question.text,
                options: shuffled,
                correctAnswerIndex: shuffled.firstIndex(of: correctText) ?? 0
            )
        }
    }

    var total: Int { questions.count }
    var current: QuizQuestion { questions[currentIndex] }
    var isLast: Bool { currentIndex >= total - 1 }

    /// Возвращает true, если ответ верный.
    @discardableResult
    func submit(answer index: Int) -> Bool {
        let isCorrect = index == current.correctAnswerIndex
        if isCorrect { correctCount += 1 }
        return isCorrect
    }

    func advance() {
        if !isLast { currentIndex += 1 }
    }

    /// Сохраняет результат в UserDefaults и возвращает его.
    @discardableResult
    func finishAndSave() -> QuizResult {
        let result = QuizResult(topicId: topic.id,
                                topicTitle: topic.title,
                                correct: correctCount,
                                total: total,
                                date: Date())
        ResultsStore.shared.save(result)
        return result
    }
}
