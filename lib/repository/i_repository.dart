abstract class IRepository<T> {
  void save(T component);
  T? delete(T component);
  T? find(T component);
  T? findWhere(bool Function(T) predicate);
  Iterable<T> findAll(bool Function(T) predicate);
  T? update(T component);
}
