import 'dart:async';

import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/app_store.dart';
import 'main_navigation.dart';

class CookingModeScreen extends StatefulWidget {
  const CookingModeScreen({super.key, required this.recipeId});
  final String recipeId;

  @override
  State<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends State<CookingModeScreen> {
  int _stepIndex = 0;
  final Set<String> _checkedIngredients = {};
  final Map<int, int> _remainingByStep = {};
  Timer? _timer;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _setTimer() async {
    final existing = _remainingByStep[_stepIndex] ?? 300;
    final minutes = TextEditingController(text: (existing ~/ 60).toString());
    final seconds = TextEditingController(text: (existing % 60).toString());
    final duration = await showDialog<Duration>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Temporizador desta etapa'),
        content: Row(children: [
          Expanded(child: TextField(controller: minutes, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Minutos'))),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text(':')),
          Expanded(child: TextField(controller: seconds, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Segundos'))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(onPressed: () {
            final value = Duration(minutes: int.tryParse(minutes.text) ?? 0, seconds: int.tryParse(seconds.text) ?? 0);
            Navigator.pop(context, value.inSeconds > 0 ? value : null);
          }, child: const Text('Iniciar')),
        ],
      ),
    );
    minutes.dispose();
    seconds.dispose();
    if (duration == null || !mounted) return;
    _timer?.cancel();
    setState(() {
      _remainingByStep[_stepIndex] = duration.inSeconds;
      _isRunning = false;
    });
    _startTimer();
  }

  void _startTimer() {
    final remaining = _remainingByStep[_stepIndex] ?? 0;
    if (remaining <= 0) return;
    _timer?.cancel();
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = _remainingByStep[_stepIndex] ?? 0;
      if (current <= 1) {
        timer.cancel();
        setState(() {
          _remainingByStep[_stepIndex] = 0;
          _isRunning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('O tempo desta etapa terminou.')),
        );
      } else {
        setState(() => _remainingByStep[_stepIndex] = current - 1);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _goToStep(int index, int totalSteps) {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _stepIndex = index.clamp(0, totalSteps - 1);
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainder = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainder';
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: AppStore.instance,
    builder: (context, _) {
      final recipes = AppStore.instance.recipes;
      final index = recipes.indexWhere((item) => item.id == widget.recipeId);
      if (index < 0) return const Scaffold(body: Center(child: Text('Receita não encontrada.')));
      final Recipe recipe = recipes[index];
      final steps = recipe.preparationSteps;
      final currentStep = _stepIndex.clamp(0, steps.length - 1);
      final secondsLeft = _remainingByStep[currentStep] ?? 0;
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: const Text('Modo de cozinha')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Text(recipe.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: corPrimaria(context), fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: (currentStep + 1) / steps.length, minHeight: 8, color: verde, backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest)),
          const SizedBox(height: 8),
          Text('Etapa ${currentStep + 1} de ${steps.length}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Card(color: Theme.of(context).colorScheme.surface, child: Padding(padding: const EdgeInsets.all(22), child: Text(steps[currentStep], style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.5)))),
          const SizedBox(height: 12),
          Card(color: Theme.of(context).colorScheme.surface, child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
            Text(_formatTime(secondsLeft), style: Theme.of(context).textTheme.displaySmall?.copyWith(fontFeatures: const [], fontWeight: FontWeight.bold, color: corPrimaria(context))),
            const SizedBox(height: 10),
            Wrap(alignment: WrapAlignment.center, spacing: 8, children: [
              OutlinedButton.icon(onPressed: _setTimer, icon: const Icon(Icons.timer_outlined), label: const Text('Definir tempo')),
              if (secondsLeft > 0) FilledButton.icon(onPressed: _isRunning ? _pauseTimer : _startTimer, icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow), label: Text(_isRunning ? 'Pausar' : 'Retomar'), style: FilledButton.styleFrom(backgroundColor: verde)),
            ]),
          ]))),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: currentStep > 0 ? () => _goToStep(currentStep - 1, steps.length) : null, icon: const Icon(Icons.arrow_back), label: const Text('Anterior'))),
            const SizedBox(width: 12),
            Expanded(child: FilledButton.icon(onPressed: currentStep < steps.length - 1 ? () => _goToStep(currentStep + 1, steps.length) : () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receita concluída. Bom apetite!'))), icon: Icon(currentStep < steps.length - 1 ? Icons.arrow_forward : Icons.check), label: Text(currentStep < steps.length - 1 ? 'Próxima' : 'Concluir'), style: FilledButton.styleFrom(backgroundColor: verde))),
          ]),
          const SizedBox(height: 12),
          Card(
            color: Theme.of(context).colorScheme.surface,
            child: ExpansionTile(
              title: Text(
                'Ingredientes (${recipe.ingredients.length})',
                style: TextStyle(color: corPrimaria(context), fontWeight: FontWeight.bold),
              ),
              initiallyExpanded: true,
              children: recipe.ingredients.map((ingredient) {
                return CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: verde,
                  title: Text(ingredient),
                  value: _checkedIngredients.contains(ingredient),
                  onChanged: (checked) => setState(() {
                    if (checked == true) {
                      _checkedIngredients.add(ingredient);
                    } else {
                      _checkedIngredients.remove(ingredient);
                    }
                  }),
                );
              }).toList(),
            ),
          ),
        ]),
      );
    },
  );
}
