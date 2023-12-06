# Dining Cup

![스크린샷 2023-12-07 053633](https://github.com/jrsky723/dining_cup/assets/67538999/ec2af127-c4c8-4afe-996b-5e59e42a64c4)

## Description

- Flutter를 이용한 식당 이상형 월드컵 (Tournament) 앱.
- Flutter based restaurant tournament app.
- 시연 영상 : [Youtube](https://www.youtube.com/watch?v=9cpY5qG6shI)

## Features

> Location based restaurant search

- Search for restaurants in the area by selecting a location.
- Display map and restaurant location using [NAVER MAP API](https://www.ncloud.com/product/applicationService/maps)

> Restaurant information

- Provides restaurant information using [Kakao REST API](https://developers.kakao.com/docs/latest/ko/local/common), including restaurant name, category, location, etc.

> Restaurant tournament

- Conduct a world cup with the image and information of the restaurant through the [Naver Open API](https://developers.naver.com/docs/serviceapi/search/blog/blog.md).
- Check the winner of the tournament.

## Tested Android Version

- Android 10.0 (Q) API Level 29
- Android 13.0 (Tiramisu) API Level 33

- > NOTICE!
  - API Level 28 : Naver Map이 정상적으로 작동하지 않습니다.
  - API Level 34 : 크롬브라우저가 정상적으로 작동하지 않습니다.
  - Naver Map does not work properly on API Level 28.
  - Chrome browser does not work properly on API Level 34.

## Installation

```bash
$ flutter pub get
$ flutter run
```

- 아래에 나열된 API 키를 .env 파일을 생성하여 작성해야 합니다.
- You must create .env file in the root directory and write your API keys.
  - NAVER_MAP_CLIENT_ID, NAVER_MAP_CLIENT_SECRET: [LINK](https://www.ncloud.com/product/applicationService/maps)
  - NAVER_SEARCH_CLIENT_ID, NAVER_SEARCH_CLIENT_SECRET: [NAVER_OPEN_API](https://developers.naver.com/apps/#/list)
  - KAKAO_REST_API_KEY: [KAKAO_REST_API](https://developers.kakao.com/docs/latest/ko/getting-started/app)

## .env file example

```bash
NAVER_MAP_CLIENT_ID="<YOUR_CLIENT_ID>"
NAVER_MAP_CLIENT_SECRET="<YOUR_CLIENT_SECRET>"

NAVER_SEARCH_CLIENT_ID="<YOUR_CLIENT_ID>"
NAVER_SEARCH_CLIENT_SECRET="<YOUR_CLIENT_SECRET>"

KAKAO_REST_API_KEY="<KAKAO_REST_API_KEY>"
```

## References

- [PIKU 이상형 월드컵](https://www.piku.co.kr/)

## Screenshots

> Start Page

![스크린샷 2023-12-07 042742](https://github.com/jrsky723/dining_cup/assets/67538999/598013c4-9725-4337-aa20-7ecbb609b571)

> Search Page

![스크린샷 2023-12-07 045531](https://github.com/jrsky723/dining_cup/assets/67538999/35a873af-6e8c-4ee1-9808-9d5030a19f35)

> Search Result Page

![스크린샷 2023-12-07 053103](https://github.com/jrsky723/dining_cup/assets/67538999/b46aa2c3-7f41-4611-9ef1-b0ac454b819f)

> Tournament Page

![스크린샷 2023-12-07 045439](https://github.com/jrsky723/dining_cup/assets/67538999/11819389-cb13-4a8e-9666-cda01ec5a882)

> Winner Page

![스크린샷 2023-12-07 045816](https://github.com/jrsky723/dining_cup/assets/67538999/515089ea-a945-4821-8de6-e45620284811)
