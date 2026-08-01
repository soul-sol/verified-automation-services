# AI API 비용·보안 진단 샘플 (pass/fail 수락 기준 포함)

이 문서는 **합성 fixture**에 대한 샘플 보고서다. 특정 고객 시스템의 감사
결과나 실제 보안 보증이 아니다. 실제 진단은 서면 범위를 합의한 뒤 최소한의
공개 코드 또는 재현 방법만 받아 수행한다.

## 입력 fixture

```ts
export async function summarize(text: string) {
  return fetch("https://api.example.invalid/v1/chat", {
    method: "POST",
    headers: { Authorization: `Bearer ${process.env.PUBLIC_APP_KEY}` },
    body: JSON.stringify({ model: "example", input: text })
  });
}
```

## 관찰 결과

| 신호 | 영향 | 확인 방법 |
|---|---|---|
| 브라우저에서 직접 호출 가능한 경로 | 키 탈취·무단 사용 위험 | 번들·네트워크 요청에서 Authorization 헤더 확인 |
| 사용자별 인증·속도 제한 없음 | 한 사용자가 비용을 독점할 수 있음 | 동일 세션에서 짧은 시간에 반복 요청 |
| 요청 크기·월 비용 상한 없음 | 입력 폭탄과 예산 초과 | 길이 제한·예산 카운터 부재 확인 |
| 오류 응답이 공급자 원문을 전달할 가능성 | 내부 정보·비용 정보 노출 | 4xx/5xx 응답 redaction 테스트 |

## 최소 개선 순서

1. 공급자 호출을 서버 전용 경로로 이동하고 브라우저에는 세션 토큰만 준다.
2. 사용자·IP별 인증 및 bounded rate limit을 추가한다.
3. 입력 길이, 일일 호출 수, 예상 비용을 서버에서 제한한다.
4. 공급자 오류는 내부 로그와 사용자 응답을 분리하고 키·프롬프트를 redaction한다.
5. 키가 없는 offline fixture로 401/429/비용 상한 테스트를 추가한다.

## 수락 가능한 검증 명령 예

```text
서버 테스트: unauthenticated → 401
제한 초과: 반복 요청 → 429, Retry-After 존재
비밀정보: 응답·로그에 API 키 패턴 0건
비용 상한: fixture 예산 초과 요청이 공급자 호출 전에 거부됨
```

실제 진단 문의: [AI API 하드닝 요청](https://github.com/soul-sol/verified-automation-services/issues/new?template=ai-api-hardening.yml)
으로 범위만 보내면 된다. 문의·조회는 매출이 아니며, 결제 확인과 정산
영수증이 있어야 매출로 기록한다.
