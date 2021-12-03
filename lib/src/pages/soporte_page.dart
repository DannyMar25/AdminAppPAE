// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
//import 'package:url_launcher/url_launcher.dart';
//For creating the SMTP Server

class SoportePage extends StatefulWidget {
  @override
  State<SoportePage> createState() => _SoportePageState();
}

class _SoportePageState extends State<SoportePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          onPressed: () {
            _enviarEmail();
          },
          child: new Text('Send mail'),
        ),
      ),
    );
  }

  // _launchURL(String toMailId, String subject, String body) async {
  //   var url = 'mailto:$toMailId?subject=$subject&body=$body';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  // ios specification
  // final String subject = "Subject:";
  // final String stringText = "Same Message:";
  // String uri =
  //     'mailto:dannymar0497@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
  // if (await canLaunch(uri)) {
  //   await launch(uri);
  // } else {
  //   print("No email client found");
  // }

  _enviarEmail() async {
    String username = 'dannymar0497@gmail.com'; //Your Email;
    String password = 'DannySZ1998'; //Your Email's password;

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      ..recipients.add('danny250393@gmail.com') //recipent email
      ..ccRecipients.addAll(['dannymar0497@gmail.com']) //cc Recipents emails
      //..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
      ..subject =
          'Test Dart Mailer library :: 😀 :: ${DateTime.now()}' //subject of the email
      ..text =
          'This is the plain text.\nThis is line 2 of the text part.'; //body of the email

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n' +
          e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }
}
