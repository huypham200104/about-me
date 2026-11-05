# Website Cá Nhân — Phạm Ngọc Huy (Mobile Developer)

Website cá nhân dạng tĩnh (Static Website) đa trang giới thiệu bản thân, hồ sơ năng lực (CV) song ngữ và các ứng dụng đã xuất bản dành cho **Phạm Ngọc Huy** (Kỹ sư Lập trình Di động — Flutter & React Native).

Tối ưu hóa đặc biệt để triển khai trực tiếp trên **GitHub Pages**.

---

## 📁 Cấu Trúc Thư Mục

```
about-me/
├── index.html            # Trang chủ: Hero header, avatar initials "PNH", giới thiệu và vertical timeline
├── developer.html        # Trang Developer: Danh sách Published Apps, Tech Stack badges, GitHub link
├── cv-vi.html            # CV Tiếng Việt: Layout 1 cột chuẩn ATS, nút Tải PDF và chuyển ngôn ngữ
├── cv-en.html            # CV Tiếng Anh: Layout 1 cột chuẩn ATS, nút Download PDF và chuyển ngôn ngữ
├── css/
│   └── style.css         # CSS thuần duy nhất: Design system Xanh - Trắng, Dark Mode, Animations & Print
├── js/
│   └── main.js           # Vanilla JavaScript duy nhất: Theme toggle, Scroll Reveal, Active Nav, Mobile Menu
├── assets/
│   └── favicon.svg       # Favicon vector PNH gradient
└── README.md             # Hướng dẫn triển khai và tùy biến nội dung
```

---

## 🎨 Điểm Nổi Bật Về Thiết Kế & Kỹ Thuật

1. **Zero External Dependencies:**
   - Hoàn toàn viết bằng HTML5 semantic, CSS3 thuần và Vanilla JavaScript (ES6+).
   - Không phụ thuộc framework (Bootstrap, Tailwind, React, Vue, jQuery,...).
   - Dung lượng siêu nhẹ (< 25KB toàn bộ), tải trang tức thì.

2. **Hệ Thống Theme Xanh Dương + Trắng & Dark Mode:**
   - **Light Mode:** Nền trắng `#FFFFFF` & xám nhạt `#F5F7FA`, màu chủ đạo Xanh dương `#1976D2` / `#1565C0`, text `#212121` / `#424242`.
   - **Dark Mode:** Nền xám đậm `#121212` & `#1E1E1E`, màu chủ đạo Xanh dương sáng `#42A5F5` / `#64B5F6`, text `#FAFAFA` / `#E0E0E0`.
   - Tự động nhận diện theme hệ thống (`prefers-color-scheme`).
   - Lưu trữ lựa chọn của người dùng vào `localStorage`.
   - Chuyển đổi màu sắc mượt mà với CSS transition.

3. **Trải Nghiệm Tương Tác:**
   - **Scroll Reveal (IntersectionObserver):** Các phần tử và mốc timeline xuất hiện dần khi cuộn trang tới. Có fallback hiển thị ngay nếu trình duyệt cũ không hỗ trợ.
   - **Tự động Active Menu:** Thanh điều hướng nhận biết chính xác trang hiện tại để highlight.
   - **In ấn & Xuất PDF chuyên nghiệp:** Cả 2 trang `cv-vi.html` và `cv-en.html` đều hỗ trợ `@media print`. Khi bấm "Tải PDF" hoặc ấn `Ctrl + P`, trình duyệt sẽ ẩn header/footer/toggle và format trang giấy A4 chuẩn mực.
   - **Responsive 100%:** Hiển thị tối ưu từ màn hình điện thoại (320px) đến desktop lớn.

---

## 🚀 Hướng Dẫn Deploy Lên GitHub Pages

Repo GitHub của bạn đã được cấu hình tại: `https://github.com/huypham200104/about-me`

### Cách triển khai trực tiếp từ Branch `main`:
1. Push toàn bộ mã nguồn lên GitHub:
   ```bash
   cd about-me
   git push -u origin main
   ```
2. Truy cập vào repository trên trình duyệt: `https://github.com/huypham200104/about-me/settings/pages`
3. Tại mục **Build and deployment**:
   - **Source:** Chọn `Deploy from a branch`
   - **Branch:** Chọn `main`, thư mục `/ (root)`
   - Bấm **Save**.
4. Chờ 1–2 phút, website của bạn sẽ hoạt động trực tiếp tại địa chỉ:
   ```
   https://huypham200104.github.io/about-me/
   ```

---

## ✏️ Hướng Dẫn Tùy Biến Dữ Liệu (Placeholder Customization)

Tất cả các vị trí dữ liệu mẫu trong file HTML đều đã được gắn chú thích rõ ràng: `<!-- EDITABLE: ... -->`.

1. **Thay đổi thông tin liên lạc & mạng xã hội:**
   - Mở `cv-vi.html`, `cv-en.html`, `index.html` và tìm thẻ `<div class="cv-contact">` hoặc footer để thay đổi số điện thoại, email, link LinkedIn, GitHub cá nhân.
2. **Cập nhật link tải ứng dụng trên Google Play:**
   - Mở `developer.html`, tìm tới class `.app-card-actions` và cập nhật đường dẫn `href` tại các nút `▶ Google Play`.
3. **Thêm hoặc sửa mốc thời gian (Timeline):**
   - Mở `index.html`, tìm tới `<div class="timeline">`. Bạn có thể sao chép thêm một thẻ `<article class="timeline-item reveal">` để thêm các năm tiếp theo.
