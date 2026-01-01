// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcards_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$flashcardsHash() => r'e1c0452aeeb6ee94c7d3251b1b52011ab29fba76';

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

/// See also [flashcards].
@ProviderFor(flashcards)
const flashcardsProvider = FlashcardsFamily();

/// See also [flashcards].
class FlashcardsFamily extends Family<AsyncValue<List<Flashcard>>> {
  /// See also [flashcards].
  const FlashcardsFamily();

  /// See also [flashcards].
  FlashcardsProvider call(String setId) {
    return FlashcardsProvider(setId);
  }

  @override
  FlashcardsProvider getProviderOverride(
    covariant FlashcardsProvider provider,
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
  String? get name => r'flashcardsProvider';
}

/// See also [flashcards].
class FlashcardsProvider extends AutoDisposeFutureProvider<List<Flashcard>> {
  /// See also [flashcards].
  FlashcardsProvider(String setId)
    : this._internal(
        (ref) => flashcards(ref as FlashcardsRef, setId),
        from: flashcardsProvider,
        name: r'flashcardsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$flashcardsHash,
        dependencies: FlashcardsFamily._dependencies,
        allTransitiveDependencies: FlashcardsFamily._allTransitiveDependencies,
        setId: setId,
      );

  FlashcardsProvider._internal(
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
    FutureOr<List<Flashcard>> Function(FlashcardsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FlashcardsProvider._internal(
        (ref) => create(ref as FlashcardsRef),
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
  AutoDisposeFutureProviderElement<List<Flashcard>> createElement() {
    return _FlashcardsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FlashcardsProvider && other.setId == setId;
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
mixin FlashcardsRef on AutoDisposeFutureProviderRef<List<Flashcard>> {
  /// The parameter `setId` of this provider.
  String get setId;
}

class _FlashcardsProviderElement
    extends AutoDisposeFutureProviderElement<List<Flashcard>>
    with FlashcardsRef {
  _FlashcardsProviderElement(super.provider);

  @override
  String get setId => (origin as FlashcardsProvider).setId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
