const TOTAL_QUESTIONS = 10;

export function evaluateSpreadsheetScorecard(values) {
  const normalized = values.slice(0, TOTAL_QUESTIONS);
  const answered = normalized.filter((value) => typeof value === "boolean").length;
  const score = normalized.filter((value) => value === true).length;

  if (answered < TOTAL_QUESTIONS) {
    return {
      answered,
      score,
      complete: false,
      id: "INCOMPLETE",
      title: `${TOTAL_QUESTIONS - answered}개 질문이 남았습니다`,
      copy: "모든 항목에 답하면 현재 위험 구간과 다음 점검 순서를 보여드립니다.",
      primaryLabel: "",
      primaryHref: "",
      secondaryLabel: "",
      secondaryHref: "",
    };
  }

  if (score <= 3) {
    return {
      answered,
      score,
      complete: true,
      id: "URGENT",
      title: "원본 보존과 구조 목록부터 고정하세요",
      copy: "수식을 고치기 전에 원본 사본, 숨김 구조, 외부 연결과 계산 오류를 읽기 전용으로 확인해야 합니다.",
      primaryLabel: "스프레드시트 감사 문의",
      primaryHref:
        "https://github.com/soul-sol/verified-automation-services/issues/new?template=spreadsheet-audit.yml",
      secondaryLabel: "무료 점검표 보기",
      secondaryHref: "samples/spreadsheet-preflight-checklist.md",
    };
  }

  if (score <= 7) {
    return {
      answered,
      score,
      complete: true,
      id: "BUILD",
      title: "점검\u00a0순서를 표준화할\u00a0단계입니다",
      copy: "핵심 구조는 관리 중입니다. 단위·수식·입력·검산을 한\u00a0절차로\u00a0묶으세요.",
      primaryLabel: "USD 9 전자책과 CLI 보기",
      primaryHref: "spreadsheet-preflight-ebook.html",
      secondaryLabel: "감사 서비스 범위 보기",
      secondaryHref:
        "https://github.com/soul-sol/verified-automation-services/issues/new?template=spreadsheet-audit.yml",
    };
  }

  return {
    answered,
    score,
    complete: true,
    id: "READY",
    title: "기본\u00a0통제가\u00a0갖춰졌습니다",
    copy: "자동 사전점검과 독립 검산을 팀\u00a0공통\u00a0절차로\u00a0확장하세요.",
    primaryLabel: "신뢰성 번들 보기",
    primaryHref: "developer-reliability-bundle.html",
    secondaryLabel: "전자책과 CLI 보기",
    secondaryHref: "spreadsheet-preflight-ebook.html",
  };
}

function readAnswers(form) {
  return Array.from({ length: TOTAL_QUESTIONS }, (_, index) => {
    const selected = form.querySelector(`input[name="q${index + 1}"]:checked`);
    if (!selected) {
      return null;
    }
    return selected.value === "yes";
  });
}

function initScorecard() {
  const form = document.querySelector("[data-scorecard]");
  if (!form) {
    return;
  }

  const progress = document.querySelector("[data-score-progress]");
  const progressText = document.querySelector("[data-score-progress-text]");
  const value = document.querySelector("[data-score-value]");
  const band = document.querySelector("[data-score-band]");
  const copy = document.querySelector("[data-score-copy]");
  const actions = document.querySelector("[data-score-actions]");
  const primary = document.querySelector("[data-score-primary]");
  const secondary = document.querySelector("[data-score-secondary]");

  const render = () => {
    const result = evaluateSpreadsheetScorecard(readAnswers(form));
    progress.value = result.answered;
    progressText.textContent = `${result.answered} / ${TOTAL_QUESTIONS}`;
    value.textContent = `${result.score} / ${TOTAL_QUESTIONS}`;
    band.textContent = result.title;
    copy.textContent = result.copy;
    actions.hidden = !result.complete;

    if (result.complete) {
      primary.textContent = result.primaryLabel;
      primary.href = result.primaryHref;
      secondary.textContent = result.secondaryLabel;
      secondary.href = result.secondaryHref;
    }
  };

  form.addEventListener("change", render);
  form.addEventListener("submit", (event) => {
    event.preventDefault();
    render();
  });
  form.addEventListener("reset", () => window.setTimeout(render, 0));
  render();
}

if (typeof document !== "undefined") {
  initScorecard();
}
