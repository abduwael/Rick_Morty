class AppException {
  final String? _errorMessage;

  AppException(this._errorMessage);

  @override
  String toString() => _errorMessage ?? '';
}
