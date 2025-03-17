import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class VocabularyDummyData {
  final String text;
  final String? imgSource;
  final String pronunciationSource;
  final String translationText;
  final String? definitionText;

  VocabularyDummyData({
    required this.text,
    this.imgSource,
    required this.pronunciationSource,
    required this.translationText,
    this.definitionText,
  });
}

class MyVocabulary extends StatefulWidget {
  @override
  _MyVocabularyState createState() => _MyVocabularyState();
}

class _MyVocabularyState extends State<MyVocabulary> {
  List<VocabularyDummyData> vocabularyList = [
    VocabularyDummyData(
      text: "this",
      imgSource:
          "https://sun9-5.userapi.com/impg/PxAXTPquZo6d1H6GSEQ2hk_rfubHsbtlmKhGpw/8-tKj55Meo8.jpg?size=640x480&quality=96&sign=8f2c7e22770760f3c389a870ec98347f&c_uniq_tag=fIo_FUh4tB957nzMojql_4U4bKjDDYIb3eF4w1sXELc&type=album",
      pronunciationSource:
          "https://upload.wikimedia.org/wikipedia/commons/f/f8/En-us-this.ogg",
      translationText: "Isso",
      definitionText: "This indicates nearness",
    ),
    VocabularyDummyData(
      text: "cat",
      imgSource:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/220px-Cat03.jpg",
      pronunciationSource:
          "https://upload.wikimedia.org/wikipedia/commons/1/1e/En-uk-a_cat.ogg",
      translationText: "Gato",
      definitionText: null,
    ),
    VocabularyDummyData(
      text: "dog",
      imgSource:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/YellowLabradorLooking.jpg/220px-YellowLabradorLooking.jpg",
      pronunciationSource:
          "https://upload.wikimedia.org/wikipedia/commons/e/e9/En-us-ne-dog.ogg",
      translationText: "Cachorro",
      definitionText: null,
    ),
  ];

  List<VocabularyDummyData> filteredVocabularyList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredVocabularyList.addAll(vocabularyList);
  }

  void filterVocabulary(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredVocabularyList.clear();
        filteredVocabularyList.addAll(vocabularyList);
      } else {
        filteredVocabularyList =
            vocabularyList
                .where(
                  (item) =>
                      item.text.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onChanged: filterVocabulary,
            decoration: InputDecoration(
              labelText: 'Search Vocabulary',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredVocabularyList.length,
            itemBuilder: (context, index) {
              final vocabulary = filteredVocabularyList[index];
              return VocabularyTile(
                vocabulary: vocabulary,
                onRemove: () {
                  setState(() {
                    vocabularyList.remove(vocabulary);
                    filteredVocabularyList.remove(vocabulary);
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class VocabularyTile extends StatelessWidget {
  final VocabularyDummyData vocabulary;
  final VoidCallback onRemove;
  bool showTranslation = false;

  VocabularyTile({required this.vocabulary, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(vocabulary.text),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () => _playPronunciation(vocabulary.pronunciationSource),
          ),
          if (vocabulary.imgSource != null)
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () => _showImage(context, vocabulary.imgSource!),
            ),
          IconButton(icon: Icon(Icons.close), onPressed: onRemove),
        ],
      ),
      onTap: () {
        _showVocabularyDetails(context, vocabulary);
      },
    );
  }

  Future<void> _playPronunciation(String pronunciationSource) async {
    final player = AudioPlayer();
    await player.play(UrlSource(pronunciationSource));
  }

  void _showImage(BuildContext context, String imgSource) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(vocabulary.text),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                imgSource != null
                    ? Image.network(imgSource)
                    : Icon(Icons.image),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showVocabularyDetails(
    BuildContext context,
    VocabularyDummyData vocabulary,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(vocabulary.text, textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    vocabulary.translationText,
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    vocabulary.definitionText ?? "",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }
}
