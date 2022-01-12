class Band {
  String id;
  String name;
  int? votes;

  Band({required this.id, required this.name, this.votes});

  // Factory constructor devuelve una nueva instacina de la clase
  factory Band.fromMap(Map<String, dynamic> obj) =>
      Band(id: obj['id'], name: obj['name'], votes: obj['votes']);
}
