

class GurbaniPaathTableData {
  final String id;
  final String ang;
  final String pangti;
  final String title;
  final String description;

  const GurbaniPaathTableData(
      this.id, this.ang, this.pangti, this.title, this.description);

  @override
  String toString() {
    return 'data: {id: ${id}, title: ${title},ang: ${ang},description: ${description}, pangti: ${pangti}}';
  }
}
