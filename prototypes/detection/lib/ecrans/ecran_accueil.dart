import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../logique/configuration.dart';
import '../logique/essai.dart';
import '../logique/export_csv.dart';
import '../logique/statistiques.dart';
import '../logique/stockage.dart';
import 'ecran_essai.dart';

/// Configuration de l'essai, synthèse des mesures et export.
class EcranAccueil extends StatefulWidget {
  const EcranAccueil({super.key, required this.stockage, this.camera});

  final Future<Stockage> Function() stockage;

  /// Caméra de l'écran d'essai (remplaçable dans les tests).
  final ConstructeurCamera? camera;

  @override
  State<EcranAccueil> createState() => _EcranAccueilState();
}

class _EcranAccueilState extends State<EcranAccueil> {
  var _config = const ConfigEssai();
  final _essais = <ResultatEssai>[];
  Stockage? _stockage;
  final _distance = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chargerEssais();
  }

  Future<void> _chargerEssais() async {
    final stockage = await widget.stockage();
    final essais = await stockage.charger();
    if (!mounted) return;
    setState(() {
      _stockage = stockage;
      _essais.addAll(essais);
      if (essais.isNotEmpty) _config = essais.last.config;
      _distance.text = _config.distanceCm?.toString() ?? '';
    });
  }

  @override
  void dispose() {
    _distance.dispose();
    super.dispose();
  }

  int get _prochainNumero => _essais.isEmpty ? 1 : _essais.last.numero + 1;

  Future<void> _ajouterEssai(ResultatEssai essai) async {
    setState(() => _essais.add(essai));
    await _stockage?.enregistrer(_essais);
  }

  Future<void> _demarrer() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EcranEssai(
          config: _config,
          premierNumero: _prochainNumero,
          onEssai: _ajouterEssai,
          camera: widget.camera,
        ),
      ),
    );
  }

  Future<void> _exporter() async {
    final dossier = await getTemporaryDirectory();
    final horodatage = DateTime.now()
        .toIso8601String()
        .replaceAll(RegExp(r'[:.]'), '-')
        .substring(0, 19);
    final essais = File('${dossier.path}/essais_$horodatage.csv');
    final detections = File('${dossier.path}/detections_$horodatage.csv');
    await essais.writeAsString(ExportCsv.essais(_essais));
    await detections.writeAsString(ExportCsv.detections(_essais));
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(essais.path), XFile(detections.path)],
        subject: 'Mesures de détection CardHospital',
        text: '${_essais.length} essai(s) de détection.',
      ),
    );
  }

  Future<void> _effacer() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer les essais ?'),
        content: Text(
          '${_essais.length} essai(s) seront supprimés. Exportez-les d\'abord '
          'si vous voulez les garder.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
    if (confirme != true) return;
    setState(_essais.clear);
    await _stockage?.enregistrer(_essais);
  }

  @override
  Widget build(BuildContext context) {
    final stats = Statistiques(_essais);
    final stats4 = Statistiques(
      _essais.where((e) => e.config.cartesAttendues.length == cartesMax),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Détection — phase 0')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Conditions de l\'essai',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: const Key('telephone'),
            initialValue: _config.telephone,
            decoration: const InputDecoration(
              labelText: 'Téléphone (modèle, version d\'Android)',
            ),
            onChanged: (v) => _config = _config.copyWith(telephone: v),
          ),
          _choix(
            'Mode de sélection',
            ModeSelection.values,
            _config.mode,
            (v) => _config.copyWith(mode: v),
            (v) => v.libelle,
          ),
          _choix(
            'Finition',
            Finition.values,
            _config.finition,
            (v) => _config.copyWith(finition: v),
            (v) => v.libelle,
          ),
          _choix(
            'Taille des QR',
            TailleQr.values,
            _config.taille,
            (v) => _config.copyWith(taille: v),
            (v) => v.libelle,
          ),
          _choix(
            'Correction d\'erreur',
            Correction.values,
            _config.correction,
            (v) => _config.copyWith(correction: v),
            (v) => v.libelle,
          ),
          _choix(
            'Éclairage',
            Eclairage.values,
            _config.eclairage,
            (v) => _config.copyWith(eclairage: v),
            (v) => v.libelle,
          ),
          _choix(
            'Cartes',
            Support.values,
            _config.support,
            (v) => _config.copyWith(support: v),
            (v) => v.libelle,
          ),
          _choix(
            'Résolution de la caméra',
            Resolution.values,
            _config.resolution,
            (v) => _config.copyWith(resolution: v),
            (v) => v.libelle,
          ),
          _choix(
            'Angle',
            angles,
            _config.angle,
            (v) => _config.copyWith(angle: v),
            (v) => '$v°',
          ),
          TextField(
            key: const Key('distance'),
            controller: _distance,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Distance (cm)'),
            onChanged: (v) =>
                _config = _config.copyWith(distanceCm: () => int.tryParse(v)),
          ),
          const SizedBox(height: 16),
          Text(
            'Cartes posées (${_config.cartesAttendues.length}/$cartesMax)',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final c in contenusPlanche)
                FilterChip(
                  label: Text(c),
                  selected: _config.cartesAttendues.contains(c),
                  onSelected: (choisi) {
                    final cartes = {..._config.cartesAttendues};
                    if (choisi && cartes.length < cartesMax) cartes.add(c);
                    if (!choisi) cartes.remove(c);
                    setState(
                      () => _config = _config.copyWith(cartesAttendues: cartes),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const Key('demarrer'),
            onPressed: _config.complete ? _demarrer : null,
            icon: const Icon(Icons.qr_code_scanner),
            label: Text('Démarrer l\'essai n° $_prochainNumero'),
          ),
          const Divider(height: 40),
          Text('Mesures', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _Synthese(titre: 'Tous les essais', stats: stats),
          _Synthese(
            titre: 'Essais à 4 cartes (critère de sortie)',
            stats: stats4,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _essais.isEmpty ? null : _exporter,
                  icon: const Icon(Icons.ios_share),
                  label: const Text('Exporter en CSV'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _essais.isEmpty ? null : _effacer,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Effacer'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final e in _essais.reversed) _LigneEssai(e),
        ],
      ),
    );
  }

  Widget _choix<T>(
    String titre,
    List<T> valeurs,
    T actuelle,
    ConfigEssai Function(T) appliquer,
    String Function(T) libelle,
  ) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titre, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          children: [
            for (final v in valeurs)
              ChoiceChip(
                label: Text(libelle(v)),
                selected: v == actuelle,
                onSelected: (_) => setState(() => _config = appliquer(v)),
              ),
          ],
        ),
      ],
    ),
  );
}

