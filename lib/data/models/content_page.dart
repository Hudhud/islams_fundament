class ContentPage {
  final String? pageTitle;
  final String? text;
  final String? arabicText;
  final String? translationText;
  final String? imageName;
  final String? audioName;

  const ContentPage({
    this.pageTitle,
    this.text,
    this.arabicText,
    this.translationText,
    this.imageName,
    this.audioName,
  });

  factory ContentPage.fromJson(Map<String, dynamic> json) {
    return ContentPage(
      pageTitle: json['pageTitle'] as String?,
      text: json['text'] as String?,
      arabicText: json['arabicText'] as String?,
      translationText: json['translationText'] as String?,
      imageName: json['imageName'] as String?,
      audioName: json['audioName'] as String?,
    );
  }
}
