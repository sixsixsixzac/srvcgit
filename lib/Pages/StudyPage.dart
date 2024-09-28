import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/tag.dart';
import 'package:srvc/Models/video.dart';
import 'package:srvc/Pages/_VideoDetail.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:shimmer/shimmer.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  final ApiService apiService = ApiService(serverURL);
  bool showContainer = false;
  List<VideoModel> videoList = [];
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();

    fetch();
  }

  void updateSelectedOptions(List<String> options) {
    setState(() {
      selectedOptions = options;
    });
  }

  Future<void> fetch() async {
    final resp = await getLerning();
    setState(() {
      videoList = (resp['data'] as List).map((video) => VideoModel.fromJson(video as Map<String, dynamic>)).toList();
    });
  }

  Future<Map<String, dynamic>> getLerning() async {
    final response = await apiService.post("/SRVC/StudyController.php", {
      'act': 'getLerning',
    });

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              color: HexColor("#4a54b3"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Center(
                    child: AutoSizeText(
                      "E-Lerning",
                      maxLines: 1,
                      minFontSize: 20,
                      maxFontSize: 26,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: 'thaifont', color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showContainer = !showContainer;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1, color: HexColor("#d5d5d5")),
                        color: Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.filter,
                            size: 14,
                            color: HexColor('#7f8889'),
                          ),
                          const SizedBox(width: 5),
                          AutoSizeText(
                            "เลือกหัวข้อ (${selectedOptions.length})",
                            maxLines: 1,
                            minFontSize: 16,
                            maxFontSize: 20,
                            style: TextStyle(fontFamily: 'thaifont', color: HexColor('#7f8889')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        child: const Row(
                          children: [
                            AutoSizeText(
                              "คอรส์แนะนำ",
                              maxLines: 1,
                              minFontSize: 20,
                              maxFontSize: 24,
                              style: TextStyle(
                                fontFamily: 'thaifont',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 1,
                        child: ListView.builder(
                          itemCount: videoList.length,
                          itemBuilder: (context, index) {
                            final video = videoList[index];
                            return SetCard(
                              video: video,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        if (showContainer)
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * .6,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => setState(() => showContainer = false),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: const Icon(
                                  FontAwesomeIcons.times,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: MultiSelectButton(
                              selected: selectedOptions,
                              onSelectionChanged: updateSelectedOptions,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class MultiSelectButton extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;
  final List<String> selected;
  const MultiSelectButton({super.key, required this.onSelectionChanged, required this.selected});

  @override
  _MultiSelectButtonState createState() => _MultiSelectButtonState();
}

class _MultiSelectButtonState extends State<MultiSelectButton> {
  final ApiService apiService = ApiService(serverURL);
  bool isLoading = true;
  List<Tag> tagList = [];

  @override
  void initState() {
    super.initState();

    fetch("");
  }

  Future<void> fetch(String txt) async {
    setState(() {
      isLoading = true;
    });

    final resp = await fetchTags(txt);
    setState(() {
      tagList = (resp['data'] as List).map((tag) => Tag.fromJson(tag as Map<String, dynamic>)).toList();
      isLoading = false;
    });
  }

  Future<Map<String, dynamic>> fetchTags(String searchTXT) async {
    final response = await apiService.post("/SRVC/StudyController.php", {
      'act': 'getTags',
      'searchTXT': searchTXT,
    });

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.red),
              ),
              hintText: 'ค้นหาแท็ก',
              hintStyle: const TextStyle(fontFamily: 'thaifont'),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(fontFamily: 'thaifont'),
            onChanged: (value) => fetch(value),
          ),
        ),
        (isLoading)
            ? const Center(child: CircularProgressIndicator())
            : (tagList.isEmpty)
                ? const Text(
                    "ไม่พบรายการ",
                    style: TextStyle(
                      fontFamily: 'thaifont',
                    ),
                  )
                : Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    spacing: 10,
                    runSpacing: 10,
                    children: tagList.map((tag) {
                      final bool isSelected = widget.selected.contains(tag.name);
                      return FilterChip(
                        label: Text(
                          tag.name,
                          style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontFamily: 'thaifont'),
                        ),
                        selected: isSelected,
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              widget.selected.add(tag.name);
                            } else {
                              widget.selected.remove(tag.name);
                            }
                            widget.onSelectionChanged(widget.selected);
                          });
                        },
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.grey[100],
                        selectedColor: Colors.blue,
                        checkmarkColor: Colors.white,
                      );
                    }).toList(),
                  ),
      ],
    );
  }
}

class SetCard extends StatelessWidget {
  final VideoModel video;
  const SetCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VideoDetail()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: const BoxDecoration(),
                  child: ThumbnailWidget(
                    thumbnail: video.thumbnail,
                    src: serverImages,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                height: 100,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            video.title,
                            maxLines: 1,
                            minFontSize: 14,
                            maxFontSize: 20,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'thaifont',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AutoSizeText(
                            video.desc ?? "",
                            maxLines: 1,
                            minFontSize: 14,
                            maxFontSize: 20,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: 'thaifont', color: HexColor('#4F4F4F')),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(FontAwesomeIcons.clock, size: 14, color: HexColor('#198754')),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: AutoSizeText(
                            "1 ชั่วโมง",
                            maxLines: 1,
                            minFontSize: 14,
                            maxFontSize: 20,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: 'thaifont', color: HexColor('#198754')),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThumbnailWidget extends StatelessWidget {
  final String src;
  final String thumbnail;

  const ThumbnailWidget({
    Key? key,
    required this.src,
    required this.thumbnail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            Image.network(
              '$src/$thumbnail',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              height: 100,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return _buildShimmerLoading();
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Center(child: Icon(Icons.error));
              },
            ),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ).createShader(bounds);
              },
              blendMode: BlendMode.darken,
              child: Container(color: Colors.transparent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 100,
      ),
    );
  }
}
