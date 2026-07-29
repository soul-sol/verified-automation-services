const TOTAL_QUESTIONS = 10;

export function evaluateScorecard(values) {
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
      copy: "모든 항목에 답하면 현재 위험 구간과 다음 행동을 보여드립니다.",
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
      title: "먼저 실패를 재현 가능하게 만드세요",
      copy: "도구를 더 추가하기 전에 실패 분류, 로컬 재현 명령과 최소 권한부터 고정해야 합니다.",
      primaryLabel: "CI 진단 범위 문의",
      primaryHref:
        "https://github.com/soul-sol/verified-automation-services/issues/new?template=ci-triage.yml",
      secondaryLabel: "무료 CI 자료 보기",
      secondaryHref: "github-actions-ci-triage-ebook.html",
    };
  }

  if (score <= 7) {
    return {
      answered,
      score,
      complete: true,
      id: "BUILD",
      title: "표준화가 필요합니다",
      copy: "핵심 보호 장치는 있지만 담당자마다 진단 순서가 달라질 수 있습니다. 체크리스트와 검증 명령을 하나로 묶으세요.",
      primaryLabel: "신뢰성 번들 보기",
      primaryHref: "developer-reliability-bundle.html",
      secondaryLabel: "CI 전자책 미리보기",
      secondaryHref: "github-actions-ci-triage-ebook.html",
    };
  }

  return {
    answered,
    score,
    complete: true,
    id: "READY",
    title: "기본 보호 장치가 갖춰져 있습니다",
    copy: "이제 교차 아키텍처 검증과 팀 공통 운영 절차로 재현성을 넓힐 단계입니다.",
    primaryLabel: "운영 표준화 번들 보기",
    primaryHref: "developer-reliability-bundle.html",
    secondaryLabel: "Go CI 키트 보기",
    secondaryHref: "go-cross-architecture-ci-kit.html",
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
    const result = evaluateScorecard(readAnswers(form));
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
