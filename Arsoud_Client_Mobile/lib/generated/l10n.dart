// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Your hikes`
  String get vosRandonnes {
    return Intl.message(
      'Your hikes',
      name: 'vosRandonnes',
      desc: '',
      args: [],
    );
  }

  /// `We are currently experiencing an issue with the server. Please try again later.`
  String get nousRencontronsUnProblemeAvecLeServeurActuellementVeuillezRevenir {
    return Intl.message(
      'We are currently experiencing an issue with the server. Please try again later.',
      name: 'nousRencontronsUnProblemeAvecLeServeurActuellementVeuillezRevenir',
      desc: '',
      args: [],
    );
  }

  /// `You haven't created any hikes until today. To continue in this section, please create a hike.`
  String get vousNavezCreAucuneRandonne {
    return Intl.message(
      'You haven\'t created any hikes until today. To continue in this section, please create a hike.',
      name: 'vousNavezCreAucuneRandonne',
      desc: '',
      args: [],
    );
  }

  /// `Search for a hike`
  String get chercherUneRandonne {
    return Intl.message(
      'Search for a hike',
      name: 'chercherUneRandonne',
      desc: '',
      args: [],
    );
  }

  /// `Location:`
  String get location {
    return Intl.message(
      'Location:',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Type:`
  String get type {
    return Intl.message(
      'Type:',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Get Directions`
  String get getDirections {
    return Intl.message(
      'Get Directions',
      name: 'getDirections',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `- Distance:`
  String get distance {
    return Intl.message(
      '- Distance:',
      name: 'distance',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get pleaseEnterAPassword {
    return Intl.message(
      'Please enter a password',
      name: 'pleaseEnterAPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Please verify your password and your email address`
  String get PleaseCheck {
    return Intl.message(
      'Please verify your password and your email address',
      name: 'PleaseCheck',
      desc: '',
      args: [],
    );
  }

  /// `Our servers are currently experiencing a problem. Please try again later.`
  String get VeuillezRessayerPlusTard {
    return Intl.message(
      'Our servers are currently experiencing a problem. Please try again later.',
      name: 'VeuillezRessayerPlusTard',
      desc: '',
      args: [],
    );
  }

  /// `Please reconnect to the internet to continue.`
  String get ReconectezInternetPourContinuer {
    return Intl.message(
      'Please reconnect to the internet to continue.',
      name: 'ReconectezInternetPourContinuer',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Stop`
  String get stop {
    return Intl.message(
      'Stop',
      name: 'stop',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an email address`
  String get pleaseEnterAEmail {
    return Intl.message(
      'Please enter an email address',
      name: 'pleaseEnterAEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to your account`
  String get signInToYourAccount {
    return Intl.message(
      'Sign in to your account',
      name: 'signInToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Discover new hikes`
  String get discoverNewHikes {
    return Intl.message(
      'Discover new hikes',
      name: 'discoverNewHikes',
      desc: '',
      args: [],
    );
  }

  /// `There are no hikes that can be found`
  String get noHikesExist {
    return Intl.message(
      'There are no hikes that can be found',
      name: 'noHikesExist',
      desc: '',
      args: [],
    );
  }

  /// `Your favorite trails`
  String get favoriteTrail {
    return Intl.message(
      'Your favorite trails',
      name: 'favoriteTrail',
      desc: '',
      args: [],
    );
  }

  /// `You have no favorite hikes`
  String get noFavorites {
    return Intl.message(
      'You have no favorite hikes',
      name: 'noFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info {
    return Intl.message(
      'Info',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `My list of trails`
  String get myListOfTrails {
    return Intl.message(
      'My list of trails',
      name: 'myListOfTrails',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Advertisement`
  String get advertisement {
    return Intl.message(
      'Advertisement',
      name: 'advertisement',
      desc: '',
      args: [],
    );
  }

  /// `You need to be logged in to access this page.`
  String get youNeedToBeLoggedInToAccessThisPage {
    return Intl.message(
      'You need to be logged in to access this page.',
      name: 'youNeedToBeLoggedInToAccessThisPage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `My trails`
  String get myTrails {
    return Intl.message(
      'My trails',
      name: 'myTrails',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message(
      'Favorite',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Session has expired. Please login again.`
  String get sessionHasExpiredPleaseLoginAgain {
    return Intl.message(
      'Session has expired. Please login again.',
      name: 'sessionHasExpiredPleaseLoginAgain',
      desc: '',
      args: [],
    );
  }

  /// `The trail does not exist.`
  String get theTrailDoesNotExist {
    return Intl.message(
      'The trail does not exist.',
      name: 'theTrailDoesNotExist',
      desc: '',
      args: [],
    );
  }

  /// `Une erreur c'est produite`
  String get uneErreurCestProduite {
    return Intl.message(
      'Une erreur c\'est produite',
      name: 'uneErreurCestProduite',
      desc: '',
      args: [],
    );
  }

  /// `Faire le trajet`
  String get faireLeTrajet {
    return Intl.message(
      'Faire le trajet',
      name: 'faireLeTrajet',
      desc: '',
      args: [],
    );
  }

  /// `Rendre Privé`
  String get rendrePriv {
    return Intl.message(
      'Rendre Privé',
      name: 'rendrePriv',
      desc: '',
      args: [],
    );
  }

  /// `Location services are disabled`
  String get locationServiceDisabled {
    return Intl.message(
      'Location services are disabled',
      name: 'locationServiceDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Location services permissions are disabled`
  String get locationServicePermissionsDisabled {
    return Intl.message(
      'Location services permissions are disabled',
      name: 'locationServicePermissionsDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are permanently denied, we cannot request permissions.`
  String get locationServicePermissionsPermanentlyDisabled {
    return Intl.message(
      'Location permissions are permanently denied, we cannot request permissions.',
      name: 'locationServicePermissionsPermanentlyDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get sendPhoto {
    return Intl.message(
      'Send',
      name: 'sendPhoto',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
