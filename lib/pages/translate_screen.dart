import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamus_implementasi/controllers/translation_controller.dart';

class TranslateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TranslationController controller = Get.put(TranslationController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Kamus Lengkap'),
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.isIndonesianFirst.value) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.flag),
                      label: Text('Indonesia'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.swap_horiz, size: 32, color: Colors.purple),
                    onPressed: () {
                      controller.toggleLanguage();
                    },
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.flag),
                      label: Text('Korea'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.flag),
                      label: Text('Korea'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.swap_horiz, size: 32, color: Colors.purple),
                    onPressed: () {
                      controller.toggleLanguage();
                    },
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.flag),
                      label: Text('Indonesia'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ]
              ],
            )),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    controller.isIndonesianFirst.value ? 'Indonesia' : 'Korea',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Obx(() => TextField(
                    controller: controller.controller,
                    decoration: InputDecoration(
                      labelText: controller.isTextEmpty.value ? 'Type the text to translate' : null,
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                  )),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  controller.translate();
                  controller.showListView.value = true; // Show ListView when button is pressed
                },
                child: Text('Translate'),
              ),
            ),
            SizedBox(height: 16),
            Obx(() => controller.showListView.value
                ? Expanded(
                    child: ListView.builder(
                      itemCount: controller.translationResults.length,
                      itemBuilder: (context, index) {
                        final item = controller.translationResults[index];
                        return ListTile(
                          title: Text(item.word),
                          subtitle: Text(item.translation),
                        );
                      },
                    ),
                  )
                : SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
