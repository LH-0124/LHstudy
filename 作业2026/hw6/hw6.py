import numpy as np
import matplotlib.pyplot as plt

# ----------------- 参数设置 -----------------
N = 1280
n = np.arange(N)
theta = 2 * np.pi * n / N
student_id = "3230103696"

def add_watermark():
    """在图像中心添加斜向半透明的水印"""
    plt.text(0.5, 0.5, student_id, transform=plt.gca().transAxes,
             fontsize=40, color='gray', alpha=0.3,
             ha='center', va='center', rotation=30)

# ================= Q2 & Q3 =================
# 定义原始的 r(theta)
r_theta = 2 - 2 * np.sin(theta) + (np.sin(theta) * np.sqrt(np.abs(np.cos(theta)))) / (np.sin(theta) + 1.5)
x = r_theta * np.cos(theta)
y = r_theta * np.sin(theta)

# 绘制原边界 (Q2)
plt.figure(figsize=(6, 6))
plt.plot(x, y, 'b')
plt.title("HW1-Q2: Original Boundary $f(x,y)$")
plt.axis('equal')
plt.grid(True)
add_watermark()
plt.show()

# 计算傅里叶描述子
s_n = x + 1j * y
A_u = np.fft.fft(s_n) / N  # 除以 N 才是标准数学定义下的系数值

# 提取并打印系数，保留两位小数
a0 = np.round(A_u[0], 2)
a1 = np.round(A_u[1], 2)
print(f"--> 第一部分方程的系数: a(0) = {a0}, a(1) = {a1}")

# 滤波：只保留 a(0) 和 a(1)
A_u_filtered = np.zeros_like(A_u)
A_u_filtered[0] = A_u[0]
A_u_filtered[1] = A_u[1]

# 逆变换还原边界 (乘以 N 恢复幅度)
s_restored = np.fft.ifft(A_u_filtered * N)

# 绘制恢复后的边界 (Q3)
plt.figure(figsize=(6, 6))
plt.plot(np.real(s_restored), np.imag(s_restored), 'r')
plt.title("HW1-Q3: Restored Boundary (only $a(0), a(1)$)")
plt.axis('equal')
plt.grid(True)
add_watermark()
plt.show()


# ================= Q4 =================
# 定义新的 rho(theta)
rho_theta = 1 / (np.abs(np.cos(theta)) + np.abs(np.sin(theta)))
x_rho = rho_theta * np.cos(theta)
y_rho = rho_theta * np.sin(theta)

# 绘制新原边界 (Q4 - Redo 2)
plt.figure(figsize=(6, 6))
plt.plot(x_rho, y_rho, 'g')
plt.title("HW1-Q4: New Original Boundary $\\rho(\\theta)$")
plt.axis('equal')
plt.grid(True)
add_watermark()
plt.show()

# 计算新的傅里叶描述子
s_n_rho = x_rho + 1j * y_rho
A_u_rho = np.fft.fft(s_n_rho) / N

a0_rho = np.round(A_u_rho[0], 2)
a1_rho = np.round(A_u_rho[1], 2)
print(f"--> 第二部分方程的系数: a(0) = {a0_rho}, a(1) = {a1_rho}")

# 滤波与逆变换
A_u_rho_filtered = np.zeros_like(A_u_rho)
A_u_rho_filtered[0] = A_u_rho[0]
A_u_rho_filtered[1] = A_u_rho[1]
s_restored_rho = np.fft.ifft(A_u_rho_filtered * N)

# 绘制新恢复边界 (Q4 - Redo 3)
plt.figure(figsize=(6, 6))
plt.plot(np.real(s_restored_rho), np.imag(s_restored_rho), 'm')
plt.title("HW1-Q4: Restored New Boundary")
plt.axis('equal')
plt.grid(True)
add_watermark()
plt.show()