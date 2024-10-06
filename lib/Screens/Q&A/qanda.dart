import 'package:akshaya_ai/globals.dart';
import 'package:flutter/material.dart';

class QuestionAndAnswer extends StatefulWidget {
  String text;
  QuestionAndAnswer({super.key, required this.text});

  @override
  State<QuestionAndAnswer> createState() => _QuestionAndAnswerState();
}

class _QuestionAndAnswerState extends State<QuestionAndAnswer> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ask Akshaya.ai",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Text',
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              child: Text('Submit'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChatBubble(),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
              "https://pixabay.com/vectors/blank-profile-picture-mystery-man-973460/"),
          radius: 20,
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            "jsdkl;ajf;lksajf;lkesjf l;kfjasdlk;j f;lkjasdlkfj kasjfkl j;klja;kl fjaksljfk;l fjsa;lfj akl;sakl;fjsad fjasl;kjf ;lasjfasjf",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          decoration: BoxDecoration(color: primary),
        )
      ],
    );
  }
}
