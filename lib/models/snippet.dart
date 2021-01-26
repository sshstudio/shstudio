class Snippet {
  String title;
  String command;

  Map<String, dynamic> toJson() => {
    'title': title,
    'command': command,
  };

  Snippet(this.title, this.command);

  factory Snippet.fromJson(Map<String, dynamic> json) {
    return Snippet(json['title'], json['command']);
  }
}