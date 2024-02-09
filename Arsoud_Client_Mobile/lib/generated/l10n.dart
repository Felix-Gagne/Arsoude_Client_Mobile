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

  /// `Vos randonnées`
  String get vosRandonnes {
    return Intl.message(
      'Vos randonnées',
      name: 'vosRandonnes',
      desc: '',
      args: [],
    );
  }

  /// `Nous rencontrons un probleme avec le serveur actuellement veuillez revenir plus tard.`
  String get nousRencontronsUnProblemeAvecLeServeurActuellementVeuillezRevenir {
    return Intl.message(
      'Nous rencontrons un probleme avec le serveur actuellement veuillez revenir plus tard.',
      name: 'nousRencontronsUnProblemeAvecLeServeurActuellementVeuillezRevenir',
      desc: '',
      args: [],
    );
  }

  /// `Vous n'avez crée aucune randonnée jusqu'à aujourd'hui. Afin de continuer dans cette section veuillez crée une randonnée.`
  String get vousNavezCreAucuneRandonne {
    return Intl.message(
      'Vous n\'avez crée aucune randonnée jusqu\'à aujourd\'hui. Afin de continuer dans cette section veuillez crée une randonnée.',
      name: 'vousNavezCreAucuneRandonne',
      desc: '',
      args: [],
    );
  }

  /// `Chercher une randonnée`
  String get chercherUneRandonne {
    return Intl.message(
      'Chercher une randonnée',
      name: 'chercherUneRandonne',
      desc: '',
      args: [],
    );
  }

  /// `Location :`
  String get location {
    return Intl.message(
      'Location :',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Type :`
  String get type {
    return Intl.message(
      'Type :',
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
