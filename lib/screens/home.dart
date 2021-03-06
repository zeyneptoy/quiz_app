import 'package:flutter/material.dart';
import 'package:quiz_application/screens/answer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;

  void _questionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      // adding to the score tracker on top
      _scoreTracker.add(
        answerScore
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : Icon(
                Icons.clear,
                color: Colors.red,
              ),
      );
      //when the quiz ends
      if (_questionIndex + 1 == _questions.length) {
        endOfQuiz = true;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    // what happens at the end of the quiz
    if (_questionIndex >= _questions.length) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quizy App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                if (_scoreTracker.length == 0)
                  SizedBox(
                    height: 25.0,
                  ),
                if (_scoreTracker.length > 0) ..._scoreTracker
              ],
            ),
            Container(
              width: double.infinity,
              height: 130.0,
              margin: EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  _questions[_questionIndex]['question'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...(_questions[_questionIndex]['answers']
                    as List<Map<String, Object>>)
                .map(
              (answer) => Answer(
                answerText: answer['answerText'],
                answerColor: answerWasSelected
                    ? answer['score']
                        ? Colors.green
                        : Colors.red
                    : null,
                answerTap: () {
                  // if answer was already selected then nothing happens onTap
                  if (answerWasSelected) {
                    return;
                  }
                  //answer is being selected
                  _questionAnswered(answer['score']);
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
              ),
              onPressed: () {
                if (!answerWasSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Yeni soruya ge??meden ??nde bir se??ene??i i??aretlemeniz gerekmektedir.'),
                  ));
                  return;
                }
                _nextQuestion();
              },
              child: Text(endOfQuiz ? 'Yeniden Ba??lat' : 'Sonraki Soru'),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                '${_totalScore.toString()}/${_questions.length}',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ),
            if (answerWasSelected && !endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: correctAnswerSelected ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    correctAnswerSelected ? 'Do??ru :)' : 'Yanl???? :/',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Text(
                    _totalScore > 4
                        ? 'Tebrikler! Puan??n??z: $_totalScore'
                        : 'YFinal sonucunuz: $_totalScore',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: _totalScore > 4 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final _questions = const [
  {
    'question': "T??rkiye'nin ba??kenti neresidir?",
    'answers': [
      {'answerText': 'Ankara', 'score': true},
      {'answerText': 'Gaziantep', 'score': false},
      {'answerText': '??stanbul', 'score': false},
    ],
  },
  {
    'question': "??stiklal Mar????'n??n yazar?? kimdir",
    'answers': [
      {'answerText': '??smet ??n??n??', 'score': false},
      {'answerText': 'Mustafa Kemal Atat??rk', 'score': false},
      {'answerText': 'Mehmet Akif Ersoy', 'score': true},
    ],
  },
  {
    'question': "T??rkiye'de ka?? il bulunmaktad??r?",
    'answers': [
      {'answerText': '79', 'score': false},
      {'answerText': '80', 'score': false},
      {'answerText': '81', 'score': true},
    ],
  },
  {
    'question':
        'UEFA kupas??n?? kald??ran T??rk Futbol tak??m?? hangi se??enekte verilmi??tir?',
    'answers': [
      {'answerText': 'Fenerbah??e', 'score': false},
      {'answerText': 'Galatasaray', 'score': true},
      {'answerText': 'Be??ikta??', 'score': false},
    ],
  },
  {
    'question': 'T??rkiyenin en kalabal??k ili hangisidir',
    'answers': [
      {'answerText': '??stanbul', 'score': true},
      {'answerText': '??zmir', 'score': false},
      {'answerText': 'Ankara', 'score': false},
    ],
  },
  {
    'question': 'Alfabemizde ka?? harf vard??r?',
    'answers': [
      {'answerText': '29', 'score': true},
      {'answerText': '30', 'score': false},
      {'answerText': '31', 'score': false},
    ],
  },
  {
    'question': "T??rkiye'nin ka?? b??lgesi vard??r",
    'answers': [
      {'answerText': '7', 'score': true},
      {'answerText': '6', 'score': false},
      {'answerText': '8', 'score': false},
    ],
  },
  {
    'question': 'Ka?? duyu organ??m??z vard??r?',
    'answers': [
      {'answerText': '5', 'score': false},
      {'answerText': '6', 'score': false},
      {'answerText': '8', 'score': true},
    ],
  },
  {
    'question': "Gaziantep T??rkiye'nin hangi b??lgesindedir",
    'answers': [
      {'answerText': 'Akdeniz', 'score': false},
      {'answerText': 'Karadeniz', 'score': false},
      {'answerText': 'G??neydo??u Anadolu', 'score': true},
    ],
  },
];
