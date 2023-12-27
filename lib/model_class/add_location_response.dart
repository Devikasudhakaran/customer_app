class AddLocation {
  List<SpaceTagsList>? spaceTagsList;
  String? versionCode;
  List<MasterTableVersionsDetails>? masterTableVersionsDetails;
  Null? bookingInfo;
  String? message;
  int? statuscode;
  String? status;

  AddLocation(
      {this.spaceTagsList,
        this.versionCode,
        this.masterTableVersionsDetails,
        this.bookingInfo,
        this.message,
        this.statuscode,
        this.status});

  AddLocation.fromJson(Map<String, dynamic> json) {
    if (json['space_tags_list'] != null) {
      spaceTagsList = <SpaceTagsList>[];
      json['space_tags_list'].forEach((v) {
        spaceTagsList!.add(new SpaceTagsList.fromJson(v));
      });
    }
    versionCode = json['version_code'];
    if (json['master_table_versions_details'] != null) {
      masterTableVersionsDetails = <MasterTableVersionsDetails>[];
      json['master_table_versions_details'].forEach((v) {
        masterTableVersionsDetails!
            .add(new MasterTableVersionsDetails.fromJson(v));
      });
    }
    bookingInfo = json['booking_info'];
    message = json['message'];
    statuscode = json['statuscode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.spaceTagsList != null) {
      data['space_tags_list'] =
          this.spaceTagsList!.map((v) => v.toJson()).toList();
    }
    data['version_code'] = this.versionCode;
    if (this.masterTableVersionsDetails != null) {
      data['master_table_versions_details'] =
          this.masterTableVersionsDetails!.map((v) => v.toJson()).toList();
    }
    data['booking_info'] = this.bookingInfo;
    data['message'] = this.message;
    data['statuscode'] = this.statuscode;
    data['status'] = this.status;
    return data;
  }
}

class SpaceTagsList {
  String? kokoSpaces;
  String? category;
  String? spaceId;
  String? spaceName;
  String? address;
  String? latitude;
  String? longitude;
  String? price;
  String? businessOwnerFlag;
  String? rating;
  String? spaceImage;
  String? distance;
  String? availableSlots;
  String? startTime;
  String? endTime;

  SpaceTagsList(
      {this.kokoSpaces,
        this.category,
        this.spaceId,
        this.spaceName,
        this.address,
        this.latitude,
        this.longitude,
        this.price,
        this.businessOwnerFlag,
        this.rating,
        this.spaceImage,
        this.distance,
        this.availableSlots,
        this.startTime,
        this.endTime});

  SpaceTagsList.fromJson(Map<String, dynamic> json) {
    kokoSpaces = json['koko_spaces'];
    category = json['category'];
    spaceId = json['space_id'];
    spaceName = json['space_name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    price = json['price'];
    businessOwnerFlag = json['business_owner_flag'];
    rating = json['rating'];
    spaceImage = json['space_image'];
    distance = json['Distance'];
    availableSlots = json['available_slots'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['koko_spaces'] = this.kokoSpaces;
    data['category'] = this.category;
    data['space_id'] = this.spaceId;
    data['space_name'] = this.spaceName;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['price'] = this.price;
    data['business_owner_flag'] = this.businessOwnerFlag;
    data['rating'] = this.rating;
    data['space_image'] = this.spaceImage;
    data['Distance'] = this.distance;
    data['available_slots'] = this.availableSlots;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}

class MasterTableVersionsDetails {
  String? id;
  String? tableName;
  String? tableVersion;

  MasterTableVersionsDetails({this.id, this.tableName, this.tableVersion});

  MasterTableVersionsDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tableName = json['table_name'];
    tableVersion = json['table_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['table_name'] = this.tableName;
    data['table_version'] = this.tableVersion;
    return data;
  }
}
