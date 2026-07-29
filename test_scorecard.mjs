import assert from "node:assert/strict";

import { evaluateScorecard } from "./ci-reliability-scorecard.mjs";

const empty = evaluateScorecard([]);
assert.equal(empty.answered, 0);
assert.equal(empty.score, 0);
assert.equal(empty.complete, false);
assert.equal(empty.id, "INCOMPLETE");

const partial = evaluateScorecard([true, false, null, true]);
assert.equal(partial.answered, 3);
assert.equal(partial.score, 2);
assert.equal(partial.complete, false);

for (const score of [0, 1, 2, 3]) {
  const result = evaluateScorecard([
    ...Array(score).fill(true),
    ...Array(10 - score).fill(false),
  ]);
  assert.equal(result.id, "URGENT");
  assert.equal(result.complete, true);
}

for (const score of [4, 5, 6, 7]) {
  const result = evaluateScorecard([
    ...Array(score).fill(true),
    ...Array(10 - score).fill(false),
  ]);
  assert.equal(result.id, "BUILD");
}

for (const score of [8, 9, 10]) {
  const result = evaluateScorecard([
    ...Array(score).fill(true),
    ...Array(10 - score).fill(false),
  ]);
  assert.equal(result.id, "READY");
}

const capped = evaluateScorecard(Array(12).fill(true));
assert.equal(capped.answered, 10);
assert.equal(capped.score, 10);

console.log("CI reliability scorecard tests: 16 passed");
