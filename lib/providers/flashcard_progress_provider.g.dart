// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_progress_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$flashcardProgressForSetHash() =>
    r'6cd355f3c66ae0aaf1bd1c3ade81e093c4631621';

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

/// See also [flashcardProgressForSet].
@ProviderFor(flashcardProgressForSet)
const flashcardProgressForSetProvider = FlashcardProgressForSetFamily();

/// See also [flashcardProgressForSet].
class FlashcardProgressForSetFamily
    extends Family<AsyncValue<Map<String, FlashcardProgress>>> {
  /// See also [flashcardProgressForSet].
  const FlashcardProgressForSetFamily();

  /// See also [flashcardProgressForSet].
  FlashcardProgressForSetProvider call(String setId) {
    return FlashcardProgressForSetProvider(setId);
  }

  @override
  FlashcardProgressForSetProvider getProviderOverride(
    covariant FlashcardProgressForSetProvider provider,
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
  String? get name => r'flashcardProgressForSetProvider';
}

/// See also [flashcardProgressForSet].
class FlashcardProgressForSetProvider
    extends AutoDisposeFutureProvider<Map<String, FlashcardProgress>> {
  /// See also [flashcardProgressForSet].
  FlashcardProgressForSetProvider(String setId)
    : this._internal(
        (ref) =>
            flashcardProgressForSet(ref as FlashcardProgressForSetRef, setId),
        from: flashcardProgressForSetProvider,
        name: r'flashcardProgressForSetProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$flashcardProgressForSetHash,
        dependencies: FlashcardProgressForSetFamily._dependencies,
        allTransitiveDependencies:
            FlashcardProgressForSetFamily._allTransitiveDependencies,
        setId: setId,
      );

  FlashcardProgressForSetProvider._internal(
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
    FutureOr<Map<String, FlashcardProgress>> Function(
      FlashcardProgressForSetRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FlashcardProgressForSetProvider._internal(
        (ref) => create(ref as FlashcardProgressForSetRef),
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
  AutoDisposeFutureProviderElement<Map<String, FlashcardProgress>>
  createElement() {
    return _FlashcardProgressForSetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FlashcardProgressForSetProvider && other.setId == setId;
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
mixin FlashcardProgressForSetRef
    on AutoDisposeFutureProviderRef<Map<String, FlashcardProgress>> {
  /// The parameter `setId` of this provider.
  String get setId;
}

class _FlashcardProgressForSetProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, FlashcardProgress>>
    with FlashcardProgressForSetRef {
  _FlashcardProgressForSetProviderElement(super.provider);

  @override
  String get setId => (origin as FlashcardProgressForSetProvider).setId;
}

String _$flashcardProgressControllerHash() =>
    r'4c2e70cdbcd6f899dc4deef94a1e4c73c5e15c1e';

abstract class _$FlashcardProgressController
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, FlashcardProgress>> {
  late final String setId;

  FutureOr<Map<String, FlashcardProgress>> build(String setId);
}

/// See also [FlashcardProgressController].
@ProviderFor(FlashcardProgressController)
const flashcardProgressControllerProvider = FlashcardProgressControllerFamily();

/// See also [FlashcardProgressController].
class FlashcardProgressControllerFamily
    extends Family<AsyncValue<Map<String, FlashcardProgress>>> {
  /// See also [FlashcardProgressController].
  const FlashcardProgressControllerFamily();

  /// See also [FlashcardProgressController].
  FlashcardProgressControllerProvider call(String setId) {
    return FlashcardProgressControllerProvider(setId);
  }

  @override
  FlashcardProgressControllerProvider getProviderOverride(
    covariant FlashcardProgressControllerProvider provider,
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
  String? get name => r'flashcardProgressControllerProvider';
}

/// See also [FlashcardProgressController].
class FlashcardProgressControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          FlashcardProgressController,
          Map<String, FlashcardProgress>
        > {
  /// See also [FlashcardProgressController].
  FlashcardProgressControllerProvider(String setId)
    : this._internal(
        () => FlashcardProgressController()..setId = setId,
        from: flashcardProgressControllerProvider,
        name: r'flashcardProgressControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$flashcardProgressControllerHash,
        dependencies: FlashcardProgressControllerFamily._dependencies,
        allTransitiveDependencies:
            FlashcardProgressControllerFamily._allTransitiveDependencies,
        setId: setId,
      );

  FlashcardProgressControllerProvider._internal(
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
  FutureOr<Map<String, FlashcardProgress>> runNotifierBuild(
    covariant FlashcardProgressController notifier,
  ) {
    return notifier.build(setId);
  }

  @override
  Override overrideWith(FlashcardProgressController Function() create) {
    return ProviderOverride(
      origin: this,
      override: FlashcardProgressControllerProvider._internal(
        () => create()..setId = setId,
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
  AutoDisposeAsyncNotifierProviderElement<
    FlashcardProgressController,
    Map<String, FlashcardProgress>
  >
  createElement() {
    return _FlashcardProgressControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FlashcardProgressControllerProvider && other.setId == setId;
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
mixin FlashcardProgressControllerRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, FlashcardProgress>> {
  /// The parameter `setId` of this provider.
  String get setId;
}

class _FlashcardProgressControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          FlashcardProgressController,
          Map<String, FlashcardProgress>
        >
    with FlashcardProgressControllerRef {
  _FlashcardProgressControllerProviderElement(super.provider);

  @override
  String get setId => (origin as FlashcardProgressControllerProvider).setId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
