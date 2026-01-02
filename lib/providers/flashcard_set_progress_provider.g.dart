// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_set_progress_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$flashcardSetProgressHash() =>
    r'95f23840ac86fdc69d6ca66a3e4b20b97fb805ee';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [flashcardSetProgress].
@ProviderFor(flashcardSetProgress)
const flashcardSetProgressProvider = FlashcardSetProgressFamily();

/// See also [flashcardSetProgress].
class FlashcardSetProgressFamily extends Family<AsyncValue<double>> {
  /// See also [flashcardSetProgress].
  const FlashcardSetProgressFamily();

  /// See also [flashcardSetProgress].
  FlashcardSetProgressProvider call(String setId) {
    return FlashcardSetProgressProvider(setId);
  }

  @override
  FlashcardSetProgressProvider getProviderOverride(
    covariant FlashcardSetProgressProvider provider,
  ) {
    return call(provider.setId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'flashcardSetProgressProvider';
}

/// See also [flashcardSetProgress].
class FlashcardSetProgressProvider extends AutoDisposeFutureProvider<double> {
  /// See also [flashcardSetProgress].
  FlashcardSetProgressProvider(String setId)
    : this._internal(
        (ref) => flashcardSetProgress(ref as FlashcardSetProgressRef, setId),
        from: flashcardSetProgressProvider,
        name: r'flashcardSetProgressProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$flashcardSetProgressHash,
        dependencies: FlashcardSetProgressFamily._dependencies,
        allTransitiveDependencies:
            FlashcardSetProgressFamily._allTransitiveDependencies,
        setId: setId,
      );

  FlashcardSetProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.setId,
  }) : super.internal();

  final String setId;

  @override
  Override overrideWith(
    FutureOr<double> Function(FlashcardSetProgressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FlashcardSetProgressProvider._internal(
        (ref) => create(ref as FlashcardSetProgressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        setId: setId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _FlashcardSetProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FlashcardSetProgressProvider && other.setId == setId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, setId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FlashcardSetProgressRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `setId` of this provider.
  String get setId;
}

class _FlashcardSetProgressProviderElement
    extends AutoDisposeFutureProviderElement<double>
    with FlashcardSetProgressRef {
  _FlashcardSetProgressProviderElement(super.provider);

  @override
  String get setId => (origin as FlashcardSetProgressProvider).setId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
