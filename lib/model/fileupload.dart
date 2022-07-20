class FileUpload {
  String? success;
  String? uploadStatus;
  String? file;
  List<String>? path;
  int? filesize;
  int? imagefilesize;

  FileUpload(
      {this.success,
        this.uploadStatus,
        this.file,
        this.path,
        this.filesize,
        this.imagefilesize});

  FileUpload.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    uploadStatus = json['upload_status'];
    file = json['file'];
    path = json['path'].cast<String>();
    filesize = json['filesize'];
    imagefilesize = json['imagefilesize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['upload_status'] = this.uploadStatus;
    data['file'] = this.file;
    data['path'] = this.path;
    data['filesize'] = this.filesize;
    data['imagefilesize'] = this.imagefilesize;
    return data;
  }
}