// onboarding_header.dart
import 'package:flutter/material.dart';
import '../../../app/constants.dart';
import '../../../app/theme.dart';
import 'package:google_fonts/google_fonts.dart'; //temporary

/// Topbar (back button + step label + right label)
class OnboardingTopBar extends StatelessWidget {
  final int step;
  final int totalSteps;
  final String? rightLabel;
  final bool showBack;
  final VoidCallback? onBack;

  const OnboardingTopBar({
    super.key,
    required this.step,
    required this.totalSteps,
    this.rightLabel,
    this.showBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final right = rightLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button row
        SizedBox(
          height: 48,
          child: Align(
            alignment: Alignment.centerLeft,
            child: showBack
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: onBack ?? () => Navigator.maybePop(context),
                  )
                : const SizedBox.shrink(),
          ),
        ),

        // Step + right label row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'STEP $step OF $totalSteps',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (right != null)
              Text(
                right,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Progress bar (fills based on step/totalSteps)
class OnboardingProgressBar extends StatelessWidget {
  final int step;
  final int totalSteps;

  const OnboardingProgressBar({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        (totalSteps <= 0) ? 0.0 : (step / totalSteps).clamp(0.0, 1.0);

    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}

/// Question header (text on left + mountain icon on right + subheader)
class OnboardingQuestionHeader extends StatelessWidget {
  final IconData icon;
  final String leadingText;
  final String highlightedText;
  final String subheader;

  // Figma icon box aspect ratio (width / height)
  final double iconBoxAspectRatio;

  // Space between text and icon
  final double gap;

  // Glow sizing (smaller = tighter glow)
  final double glowBlur;

  const OnboardingQuestionHeader({
    super.key,
    IconData? icon,
    required this.leadingText,
    required this.highlightedText,
    required this.subheader,
    this.iconBoxAspectRatio = 81.90 / 62.25,
    this.gap = AppSpacing.xs,
    this.glowBlur = 10, // smaller glow
  }) : icon = icon ?? Icons.landscape_outlined;

  @override
  Widget build(BuildContext context) {
// Prefer theme headlineLarge if present, but force Inter w800 locally so we get a heavy weight.
final baseHeading = Theme.of(context).textTheme.headlineLarge;
final headingStyle = GoogleFonts.inter(
  textStyle: baseHeading?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w800,
      ) ??
      const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
);

    // Build the rich text spans
    final questionSpan = TextSpan(
      children: [
        TextSpan(
          text: leadingText,
          style: headingStyle.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,   // << use 800
          ),
        ),
        TextSpan(
          text: highlightedText,
          style: headingStyle.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w800,   // << use 800
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Limit icon width so it doesn't squeeze text too much
        const double maxIconBoxWidth = 96;

        // First pass: estimate text height with a capped icon width
        final double availableForText =
            (constraints.maxWidth - maxIconBoxWidth - gap)
                .clamp(0, constraints.maxWidth);

        final textPainter = TextPainter(
          text: questionSpan,
          textDirection: Directionality.of(context),
          maxLines: 10,
        )..layout(maxWidth: availableForText);

        // Icon box height = FULL rendered question text height
        final double iconBoxHeight = textPainter.height;

        // Icon box width uses the aspect ratio
        final double iconBoxWidth =
            (iconBoxHeight * iconBoxAspectRatio).clamp(56.0, maxIconBoxWidth);

        // Second pass: re-measure text using the final icon box width
        final double finalTextWidth =
            (constraints.maxWidth - iconBoxWidth - gap)
                .clamp(0, constraints.maxWidth);

        final finalPainter = TextPainter(
          text: questionSpan,
          textDirection: Directionality.of(context),
          maxLines: 10,
        )..layout(maxWidth: finalTextWidth);

        // Icon size fits inside the icon box
        final double iconSize = finalPainter.height * 1.2;        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row: question text + right icon box
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: text
                SizedBox(
                  width: finalTextWidth,
                  child: RichText(text: questionSpan),
                ),

                SizedBox(width: gap),

                // Right: icon box matches full text height
                SizedBox(
                  width: iconBoxWidth,
                  height: finalPainter.height,
                  child: Center(
                    // Icon with small glow using Icon.shadows
                    child: Icon(
                      icon,
                      size: iconSize,
                      color: AppColors.accent,
                      shadows: [
                        Shadow(
                          color: AppColors.accent,
                          blurRadius: glowBlur,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Subheader
            Text(
              subheader,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        );
      },
    );
  }
}