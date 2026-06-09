# Multi-window Burn Rate Alerts

## 1. Burn rate là gì

`Burn rate` cho biết bạn đang tiêu error budget nhanh đến mức nào.

Nói ngắn:

```text
burn rate > 1
```

nghĩa là bạn đang đốt error budget nhanh hơn tốc độ "cho phép".

## 2. Vì sao cần burn rate alert

Nếu chỉ alert theo:

- `error rate > X`

thì dễ:

- quá nhạy
- hoặc quá chậm

Burn rate tốt hơn vì nó gắn trực tiếp với SLO.

## 3. Multi-window alert mindset

Thường dùng 2 loại:

- `fast burn`
- `slow burn`

### Fast burn

Ví dụ:

- alert window: `1h`
- short confirmation window: `5m`

Ý nghĩa:

- phát hiện sự cố lớn, đốt budget cực nhanh
- ưu tiên phản ứng sớm

### Slow burn

Ví dụ:

- alert window: `6h`
- short confirmation window: `30m`

Ý nghĩa:

- phát hiện sự cố âm ỉ
- tránh bỏ sót degradation kéo dài

## 4. Tư duy "multi-window"

Thay vì nhìn một cửa sổ thời gian duy nhất, bạn nhìn:

- một cửa sổ dài hơn để đo xu hướng
- một cửa sổ ngắn hơn để xác nhận vấn đề đang diễn ra thật

Ví dụ:

```text
fast burn: 1h + 5m
slow burn: 6h + 30m
```

## 5. Availability SLO example

Nếu SLO là:

```text
99.9% over 30 days
```

thì error budget là:

```text
0.1%
```

Burn rate alert sẽ không chỉ hỏi:

```text
error rate đang là bao nhiêu?
```

mà hỏi:

```text
ở tốc độ hiện tại, error budget đang bị tiêu nhanh đến mức nào?
```

## 6. Vì sao cách này tốt

- giảm false positive
- vẫn bắt được incident lớn nhanh
- vẫn bắt được degradation âm ỉ
- alert gắn chặt với SLO, không chỉ threshold tùy hứng

## 7. Practical takeaway

- `fast burn` để bắt cháy lớn
- `slow burn` để bắt cháy âm ỉ
- burn rate giúp alerting gắn với `error budget`

## 8. One-line summary

```text
Burn rate alert = alert theo tốc độ đốt error budget, không chỉ theo error rate thô.
```
