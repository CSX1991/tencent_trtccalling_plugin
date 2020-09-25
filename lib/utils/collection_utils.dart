class CollectionUtils {
  static bool isEmpty(Iterable iterable) {
    return iterable == null || iterable.length == 0;
  }

  static bool isNotEmpty(Iterable iterable) {
    return !isEmpty(iterable);
  }
}
