class ResourceModel {
  final String resourceName;
  final List<ResourcesItem> resourceItem;
  final String uniqueID;
  final int createdOn;

  ResourceModel({
    required this.resourceName,
    required this.resourceItem,
    required this.uniqueID,
    required this.createdOn,
  });

  // Convert the model to a map for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'resourceName': resourceName,
      'resourceItem': resourceItem.map((item) => item.toMap()).toList(),
      'uniqueID': uniqueID,
      'createdOn': createdOn,
    };
  }

  // Convert map to a ResourceModel instance (useful when fetching from Firebase)
  factory ResourceModel.fromMap(Map<String, dynamic> map) {
    return ResourceModel(
      resourceName: map['resourceName'],
      resourceItem: List<ResourcesItem>.from(
          map['resourceItem']?.map((item) => ResourcesItem.fromMap(item))),
      uniqueID: map['uniqueID'],
      createdOn: map['createdOn'],
    );
  }
}

class ResourcesItem {
  final String title;
  final String link;

  ResourcesItem({
    required this.title,
    required this.link,
  });

  // Convert to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'link': link,
    };
  }

  // Convert map to ResourcesItem
  factory ResourcesItem.fromMap(Map<String, dynamic> map) {
    return ResourcesItem(
      title: map['title'],
      link: map['link'],
    );
  }
}