class _Synthese extends StatelessWidget {
  const _Synthese({required this.titre, required this.stats});

  final String titre;
  final Statistiques stats;

  @override
  Widget build(BuildContext context) {
    final mediane = stats.mediane;
    return Card(
      child: ListTile(
        title: Text(titre),
        subtitle: Text(
          stats.essais == 0
              ? 'Aucun essai.'
              : '${stats.essais} essai(s), ${stats.reussis} réussi(s)\n'
                    'Moins de 3 s : ${stats.moinsDe3s} '
                    '(${(stats.tauxMoinsDe3s * 100).toStringAsFixed(1)} %, '
                    'objectif ≥ 95 %)\n'
                    'Temps médian : '
                    '${mediane == null ? '—' : _secondes(mediane)}\n'
                    'Fausses lectures : ${stats.faussesLectures} '
                    '(dans la sélection : ${stats.essaisAvecFausseSelection} '
                    'essai(s))',
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _LigneEssai extends StatelessWidget {
  const _LigneEssai(this.essai);

  final ResultatEssai essai;

  @override
  Widget build(BuildContext context) {
    final c = essai.config;
    final faux = essai.faussesLectures.isEmpty
        ? ''
        : ' — fausses lectures : ${essai.faussesLectures.join(', ')}';
    return ListTile(
      dense: true,
      leading: Icon(
        essai.reussi ? Icons.check_circle : Icons.cancel,
        color: essai.reussi
            ? (essai.moinsDe3s ? Colors.green : Colors.orange)
            : Theme.of(context).colorScheme.error,
      ),
      title: Text(
        'N° ${essai.numero} — ${c.cartesAttendues.length} carte(s) — '
        '${essai.issue.libelle} en ${_secondes(essai.duree)}$faux',
      ),
      subtitle: Text(
        '${c.mode.libelle}, ${c.finition.libelle.toLowerCase()}, '
        '${c.taille.libelle}, ${c.correction.libelle}, '
        '${c.eclairage.libelle.toLowerCase()}, ${c.resolution.libelle}',
      ),
    );
  }
}

String _secondes(Duration d) =>
    '${(d.inMilliseconds / 1000).toStringAsFixed(2).replaceAll('.', ',')} s';
