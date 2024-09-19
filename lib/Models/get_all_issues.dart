class GetAllIssues {
  int? id;
  String? region;
  String? country;
  String? customer;
  String? technology;
  String? product;
  String? description;
  String? summary;
  String? status;
  String? severity;
  String? title;
  String? name;
  String? productFamily;
  String? createdAt;
  String? ticket;
  String? problemTicket;
  String? lastUpdated;
  String? softwareVersion;

  GetAllIssues(
      {this.id,
        this.region,
        this.country,
        this.customer,
        this.technology,
        this.product,
        this.description,
        this.summary,
        this.status,
        this.severity,
        this.title,
        this.name,
        this.productFamily,
        this.createdAt,
        this.ticket,
        this.problemTicket,
        this.lastUpdated,
        this.softwareVersion});

  GetAllIssues.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    region = json['region'];
    country = json['country'];
    customer = json['customer'];
    technology = json['technology'];
    product = json['product'];
    description = json['description'];
    summary = json['summary'];
    status = json['status'];
    severity = json['severity'];
    title = json['title'];
    name = json['name'];
    productFamily = json['product_family'];
    createdAt = json['created_at'];
    ticket = json['ticket'];
    problemTicket = json['problem_ticket'];
    lastUpdated = json['last_updated'];
    softwareVersion = json['software_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['region'] = this.region;
    data['country'] = this.country;
    data['customer'] = this.customer;
    data['technology'] = this.technology;
    data['product'] = this.product;
    data['description'] = this.description;
    data['summary'] = this.summary;
    data['status'] = this.status;
    data['severity'] = this.severity;
    data['title'] = this.title;
    data['name'] = this.name;
    data['product_family'] = this.productFamily;
    data['created_at'] = this.createdAt;
    data['ticket'] = this.ticket;
    data['problem_ticket'] = this.problemTicket;
    data['last_updated'] = this.lastUpdated;
    data['software_version'] = this.softwareVersion;
    return data;
  }
}
