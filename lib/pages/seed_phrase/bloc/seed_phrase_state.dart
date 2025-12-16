class SeedPhraseState {
  final List<String> seedPhrase;
  final bool isCopied;
  final bool isConfirmed;

  const SeedPhraseState({
    this.seedPhrase = const [],
    this.isCopied = false,
    this.isConfirmed = false,
  });

  SeedPhraseState copyWith({
    List<String>? seedPhrase,
    bool? isCopied,
    bool? isConfirmed,
  }) {
    return SeedPhraseState(
      seedPhrase: seedPhrase ?? this.seedPhrase,
      isCopied: isCopied ?? this.isCopied,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }
}
