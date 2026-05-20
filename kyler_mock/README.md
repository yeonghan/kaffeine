# PayBridge AI-DLC Placement Demo

이 폴더는 IDC, AWS, Hybrid 워크로드 배치 의사결정 목업 데모입니다.

## 실행 방법

별도 설치 없이 `index.html` 파일을 브라우저에서 열면 됩니다. 모든 CSS와 JavaScript는 HTML 안에 포함되어 있습니다.

## Git에서 받아와 바로 열기

macOS 터미널:

```sh
sh open_paybridge_demo.sh
```

Finder에서 더블클릭:

```sh
open_paybridge_demo.command
```

스크립트는 어느 위치에서 실행해도 `https://github.com/yeonghan/kaffeine.git`을 사용자 캐시 폴더로 clone 또는 pull 한 뒤 `kyler_mock/index.html`을 기본 브라우저로 엽니다.

## 포함 기능

- mock CMDB CSV 평가
- 신규 서비스 Workload Canvas 입력
- IDC/AWS/Hybrid 적합도와 하드 게이트 평가
- AWS 7R 마이그레이션 전략 매핑
- Workload Placement Decision Record
- 30/60/90일 실행 로드맵과 승인 체크리스트

모든 데이터는 데모용 mock 데이터이며 실제 사내 서비스명, CMDB, 비용 데이터, AWS 계정을 사용하지 않습니다.
