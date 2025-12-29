// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter_variants_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$letterVariantsHash() => r'6b48d87cbe1b5c7e2301533d1b8ff82994a41fb7';

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

/// See also [letterVariants].
@ProviderFor(letterVariants)
const letterVariantsProvider = LetterVariantsFamily();

/// See also [letterVariants].
class LetterVariantsFamily extends Family<AsyncValue<PostgrestList>> {
  /// See also [letterVariants].
  const LetterVariantsFamily();

  /// See also [letterVariants].
  LetterVariantsProvider call(String baseLetter) {
    return LetterVariantsProvider(baseLetter);
  }

  @override
  LetterVariantsProvider getProviderOverride(
    covariant LetterVariantsProvider provider,
  ) {
    return call(provider.baseLetter);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'letterVariantsProvider';
}

/// See also [letterVariants].
class LetterVariantsProvider extends AutoDisposeFutureProvider<PostgrestList> {
  /// See also [letterVariants].
  LetterVariantsProvider(String baseLetter)
    : this._internal(
        (ref) => letterVariants(ref as LetterVariantsRef, baseLetter),
        from: letterVariantsProvider,
        name: r'letterVariantsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$letterVariantsHash,
        dependencies: LetterVariantsFamily._dependencies,
        allTransitiveDependencies:
            LetterVariantsFamily._allTransitiveDependencies,
        baseLetter: baseLetter,
      );

  LetterVariantsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.baseLetter,
  }) : super.internal();

  final String baseLetter;

  @override
  Override overrideWith(
    FutureOr<PostgrestList> Function(LetterVariantsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LetterVariantsProvider._internal(
        (ref) => create(ref as LetterVariantsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        baseLetter: baseLetter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PostgrestList> createElement() {
    return _LetterVariantsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LetterVariantsProvider && other.baseLetter == baseLetter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseLetter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LetterVariantsRef on AutoDisposeFutureProviderRef<PostgrestList> {
  /// The parameter `baseLetter` of this provider.
  String get baseLetter;
}

class _LetterVariantsProviderElement
    extends AutoDisposeFutureProviderElement<PostgrestList>
    with LetterVariantsRef {
  _LetterVariantsProviderElement(super.provider);

  @override
  String get baseLetter => (origin as LetterVariantsProvider).baseLetter;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
