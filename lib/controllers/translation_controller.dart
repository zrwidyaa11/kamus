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

  void setText(String text) async {
    isTextEmpty.value = text.isEmpty;
    typedText.value = text;

    // Pisahkan kata berdasarkan spasi dan hapus kata kosong
    var words =
        text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();

    // Ambil semua baris dari database
    final allRows = await dbHelper.queryAllRows();

    // Peta kata ke terjemahan dari database
    var translationResults = <TranslationItemData>[];

    for (var word in words) {
      var matchingRow = allRows.firstWhere(
          (row) => row[DatabaseHelper.columnTransliteration] == word,
          orElse: () => <String, dynamic>{});

      String translatedWord = matchingRow.isNotEmpty
          ? (matchingRow[DatabaseHelper.columnWord] ?? '')
          : 'No translation found';
      String translation = matchingRow.isNotEmpty
          ? (matchingRow[DatabaseHelper.columnTranslation] ?? '')
          : 'No translation found';

      translationResults.add(TranslationItemData(
          word: word, translation: '$translatedWord, $translation'));
    }

    this.translationResults.value = translationResults;
  }

  void translate() async {
    print("Translating: ${typedText.value}");
    showListView.value = true;

    try {
      // Simpan hasil terjemahan ke dalam database
      for (var result in translationResults) {
        await dbHelper.insert({
          DatabaseHelper.columnWord: result.word,
          DatabaseHelper.columnTranslation: result.translation
        });
      }

      // Query data dari database
      final allRows = await dbHelper.queryAllRows();
      print('Database rows: $allRows'); // Tambahkan ini

      // Update translationResults dari database jika diperlukan
      var words = typedText.value
          .split(RegExp(r'\s+'))
          .where((word) => word.isNotEmpty)
          .toList();
      translationResults.value = words.map((word) {
        var matchingRow = allRows.firstWhere(
            (row) => row[DatabaseHelper.columnWord] == word,
            orElse: () => <String,
                dynamic>{} // Mengembalikan map kosong jika tidak ditemukan
            );

        String translation = matchingRow.isNotEmpty
            ? matchingRow[DatabaseHelper.columnTranslation] ??
                'No translation found'
            : 'No translation found';

        print('Word: $word, Translation: $translation'); // Tambahkan ini

        return TranslationItemData(word: word, translation: translation);
      }).toList();
    } catch (e) {
      print("Error during translation: $e");
    }
  }
}

class TranslationItemData {
  final String word;
  final String translation;

  TranslationItemData({required this.word, required this.translation});
}
