//
//  ContentView.swift
//  Education
//
//  Created by Артем Хлопцев on 25.07.2021.
//

import SwiftUI
struct Header: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).foregroundColor(Color.init(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))).edgesIgnoringSafeArea(.top).frame(width: 420, height: 100)
            Text("Configuration").foregroundColor(Color.init(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).font(.largeTitle).fontWeight(.medium).padding(.bottom, 14)
        }
    }
}
struct MultiplitcationTablePicker: View {
    @State var multiplicationT: Int
    var body: some View {
        HStack {
            ForEach(0..<11) {num in
                Button(action: {
                    self.multiplicationT = num
                }) {
                    Text("\(num)")
                }.frame(width: 29.7, height: 36).background(num == multiplicationT ? Color.init(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)) :Color.init(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                .cornerRadius(10).foregroundColor(.white).animation(.linear.delay(-0.15))
            }
        }.padding(.bottom,5)
    }
}
struct TextHeadlines: View {
    var text: String
    var body: some View {
        Text(text).font(.headline).fontWeight(.heavy).padding(.bottom,12).foregroundColor(.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))).padding(.top,15)
    }
}

struct HeadLineModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.title2).foregroundColor(.white).frame(width: 300, height: 70).background(Capsule().foregroundColor(.yellow)).padding(.bottom,40).padding(.top, 20)
    }
}
extension View {
    func headlineModifier() -> some View {
        self.modifier(HeadLineModifier())
    }
}

struct GameButtonsView: View {
    var multiplicate: Int
    var arrOfAnimals: [String]
    var number: Int
    var wrongOrRight: Bool
    var current: Bool
    var body: some View {
        ZStack {
            Capsule().fill(wrongOrRight && current ? Color.green : Color.init(#colorLiteral(red: 0.9633480906, green: 0.9633480906, blue: 0.9633480906, alpha: 1))).shadow(radius: 5).overlay(Capsule().stroke(Color.gray, lineWidth: 1)).frame(width: 250, height: 90).padding(.all, 5).animation(.easeInOut)
            HStack(spacing: 60) {
                Image(arrOfAnimals[number]).resizable().aspectRatio(contentMode: .fit).frame(width: 70, height: 70)
                Text("\(multiplicate)").foregroundColor(Color.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))).fontWeight(.medium).font(.title2)
                
            }
        }
    }
}
struct Question {
    var text: String
    var answer: Int
}



struct ContentView: View {
    @State private var gameStarted = false
    @State private var multiplicationTable = 1
    @State private var questionAmount = 0
    @State private var currentQuestion = Int.random(in: 0..<4)
    let arrayOfCountQuestions = ["5","10","20"]
    let arrayOfAnimals = ["bear","buffalo","chick","chicken", "cow","crocodile","dog","duck","elephant","frog","giraffe","goat","gorilla","hippo","horse","monkey","moose2","narwhal","owl","panda","parrot","penguin","pig","rabbit","rhino","sloth","snake","walrus","whale","zebra"].shuffled()
    @State private var questionsText = [Question]()
    @State private var score = 0
    @State private var gameEnd = false
    @State private var questionCount = 0
    @State private var wrongAnswer = false
    var body: some View {
        Group {
            if !gameStarted {
                ZStack {
                    
                    Image(arrayOfAnimals.randomElement()!).rotationEffect(.degrees(10)).offset(x: -150, y: 380.0).animation(.easeInOut)
                    Image(arrayOfAnimals.randomElement()!).rotationEffect(.degrees(-60)).offset(x: 174, y: 180.0).animation(.easeInOut)
                    VStack(spacing: 10) {
                        // header
                        Header()
                        //first picker
                        Spacer()
                        TextHeadlines(text: "Choose the multiplication column: ")
                        
                        HStack {
                            ForEach(0..<11) {num in
                                Button(action: {
                                    self.multiplicationTable = num
                                }) {
                                    Text("\(num)")
                                }.frame(width: 29.7, height: 36).background(num == multiplicationTable ? Color.init(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)) :Color.init(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                                .cornerRadius(10).foregroundColor(.white).animation(.linear.delay(-0.15))
                            }
                        }.padding(.bottom,5)
                        Divider().frame(height: 0.5).background(Color.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                        //second picker
                        TextHeadlines(text: "Choose the number of questions: ")
                        
                        Picker(selection: $questionAmount, label: Text("Picker"), content: {
                            ForEach(0..<arrayOfCountQuestions.count) {
                                Text("\(arrayOfCountQuestions[$0])")
                                
                            }
                        }).pickerStyle(SegmentedPickerStyle()).padding()
                        
                        Spacer()
                        Button("Start") {
                            self.StartGame()
                        }.padding().background(Color.init(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)))
                        .clipShape(Capsule()).foregroundColor(.white).animation(.default)
                        
                        Spacer(minLength: 300)
                    }
                    
                }
            } else {
                
                VStack {
                    
                    Text("\(questionsText[currentQuestion].text)").fontWeight(.heavy).headlineModifier()
                    ForEach(0..<4) {num in
                        Button(action: {
                            withAnimation {
                                self.pressButtonOfAnswer(num)
                                self.nextGame()
                            }
                        }) {
                            GameButtonsView(multiplicate: questionsText[num].answer, arrOfAnimals: arrayOfAnimals, number: num, wrongOrRight: wrongAnswer, current: questionsText[num].answer == questionsText[currentQuestion].answer)
                        }.alert(isPresented: $wrongAnswer, content: {
                            Alert(title: Text("Whoops..."), message: Text("the answer is \(questionsText[currentQuestion].answer)"), dismissButton: .default(Text("Continue")) {
                                self.nextGame()
                                self.wrongAnswer = false
                            })
                        }).animation(.easeIn)
                    }
                    Text("\(score)").font(.largeTitle)
                    Text("\(questionCount) / \(arrayOfCountQuestions[questionAmount])")
                    ZStack {
                        RoundedRectangle(cornerRadius: 12).foregroundColor(Color.init(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))).edgesIgnoringSafeArea(.bottom)
                        Button(action: {
                            self.gameEnd = true
                        }) {
                            Text("End Game").fontWeight(.heavy).font(.title3).foregroundColor(.white)
                        }.alert(isPresented: $gameEnd, content: {
                                    Alert(title: Text("Good Job!"), message: Text("your score is \(score)"), dismissButton: .default(Text("OK")) {
                                        self.gameStarted = false
                                    })}).padding().overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.init(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), lineWidth: 1))
                        
                    }
                }
            }
        }    }
    func newQuestions() {
        for j in 1...10 {
            let newQuest = Question(text: "How much is \(multiplicationTable) * \(j)", answer: multiplicationTable * j)
            questionsText.append(newQuest)
        }
    }
    func StartGame() {
        self.newQuestions()
        self.gameStarted.toggle()
        self.score = 0
        self.questionCount = 0
    }
    func pressButtonOfAnswer(_ number: Int) {
        if questionsText[number].answer == questionsText[currentQuestion].answer {
            self.score += 1
            self.questionCount += 1
        } else {
            self.wrongAnswer = true
            self.score -= 1
            self.questionCount += 1
        }
        if let quest = Int(arrayOfCountQuestions[questionAmount]) {
            if questionCount >= quest {
                wrongAnswer = false
                gameEnd = true
            }
        }
    }
    func nextGame() {
        self.questionsText.shuffle()
        
        self.currentQuestion = Int.random(in: 0..<4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}
