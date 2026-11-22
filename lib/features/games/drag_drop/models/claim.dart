/// Modelo que representa una afirmación sobre una fibra.
///
/// [isWool] indica si la afirmación corresponde a la lana (`true`)
/// o al acrílico (`false`).
class Claim {
  final String text;
  final bool isWool;

  const Claim(this.text, this.isWool);
}

