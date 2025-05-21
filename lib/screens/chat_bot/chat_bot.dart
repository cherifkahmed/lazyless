import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:lazyless/screens/chat_bot/conv.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final apiKey = 'AIzaSyD2iTmvQZAuJxjGfTKJ0I6qXqNaKn2Ffvc';
  final TextEditingController _userInput = TextEditingController();
  final List<Conv> _messages=[];
  Future<void> talkWithGemini()async{
    final userMsg = _userInput.text;
    setState(() {
      _messages.add(Conv(
        isUser: true,
        message: userMsg, 
        date: DateTime.now()
      ));
    });

    final model = GenerativeModel(
      model: 'gemini-1.5-flash', 
      apiKey: apiKey
    );
    final content = Content.text(userMsg);
    final response = await model.generateContent([content]);
    setState(() {
      _messages.add(Conv(isUser: false, message: response.text??"", date: DateTime.now()));
    });
    
    print('response from gimini ai:${response.text}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How can i help you'),
        centerTitle: true,
        backgroundColor: Color(0xff328E6E),
      ),
      body:Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xff328E6E),Color(0xff67AE6E)])
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context,index){
                  final message = _messages[index];
                  return Convs(isUser: message.isUser, message: message.message, date: DateFormat('HH:mm').format(message.date));
                }
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _userInput,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: Text('Ask me!')
                      ),
                      
                    )
                  ),
                  Spacer(),
                  IconButton(
                    padding: EdgeInsets.all(12),
                    iconSize: 30,
                    onPressed: (){
                      talkWithGemini();
                      _userInput.clear;

                    }, 
                    icon: Icon(Icons.send)
                  )
                ],
              ),
            )
        
          ],
        ),
      )
    );
  }
}