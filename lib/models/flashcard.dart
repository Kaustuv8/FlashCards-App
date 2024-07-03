import 'package:uuid/uuid.dart';

class FlashCard{
  FlashCard({
    required this.wordName, 
    required this.wordType, 
    required this.wordMeaning}) : id = const Uuid().v1();
  FlashCard.withId({
    required this.wordName, 
    required this.wordType, 
    required this.wordMeaning,
    required this.id
  });
  String wordName;
  String wordType;
  String wordMeaning;
  String id;
}