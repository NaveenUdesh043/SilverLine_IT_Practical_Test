enum ProviderSort {
  ratingHighToLow('Rating (high to low)'),
  rateLowToHigh('Hourly rate (low to high)'),
  experienceHighToLow('Experience (high to low)');

  const ProviderSort(this.label);

  final String label;
}
