import '../models/claim.dart';

/// Todas las afirmaciones del juego de arrastrar y soltar.
const List<Claim> allClaims = [
  // Lana
  Claim('Se carboniza al quemarse, sin gotear', true),
  Claim('Absorbe hasta 33% de su peso en vapor de agua', true),
  Claim('Tiene escamas en la cutícula que se traban', true),
  Claim('Se descompone en el suelo en semanas o meses', true),

  // Acrílico
  Claim('Se derrite y gotea al entrar en contacto con la llama', false),
  Claim('Carece de escamas, por eso no se afieltra', false),
  Claim('Sus bolitas (pills) quedan firmemente sujetas', false),
  Claim('Es un polímero sintético de origen petroquímico', false),
];

