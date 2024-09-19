class GraphModel {
  int? criticalCount;
  int? amberCount;
  int? trackingCount;
  int? totalCount;
  int? closedIssuesCount;
  int? totalIssuesCount;
  String? hottestCountry;
  int? hottestIssueCount;
  String? maxSeverity;
  int? severityIssueCount;
  String? commonProduct;
  int? productIssueCount;
  String? maxStatus;
  int? statusIssueCount;

  GraphModel(
      {this.criticalCount,
        this.amberCount,
        this.trackingCount,
        this.totalCount,
        this.closedIssuesCount,
        this.totalIssuesCount,
        this.hottestCountry,
        this.hottestIssueCount,
        this.maxSeverity,
        this.severityIssueCount,
        this.commonProduct,
        this.productIssueCount,
        this.maxStatus,
        this.statusIssueCount});

  GraphModel.fromJson(Map<String, dynamic> json) {
    criticalCount = json['critical_count'];
    amberCount = json['amber_count'];
    trackingCount = json['tracking_count'];
    totalCount = json['total_count'];
    closedIssuesCount = json['closed_issues_count'];
    totalIssuesCount = json['total_issues_count'];
    hottestCountry = json['hottest_country'];
    hottestIssueCount = json['hottest_issue_count'];
    maxSeverity = json['max_severity'];
    severityIssueCount = json['severity_issue_count'];
    commonProduct = json['common_product'];
    productIssueCount = json['product_issue_count'];
    maxStatus = json['max_status'];
    statusIssueCount = json['status_issue_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['critical_count'] = this.criticalCount;
    data['amber_count'] = this.amberCount;
    data['tracking_count'] = this.trackingCount;
    data['total_count'] = this.totalCount;
    data['closed_issues_count'] = this.closedIssuesCount;
    data['total_issues_count'] = this.totalIssuesCount;
    data['hottest_country'] = this.hottestCountry;
    data['hottest_issue_count'] = this.hottestIssueCount;
    data['max_severity'] = this.maxSeverity;
    data['severity_issue_count'] = this.severityIssueCount;
    data['common_product'] = this.commonProduct;
    data['product_issue_count'] = this.productIssueCount;
    data['max_status'] = this.maxStatus;
    data['status_issue_count'] = this.statusIssueCount;
    return data;
  }
}
