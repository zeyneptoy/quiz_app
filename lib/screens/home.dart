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
                        'Yeni soruya geçmeden önde bir seçeneği işaretlemeniz gerekmektedir.'),
                  ));
                  return;
                }
                _nextQuestion();
              },
              child: Text(endOfQuiz ? 'Yeniden Başlat' : 'Sonraki Soru'),
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
                    correctAnswerSelected ? 'Doğru :)' : 'Yanlış :/',
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
                        ? 'Tebrikler! Puanınız: $_totalScore'
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
    'question': "Türkiye'nin başkenti neresidir?",
    'answers': [
      {'answerText': 'Ankara', 'score': true},
      {'answerText': 'Gaziantep', 'score': false},
      {'answerText': 'İstanbul', 'score': false},
    ],
  },
  {
    'question': "İstiklal Marşı'nın yazarı kimdir",
    'answers': [
      {'answerText': 'İsmet İnönü', 'score': false},
      {'answerText': 'Mustafa Kemal Atatürk', 'score': false},
      {'answerText': 'Mehmet Akif Ersoy', 'score': true},
    ],
  },
  {
    'question': "Türkiye'de kaç il bulunmaktadır?",
    'answers': [
      {'answerText': '79', 'score': false},
      {'answerText': '80', 'score': false},
      {'answerText': '81', 'score': true},
    ],
  },
  {
    'question':
        'UEFA kupasını kaldıran Türk Futbol takımı hangi seçenekte verilmiştir?',
    'answers': [
      {'answerText': 'Fenerbahçe', 'score': false},
      {'answerText': 'Galatasaray', 'score': true},
      {'answerText': 'Beşiktaş', 'score': false},
    ],
  },
  {
    'question': 'Türkiyenin en kalabalık ili hangisidir',
    'answers': [
      {'answerText': 'İstanbul', 'score': true},
      {'answerText': 'İzmir', 'score': false},
      {'answerText': 'Ankara', 'score': false},
    ],
  },
  {
    'question': 'Alfabemizde kaç harf vardır?',
    'answers': [
      {'answerText': '29', 'score': true},
      {'answerText': '30', 'score': false},
      {'answerText': '31', 'score': false},
    ],
  },
  {
    'question': "Türkiye'nin kaç bölgesi vardır",
    'answers': [
      {'answerText': '7', 'score': true},
      {'answerText': '6', 'score': false},
      {'answerText': '8', 'score': false},
    ],
  },
  {
    'question': 'Kaç duyu organımız vardır?',
    'answers': [
      {'answerText': '5', 'score': false},
      {'answerText': '6', 'score': false},
      {'answerText': '8', 'score': true},
    ],
  },
  {
    'question': "Gaziantep Türkiye'nin hangi bölgesindedir",
    'answers': [
      {'answerText': 'Akdeniz', 'score': false},
      {'answerText': 'Karadeniz', 'score': false},
      {'answerText': 'Güneydoğu Anadolu', 'score': true},
    ],
  },
];
