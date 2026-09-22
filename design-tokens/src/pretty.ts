// Port of R's pretty() (R_pretty in src/appl/pretty.c, R >= 4.2 defaults), so
// colorBin() picks the same breaks as leaflet::colorBin() in councildown.

const DBL_MIN = 2.2250738585072014e-308;
const ROUNDING_EPS = 1e-10;

/** Roughly `n + 1` equally spaced round values covering the range of `values`. */
export function pretty(values: readonly number[], n = 5): number[] {
  const finite = values.filter(Number.isFinite);
  if (finite.length === 0) return [];
  const lo = Math.min(...finite);
  const up = Math.max(...finite);

  const minN = Math.floor(n / 3);
  const h = 1.5; // high.u.bias
  const h5 = 0.5 + 1.5 * h; // u5.bias
  const shrinkSml = 0.75;
  const fMin = 2 ** -20;

  const dx = up - lo;
  let cell: number;
  let iSmall: boolean;
  if (dx === 0 && up === 0) {
    cell = 1;
    iSmall = true;
  } else {
    cell = Math.max(Math.abs(lo), Math.abs(up));
    let U = 1 + (h5 >= 1.5 * h + 0.5 ? 1 / (1 + h) : 1.5 / (1 + h5));
    U *= Math.max(1, n) * Number.EPSILON;
    iSmall = dx < cell * U * 3;
  }

  if (iSmall) {
    if (cell > 10) cell = 9 + cell / 10;
    cell *= shrinkSml;
    if (minN > 1) cell /= minN;
  } else {
    cell = dx;
    if (n > 1) cell /= n;
  }
  cell = Math.max(cell, fMin * DBL_MIN);

  const base = 10 ** Math.floor(Math.log10(cell));
  let unit = base;
  if (2 * base - cell < h * (cell - unit)) {
    unit = 2 * base;
    if (5 * base - cell < h5 * (cell - unit)) {
      unit = 5 * base;
      if (10 * base - cell < h * (cell - unit)) unit = 10 * base;
    }
  }

  let ns = Math.floor(lo / unit + ROUNDING_EPS);
  let nu = Math.ceil(up / unit - ROUNDING_EPS);
  while (ns * unit > lo + ROUNDING_EPS * unit) ns--;
  while (nu * unit < up - ROUNDING_EPS * unit) nu++;

  let k = Math.floor(0.5 + nu - ns);
  let ndiv: number;
  if (k < minN) {
    k = minN - k;
    if (ns >= 0) {
      nu += Math.floor(k / 2);
      ns -= Math.floor(k / 2) + (k % 2);
    } else {
      ns -= Math.floor(k / 2);
      nu += Math.floor(k / 2) + (k % 2);
    }
    ndiv = minN;
  } else {
    ndiv = k;
  }

  const l = ns * unit < lo ? ns * unit : lo;
  const u = nu * unit > up ? nu * unit : up;
  if (ndiv === 0) return [l];
  const step = (u - l) / ndiv;
  return Array.from({ length: ndiv + 1 }, (_, i) => {
    const s = l + i * step;
    return Math.abs(s) < 1e-14 * step ? 0 : s;
  });
}
