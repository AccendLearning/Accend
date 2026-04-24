import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_interface/src/app/constants.dart';
import 'package:mobile_interface/src/app/routes.dart';
import 'package:mobile_interface/src/features/onboarding/controllers/onboarding_controller.dart';
import 'onboarding_header.dart';

class NativeLanguagePage extends StatefulWidget {
  const NativeLanguagePage({super.key});

  @override
  State<NativeLanguagePage> createState() => _NativeLanguagePageState();
}

class _NativeLanguagePageState extends State<NativeLanguagePage> {
  String? _selected;
  bool _syncedFromController = false;
  final _searchController = TextEditingController();

  static const List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'Japanese',
    'Korean',
    'Mandarin',
    'Cantonese',
    'Wu',
    'Vietnamese',
    'Ilocano',
    'Tagalog',
    'Russian',
    'Arabic',
    'Georgian',
    'German',
    'Latin',
    'Bulgarian',
    'Scandinavian',
    'Sinhala',
    'Hindi',
    'Portuguese',
    'Nepali',
    'Hausa',
    'Yoruba',
    'Igbo',
    'Swedish',
    'Italian',
    'Greek',
    'Pidgin',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_syncedFromController) return;
    _syncedFromController = true;
    final value = context.read<OnboardingController>().data.nativeLanguage;
    if (value != null && value.isNotEmpty) {
      setState(() => _selected = value);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSelect(String value) {
    setState(() => _selected = value);
    final onboardingController = context.read<OnboardingController>();
    onboardingController.setNativeLanguage(value);
    onboardingController.saveProgress();
  }

  Future<void> _onContinue() async {
    if (_selected == null) return;
    await context.read<OnboardingController>().saveProgress(silent: false);
    if (!mounted) return;
    Navigator.pushNamed(context, AppRoutes.onboardingSkillAssess);
  }

  Future<void> _onBack() async {
    final onboardingController = context.read<OnboardingController>();
    await onboardingController.saveProgress();
    if (!mounted) return;
    final didPop = await Navigator.maybePop(context);
    if (!didPop && mounted) {
      final previousRoute = onboardingController.previousRouteFor(
        AppRoutes.onboardingNativeLanguage,
      );
      if (previousRoute != null) {
        Navigator.pushReplacementNamed(context, previousRoute);
      }
    }
  }

  List<String> get _filtered {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _languages;
    return _languages
        .where((l) => l.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm + 6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OnboardingTopBar(
                step: 1,
                totalSteps: 7,
                rightLabel: 'Native Language',
                showBack: true,
                onBack: _onBack,
              ),
              const SizedBox(height: AppSpacing.sm),

              const OnboardingProgressBar(step: 1, totalSteps: 7),
              const SizedBox(height: AppSpacing.xl),

              const OnboardingQuestionHeader(
                icon: Icons.record_voice_over_outlined,
                leadingText: 'What is your ',
                highlightedText: 'native language',
                trailingText: '?',
                subheader:
                    'We use this to adjust which pronunciation errors we flag for you.',
              ),

              const SizedBox(height: AppSpacing.lg),

              // Search field
              AnimatedBuilder(
                animation: _searchController,
                builder: (context, _) {
                  return TextField(
                    controller: _searchController,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                    decoration: InputDecoration(
                      hintText: 'Search languages...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: AppColors.textSecondary,
                                size: 18,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                    onChanged: (_) => setState(() {}),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.sm),

              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _filtered.isEmpty ? 1 : _filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    if (_filtered.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'No languages match "${_searchController.text.trim()}"',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      );
                    }
                    final lang = _filtered[i];
                    return _LanguageRow(
                      label: lang,
                      selected: _selected == lang,
                      onTap: () => _onSelect(lang),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _selected == null ? null : _onContinue,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.md),
            border: Border.all(
              color: selected ? AppColors.accent : const Color(0x4D334155),
              width: selected ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.accent : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? AppColors.accent
                        : const Color(0x7F334155),
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: AppColors.primaryBg,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
