class ErrorResponse {
  final String? error;

  ErrorResponse({this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(error: json['error'] as String?);
  }
}
