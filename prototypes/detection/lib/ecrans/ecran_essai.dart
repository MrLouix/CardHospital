import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../logique/configuration.dart';
import '../logique/essai.dart';

/// Construit la vue caméra ; [surImage] reçoit les contenus des QR lus dans
/// chaque image. Remplaçable dans les tests, où il n'y a pas de caméra.
typedef ConstructeurCamera = Widget Function(
  BuildContext context,
  ConfigEssai config,
  void Function(List<String> contenus) surImage,
);

enum _Phase { attente, enCours, termine }

/// Un ou plusieurs essais successifs avec la même configuration : top
/// départ, lecture, résultat, puis essai suivant.
class EcranEssai extends StatefulWidget {
  const EcranEssai({
    super.key,
    required this.config,
    required this.premierNumero,
    required this.onEssai,
    this.camera,
  });

  final ConfigEssai config;
  final int premierNumero;

  /// Appelé pour chaque essai que le testeur garde.
  final Future<void> Function(ResultatEssai) onEssai;
  final ConstructeurCamera? camera;

  @override
  State<EcranEssai> createState() => _EcranEssaiState();
}

class _EcranEssaiState extends State<EcranEssai> {
  late int _numero = widget.premierNumero;
  var _phase = _Phase.attente;
  late SuiviEssai _suivi = SuiviEssai(widget.config);
  final _chrono = Stopwatch();
  Timer? _tic;
  DateTime? _debut;

  @override
  void dispose() {
    _tic?.cancel();
    super.dispose();
  }

