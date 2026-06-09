# SLI / SLO Methodology

## 1. SLI là gì

`SLI` = `Service Level Indicator`

Là chỉ số đo chất lượng dịch vụ.

Ví dụ:

- availability
- latency
- error rate

## 2. SLO là gì

`SLO` = `Service Level Objective`

Là mục tiêu cụ thể đặt ra cho SLI.

Ví dụ:

- `99.9%` requests thành công trong 30 ngày
- `95%` requests < `500ms`

## 3. Availability SLI

Một cách nghĩ phổ biến:

```text
availability = successful requests / total requests
```

Ví dụ:

- 1,000,000 requests
- 999,000 successful

=> availability = `99.9%`

## 4. Latency SLI

Một cách nghĩ phổ biến:

```text
latency SLI = % requests hoàn thành dưới một ngưỡng thời gian
```

Ví dụ:

- `95% requests < 500ms`

## 5. Error budget

Nếu SLO là:

```text
99.9%
```

thì error budget là:

```text
100% - 99.9% = 0.1%
```

Ý nghĩa:

- bạn được phép "tiêu" `0.1%` lỗi trong khoảng đo
- tiêu nhanh quá thì cần alert / điều tra / đóng băng release

## 6. Vì sao SLO quan trọng

SLO giúp:

- thống nhất kỳ vọng reliability
- tránh alert vô nghĩa
- giúp ưu tiên incident theo tác động thực

## 7. Mindset đúng

- không chọn SLI quá nhiều
- chọn vài SLI sát trải nghiệm user
- SLO phải đủ cao để có giá trị
- nhưng không cao đến mức không thực tế

## 8. Practical takeaway

- `SLI` = mình đo cái gì
- `SLO` = mình muốn nó tốt đến mức nào
- `Error Budget` = mình còn được phép fail bao nhiêu
