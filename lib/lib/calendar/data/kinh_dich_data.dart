class QueDich {
  final int id;
  final String ten;
  final String tuongQue; // Hình ảnh quẻ (Vd: Hỏa Thiên Đại Hữu)
  final String noiDung;  // Lời giải chi tiết
  final String loiBan;   // Lời khuyên

  QueDich({required this.id, required this.ten, required this.tuongQue, required this.noiDung, required this.loiBan});
}

// Dữ liệu mẫu (Demo)
final List<QueDich> danhSachQue = [
  QueDich(
    id: 1,
    ten: "Thuần Càn (Đại Cát)",
    tuongQue: "☰ Thiên hành kiện",
    noiDung: "Quẻ này tượng trưng cho Rồng bay trên trời. Thời vận đang cực thịnh, mưu sự ắt thành. Công danh sự nghiệp thăng tiến như diều gặp gió.",
    loiBan: "Nên nắm bắt thời cơ, hành động quyết đoán. Tuy nhiên vật cực tất phản, cần giữ tâm khiêm tốn mới bền.",
  ),
  QueDich(
    id: 2,
    ten: "Hỏa Thiên Đại Hữu (Thượng Cát)",
    tuongQue: "☀️ Mặt trời giữa trưa",
    noiDung: "Vận số đỏ như son, tài lộc dồi dào. Làm ăn buôn bán nhất định có lãi lớn. Quý nhân phù trợ từ bốn phương.",
    loiBan: "Đã giàu có lại càng phải làm phước. Khoan dung độ lượng thì phúc đức mới dày.",
  ),
  QueDich(
    id: 3,
    ten: "Thủy Hỏa Ký Tế (Trung Bình)",
    tuongQue: "💧 Nước lửa giao nhau",
    noiDung: "Mọi việc ban đầu trôi chảy nhưng về sau có thể gặp khó khăn nhỏ. Cần đề phòng tiểu nhân quấy phá lúc cuối.",
    loiBan: "Cẩn tắc vô áy náy. Đừng ngủ quên trên chiến thắng.",
  ),
  // ... Anh có thể thêm tiếp các quẻ khác vào đây
];
