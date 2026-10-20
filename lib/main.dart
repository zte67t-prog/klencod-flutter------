import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'آلة حاسبة علمية - محمد بلال',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = ""; // التعبير الرياضي الكامل (مثل 1+1×3)
  String _output = "0";    // الناتج الظاهر على الشاشة

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
  }

  // تحديد التحية بناءً على الوقت
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'صباح الخير';
    } else if (hour >= 12 && hour < 17) {
      return 'طاب يومك';
    } else {
      return 'مساء الخير';
    }
  }

  // نافذة الترحيب
  void _showWelcomeDialog() {
    String greeting = _getGreeting();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Text(
            '$greeting!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          content: Text(
            'محمد بلال يرحب بك في تطبيق الآلة الحاسبة المتقدمة! استمتع بالتجربة.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                child: Text('ابدأ الاستخدام', style: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
  }

  // معالجة الضغط على الأزرار
  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _expression = "";
        _output = "0";
      } else if (buttonText == "⌫") {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
        if (_expression.isEmpty) {
          _output = "0";
        }
      } else if (buttonText == "=") {
        try {
          double result = _evaluateMathExpression(_expression);
          // إزالة الصفر العشري الزائد إن وجد
          String resStr = result.toString();
          if (resStr.endsWith(".0")) {
            resStr = resStr.substring(0, resStr.length - 2);
          }
          _output = resStr;
        } catch (e) {
          _output = "خطأ رياضي";
        }
      } else {
        if (_expression == "0" && buttonText != ".") {
          _expression = buttonText;
        } else {
          // إضافة الدوال العلمية بشكل صحيح
          if (buttonText == "sin" || buttonText == "cos" || buttonText == "tan" || buttonText == "√") {
            _expression += "$buttonText(";
          } else {
            _expression += buttonText;
          }
        }
      }
    });
  }

  // دالة تقييم التعبيرات الرياضية مع أولوية العمليات
  double _evaluateMathExpression(String expr) {
    expr = expr.replaceAll('×', '*').replaceAll('÷', '/').replaceAll(' ', '');
    var parser = _SimpleParser(expr);
    return parser.parseExpression();
  }

  // تصميم الزر
  Widget _buildButton(String buttonText, Color color, Color textColor, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.all(3.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textColor),
          ),
          onPressed: () => _buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('آلة حاسبة علمية - محمد بلال'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          // شاشة عرض التعبير والنتيجة
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression.isEmpty ? "0" : _expression,
                  style: TextStyle(fontSize: 24.0, color: Colors.grey[600]),
                ),
                SizedBox(height: 10),
                Text(
                  _output,
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          Expanded(child: Divider()),
          // لوحة الأزرار العلمية
          Column(children: [
            Row(children: [
              _buildButton("C", Colors.redAccent, Colors.white),
              _buildButton("⌫", Colors.amber[800]!, Colors.white),
              _buildButton("(", Colors.grey[400]!, Colors.black),
              _buildButton(")", Colors.grey[400]!, Colors.black),
            ]),
            Row(children: [
              _buildButton("sin", Colors.blueGrey, Colors.white),
              _buildButton("cos", Colors.blueGrey, Colors.white),
              _buildButton("tan", Colors.blueGrey, Colors.white),
              _buildButton("÷", Colors.orange, Colors.white),
            ]),
            Row(children: [
              _buildButton("√", Colors.blueGrey, Colors.white),
              _buildButton("7", Colors.grey[200]!, Colors.black),
              _buildButton("8", Colors.grey[200]!, Colors.black),
              _buildButton("9", Colors.grey[200]!, Colors.black),
              _buildButton("×", Colors.orange, Colors.white),
            ]),
            Row(children: [
              _buildButton("4", Colors.grey[200]!, Colors.black),
              _buildButton("5", Colors.grey[200]!, Colors.black),
              _buildButton("6", Colors.grey[200]!, Colors.black),
              _buildButton("-", Colors.orange, Colors.white),
            ]),
            Row(children: [
              _buildButton("1", Colors.grey[200]!, Colors.black),
              _buildButton("2", Colors.grey[200]!, Colors.black),
              _buildButton("3", Colors.grey[200]!, Colors.black),
              _buildButton("+", Colors.orange, Colors.white),
            ]),
            Row(children: [
              _buildButton("0", Colors.grey[200]!, Colors.black, flex: 2),
              _buildButton(".", Colors.grey[200]!, Colors.black),
              _buildButton("=", Colors.green, Colors.white),
            ]),
          ])
        ],
      ),
    );
  }
}

// محلل العمليات الحسابية والرياضية
class _SimpleParser {
  String s;
  int i = 0;
  _SimpleParser(this.s);

  bool get isEnd => i >= s.length;
  String get peek => isEnd ? '' : s[i];

  String getChar() {
    if (isEnd) return '';
    return s[i++];
  }

  double parseExpression() {
    double v = parseTerm();
    while (!isEnd) {
      String c = peek;
      if (c == '+' || c == '-') {
        getChar();
        double v2 = parseTerm();
        if (c == '+') v += v2;
        else v -= v2;
      } else {
        break;
      }
    }
    return v;
  }

  double parseTerm() {
    double v = parseFactor();
    while (!isEnd) {
      String c = peek;
      if (c == '*' || c == '/') {
        getChar();
        double v2 = parseFactor();
        if (c == '*') v *= v2;
        else {
          if (v2 == 0) throw Exception("قسمة على صفر");
          v /= v2;
        }
      } else {
        break;
      }
    }
    return v;
  }

  double parseFactor() {
    if (peek == '-') {
      getChar();
      return -parseFactor();
    }
    if (peek == '(') {
      getChar();
      double v = parseExpression();
      if (peek == ')') getChar();
      return v;
    }
    int start = i;
    if (isLetter(peek) || peek == '√') {
      while (!isEnd && (isLetter(peek) || peek == '√')) {
        getChar();
      }
      String fn = s.substring(start, i);
      double val = parseFactor();
      if (fn == 'sin') return sin(val * pi / 180);
      if (fn == 'cos') return cos(val * pi / 180);
      if (fn == 'tan') return tan(val * pi / 180);
      if (fn == '√' || fn == 'sqrt') return sqrt(val);
      return val;
    } else {
      while (!isEnd && (isDigit(peek) || peek == '.')) {
        getChar();
      }
      if (start == i) throw Exception("خطأ");
      return double.parse(s.substring(start, i));
    }
  }

  bool isLetter(String c) {
    if (c.isEmpty) return false;
    int code = c.codeUnitAt(0);
    return (code >= 97 && code <= 122) || (code >= 65 && code <= 90);
  }

  bool isDigit(String c) {
    if (c.isEmpty) return false;
    int code = c.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }
}
