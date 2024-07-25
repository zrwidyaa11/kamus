import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamus_implementasi/database_helper.dart';

class TranslationController extends GetxController {
  var isOffline = true.obs;
  var isIndonesianFirst = true.obs;
  var isTextEmpty = true.obs;
  var typedText = ''.obs;
  var translationResults = <TranslationItemData>[].obs;
  var showListView = false.obs;

  final TextEditingController controller = TextEditingController();
  final dbHelper = DatabaseHelper.instance;

  @override
  void onInit() {
    super.onInit();
    controller.addListener(() {
      setText(controller.text);
    });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void toggleLanguage() {
    isIndonesianFirst.value = !isIndonesianFirst.value;
    setText(controller.text);
  }

  void setText(String text) {
    isTextEmpty.value = text.isEmpty;
    typedText.value = text;

    var words = text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();

    translationResults.value = words.map((word) {
      String translation = isIndonesianFirst.value 
          ? 'Simulated translation for $word (Indonesian)' 
          : 'Simulated translation for $word (Korean)';
      return TranslationItemData(word: word, translation: translation);
    }).toList();
  }

  void translate() async {
    print("Translating: ${typedText.value}");
    showListView.value = true;

    // Simpan hasil terjemahan ke dalam database
    for (var result in translationResults) {
      await dbHelper.insert({
        DatabaseHelper.columnWord: result.word,
        DatabaseHelper.columnTranslation: result.translation
      });
    }

    // Query data dari database
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }
}

class TranslationItemData {
  final String word;
  final String translation;

  TranslationItemData({required this.word, required this.translation});
}
