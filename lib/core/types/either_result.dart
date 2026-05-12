/// Either type using Dart 3 native Records.
/// Returns a tuple: (error message OR null, data OR null).
/// The compiler forces the caller to handle both cases.
typedef EitherResult<T> = (String? error, T? data);

/// Helper to create a success result
EitherResult<T> success<T>(T data) => (null, data);

/// Helper to create a failure result
EitherResult<T> failure<T>(String error) => (error, null);
