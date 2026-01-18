// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_initialization_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userInitializationServiceHash() =>
    r'4d2c6fe60a0b1a242d839cb22d08f9baf78efb28';

/// Provider for UserInitializationService
///
/// This service is responsible for ensuring user records are properly
/// initialized in the database after authentication
///
/// Copied from [userInitializationService].
@ProviderFor(userInitializationService)
final userInitializationServiceProvider =
    AutoDisposeProvider<UserInitializationService>.internal(
      userInitializationService,
      name: r'userInitializationServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userInitializationServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserInitializationServiceRef =
    AutoDisposeProviderRef<UserInitializationService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
