class ResourceData {
  final String id;
  final String title;
  final String subTitle;
  final String description;
  final String assets;
  const ResourceData(
      this.id, this.title, this.subTitle, this.description, this.assets);

  @override
  String toString() {
    return 'ResourceData: {id: ${id}, title: ${title},subTitle: ${subTitle},description: ${description}, progress: ${assets}}';
  }
}