  void _topDepart() {
    setState(() {
      _suivi = SuiviEssai(widget.config);
      _debut = DateTime.now();
      _phase = _Phase.enCours;
      _chrono
        ..reset()
        ..start();
    });
    _tic = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_suivi.verifierDelai(_chrono.elapsed)) _terminer();
      if (mounted) setState(() {});
    });
  }

  void _surImage(List<String> contenus) {
    if (_phase != _Phase.enCours) return;
    final reussi = _suivi.ajouterImage(_chrono.elapsed, contenus);
    if (reussi) {
      HapticFeedback.mediumImpact();
      _terminer();
    } else if (_suivi.termine) {
      _terminer();
    }
    setState(() {});
  }

  void _abandonner() {
    _suivi.abandonner(_chrono.elapsed);
    _terminer();
  }

  void _terminer() {
    _chrono.stop();
    _tic?.cancel();
    if (mounted) setState(() => _phase = _Phase.termine);
  }

  Future<void> _garder({required bool continuer}) async {
    await widget.onEssai(_suivi.resultat(numero: _numero, date: _debut!));
    if (!mounted) return;
    if (continuer) {
      setState(() {
        _numero++;
        _phase = _Phase.attente;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _jeter() => setState(() => _phase = _Phase.attente);

  @override
  Widget build(BuildContext context) {
    final camera = widget.camera ?? _cameraReelle;
    return Scaffold(
      appBar: AppBar(
        title: Text('Essai n° $_numero — ${widget.config.mode.libelle}'),
      ),
      body: Column(
        children: [
          Expanded(child: camera(context, widget.config, _surImage)),
          Material(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: switch (_phase) {
                _Phase.attente => _panneauAttente(),
                _Phase.enCours => _panneauEnCours(),
                _Phase.termine => _panneauResultat(),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _panneauAttente() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'Cartes posées : ${widget.config.cartesAttendues.join(', ')}. '
        'Visez ailleurs, appuyez sur « Top départ », puis visez les cartes.',
      ),
      const SizedBox(height: 8),
      FilledButton.icon(
        key: const Key('top'),
        onPressed: _topDepart,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Top départ'),
      ),
    ],
  );

  Widget _panneauEnCours() {
    final derniere = _suivi.detections.lastOrNull;
    final cumulatif = widget.config.mode == ModeSelection.cumulatif;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _secondes(_chrono.elapsed),
          key: const Key('chrono'),
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        Text(
          derniere == null
              ? 'Aucun QR lu pour l\'instant.'
              : 'Dernière image (${derniere.instant.inMilliseconds} ms) : '
                    '${derniere.contenus.join(', ')} — '
                    '${_suivi.detections.length} image(s)',
        ),
        const SizedBox(height: 4),
        _Selection(
          suivi: _suivi,
          modifiable: cumulatif,
          onChange: () => setState(() {}),
        ),
        if (cumulatif)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(_suivi.vider),
              child: const Text('Vider la sélection'),
            ),
          ),
        OutlinedButton(
          key: const Key('echec'),
          onPressed: _abandonner,
          child: const Text('Échec (arrêter l\'essai)'),
        ),
      ],
    );
  }

  Widget _panneauResultat() {
    final reussi = _suivi.issue == IssueEssai.reussi;
    final faux = _suivi.faussesLectures;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          reussi
              ? 'Réussi : ${widget.config.cartesAttendues.length} carte(s) en '
                    '${_secondes(_suivi.duree!)}'
              : 'Échec après ${_secondes(_suivi.duree!)}',
          key: const Key('resultat'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (faux.isNotEmpty)
          Text(
            'Fausses lectures : ${faux.join(', ')}',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        const SizedBox(height: 8),
        FilledButton(
          key: const Key('suivant'),
          onPressed: () => _garder(continuer: true),
          child: const Text('Garder et faire l\'essai suivant'),
        ),
        OutlinedButton(
          key: const Key('terminer'),
          onPressed: () => _garder(continuer: false),
          child: const Text('Garder et revenir'),
        ),
        TextButton(
          key: const Key('jeter'),
          onPressed: _jeter,
          child: const Text('Ne pas garder cet essai'),
        ),
      ],
    );
  }
}

/// Vignettes de la sélection ; en mode cumulatif, un appui retire la carte.
class _Selection extends StatelessWidget {
  const _Selection({
    required this.suivi,
    required this.modifiable,
    required this.onChange,
  });

  final SuiviEssai suivi;
  final bool modifiable;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final attendues = suivi.config.cartesAttendues;
    final erreur = Theme.of(context).colorScheme.error;
    return Wrap(
      spacing: 6,
      children: [
        for (final c in attendues.union(suivi.selection.toSet()))
          InputChip(
            label: Text(c),
            selected: suivi.selection.contains(c),
            avatar: attendues.contains(c)
                ? null
                : Icon(Icons.warning_amber, color: erreur),
            onDeleted: modifiable && suivi.selection.contains(c)
                ? () {
                    suivi.retirer(c);
                    onChange();
                  }
                : null,
          ),
      ],
    );
  }
}

/// Caméra réelle : `mobile_scanner`, QR seulement, toutes les images
/// analysées (`DetectionSpeed.unrestricted`), à la résolution choisie.
Widget _cameraReelle(
  BuildContext context,
  ConfigEssai config,
  void Function(List<String>) surImage,
) => _CameraQr(config: config, surImage: surImage);

class _CameraQr extends StatefulWidget {
  const _CameraQr({required this.config, required this.surImage});

  final ConfigEssai config;
  final void Function(List<String>) surImage;

  @override
  State<_CameraQr> createState() => _CameraQrState();
}

class _CameraQrState extends State<_CameraQr> {
  late final _controleur = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.unrestricted,
    cameraResolution: Size(
      widget.config.resolution.largeur.toDouble(),
      widget.config.resolution.hauteur.toDouble(),
    ),
  );

  @override
  void dispose() {
    _controleur.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MobileScanner(
    controller: _controleur,
    onDetect: (capture) => widget.surImage([
      for (final b in capture.barcodes)
        if (b.rawValue != null) b.rawValue!,
    ]),
    errorBuilder: (context, erreur) => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          erreur.errorCode == MobileScannerErrorCode.permissionDenied
              ? 'L\'accès à la caméra est refusé. Autorisez-le dans les '
                    'réglages Android (Applications > Détection CardHospital > '
                    'Autorisations), puis revenez sur cet écran.'
              : 'La caméra ne peut pas démarrer : $erreur',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

String _secondes(Duration d) =>
    '${(d.inMilliseconds / 1000).toStringAsFixed(2).replaceAll('.', ',')} s';
