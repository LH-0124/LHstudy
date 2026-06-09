#import "@local/tplt:0.2.0": *
#import "@preview/codelst:2.0.2": sourcecode
#show: BL.with(is-table-cell-stroked: false)
#let ymd = "today"
#let course = "《生物医学图像处理》"
#let proj-name = "Homework 6"

#show: HW.with(
  course: course,
  proj-name: proj-name,
  english: false,
  ymd: ymd,
)

#problem(1)[
  #image("assets/image.png")
]

#SOLUTION
1. *A*.

2. python代码如下：#sourcecode()[
  ```python
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
  ```
]
#image("assets/1.png",width: 50%)

3. 
  首先，将离散的边界坐标表示为复平面上的离散序列：
  $ s(n) = x(n) + j y(n) = r(theta_n) e^(j theta_n) $
  对其进行离散傅里叶变换（获取傅里叶描述子）：
  $ a(u) = 1/N sum_(n=0)^(N-1) s(n) e^((-j 2pi u n) / N), quad u = 0, 1, ..., N-1 $
  根据题目要求，将除 $a(0)$ 和 $a(1)$ 之外的所有高频系数 $a(u)$ 设为 $0$。随后通过逆离散傅里叶变换重构平滑后的边界：
  $ s'(n) = a(0) + a(1) e^((j 2pi n) / N) = a(0) + a(1) e^(j theta_n),theta_n=(2pi n)/1280 $
  

  令 $a(0) = A_0 + j B_0$，$a(1) = A_1 + j B_1$。利用欧拉公式 $e^(j theta_n) = cos(theta_n) + j sin(theta_n)$，将复数方程拆解为直角坐标系下的实部和虚部：

  $ x'(n) + j y'(n) &= (A_0 + j B_0) + (A_1+j B_1) (cos theta_n + j sin theta_n) \
  &= (A_0 + A_1 cos theta_n -  B_1 sin theta_n) + j(B_0 + A_1 sin theta_n + B_1 cos theta_n) $

  通过python代码计算得$a(0)=-0.7j,a(1)=1.8$
  $ x'(n) &=  1.8 cos theta_n  \
    y'(n) &= -0.7+1.8 sin theta_n  $

  因此方程为$ x^2+(y+0.7)^2=1.8^2 $
  #image("assets/2.png",width: 50%)

4. python代码如下：
#sourcecode()[```python
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
```]
#image("assets/3.png",width: 50%)

同理，计算得：$ a(0)=0,a(1)=0.79 $

$ x'(n) &=  0.79 cos theta_n  \
    y'(n) &= 0.79 sin theta_n  $

  因此方程为$ x^2+y^2=0.79^2 $

  #image("assets/4.png",width: 50%)

#pagebreak()

#problem(2)[
  *HW2 - First Order Features*
  + Given the image $I_0$, carefully calculate its energy, range, $mu_1, mu_2, mu_3$, uniformity and entropy.
    $ I_0 = mat(
      3, 1, 0, 0, 2;
      1, 0, 1, 1, 0;
      0, 2, 0, 3, 1;
      1, 2, 1, 0, 0;
      0, 0, 2, 3, 1
    ) $
  + Assume that the image is a tiny temperature map on a world whose boundaries wrap around. The process of heat diffusion is analogous to applying circular convolution to an image.
    Using circular padding: 
    $ I_{t+1} = 1/9 mat(1, 1, 1; 1, 1, 1; 1, 1, 1) *_"circular" I_t $
    Which statement best describes this diffusion process from the perspective of images in practice?
    - A. It gently softens into the twilight, gradually losing its forms as its total brightness dissipates into the surrounding void.
    - B. As pixels endlessly intertwine in the cycle, the image awakens, stretching its dynamic range to forge sharper and deeper boundaries.
    - C. It does not perish in an instant; it slowly forgets its local forms, preserving its total brightness as a faint memory of the past, until all pixels drift toward the same quiet average — and the final whispers vanish into rounding and noise.
    - D. Like a drop of ink blooming in a calm pond, the image embraces absolute smoothness by continuously breathing new information into its canvas.
  + Fill in the table for $I_infinity$ directly.
  #align(center)[
      #table(
        columns: (auto, auto, auto, auto, auto, auto, auto, auto),
        align: center,
        stroke: 0.5pt + black,
        [], [*energy*], [*range*], [$mu_1$], [$mu_2$], [$mu_3$], [*uniformity*], [*entropy*],
        [$I_infinity$], [], [], [], [], [], [], []
      )
    ]
]

#SOLUTION

1. 
首先统计 $I_0$  中各灰度值的出现频次与概率 $p(z)$：
- 灰度 0：出现 10 次，$p(0) = 10/25 = 0.4$
- 灰度 1：出现 8 次，$p(1) = 8/25 = 0.32$
- 灰度 2：出现 4 次，$p(2) = 4/25 = 0.16$
- 灰度 3：出现 3 次，$p(3) = 3/25 = 0.12$

根据定义公式进行计算：
- *能量 (Energy)*:\
   $E=sum I_0^2= 51$
- *极差 (Range)*: \
  $max(z) - min(z) = 3 - 0 = 3$
- *均值 ($mu_1$)*: \
  $mu_1 = sum z_i p(z_i) = 1.0$
- *方差 ($mu_2$)*: \
  $mu_2 = sum (z_i - mu_1)^2 p(z_i)  = 1.04$
- *偏度 ($mu_3$)*: \
  $mu_3 = sum (z_i - mu_1)^3 p(z_i) =  0.72$

- * 均匀度 (Uniformity)*: \
  $U = sum (p(z_i))^2 = 0.4^2 + 0.32^2 + 0.16^2 + 0.12^2 = 0.3024$
- *熵 (Entropy)*: \
  $e = -sum p(z_i) log_2 p(z_i) = -(0.4 log_2 0.4 + 0.32 log_2 0.32 + 0.16 log_2 0.16 + 0.12 log_2 0.12) approx 1.8449$

2. *C*. 
  
相当于每一步都把一个像素变成周围 3 × 3 邻域的平均值。由于使用 circular
padding，边界也是首尾相接的，所以整个图像的总亮度不会改变。

不断扩散之后，局部差异会被平均掉，最后所有像素都会趋向于同一个值，也就是
原图像的全局平均值。


3. 

#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto),
    align: center,
    stroke: 0.5pt + black,
    [*Image*], [*energy*], [*range*], [$mu_1$], [$mu_2$], [$mu_3$], [*uniformity*], [*entropy*],
    
    [$I_infinity$], [25], [0], [1.0], [0], [0], [1], [0]
  )
]

#pagebreak()

#problem(3)[
  *HW3 - GLCM*
  Find the co-occurrence matrix of a matrix pattern in the following cases.
  + The position operator $Q$ is defined as "one pixel to the right"
  + The position operator $Q$ is defined as "two pixels to the right"
  + For 1. and 2.'s GLCM, calculate contrast and homogeneity.
   $ M = mat(
      0, 1, 2, 1, 0;
      1, 2, 1, 2, 1;
      0, 1, 2, 1, 0;
      1, 2, 1, 2, 1;
      0, 1, 2, 1, 0
    ) $
]

#SOLUTION
1. 
逐行统计相邻像素对 $(i, j)$，5 行共 20 对。
计数矩阵 $M_1$ 为：
$ M_1 = mat(0, 3, 0; 3, 0, 7; 0, 7, 0) $
归一化后得到共生矩阵 $P_1 = M_1 / 20$：
$ P_1 = mat(0, 0.15, 0; 0.15, 0, 0.35; 0, 0.35, 0) $

2.  
逐行统计间隔一个像素的组合对 $(i, j)$，5 行共 15 对。
计数矩阵 $M_2$ 为：
$ M_2 = mat(0, 0, 3; 0, 7, 0; 3, 0, 2) $
归一化后得到共生矩阵 $P_2 = M_2 / 15$：
$ P_2 = mat(0, 0, 1/5; 0, 7/15, 0; 1/5, 0, 2/15) $

3. 

$ "对比度" ： sum_(i,j) (i-j)^2 P(i,j)\  "同质性" : sum_(i,j) P(i,j) / (1 + |i-j|) $

* GLCM 1 ($P_1$):* \
所有非零项 $(i,j)$ 均满足 $|i-j| = 1$：
- $"对比度" ：1^2 times (0.15 + 0.15 + 0.35 + 0.35) = 1.0$
- $"同质性" ： 0.15/(1+1) + 0.15/(1+1) + 0.35/(1+1) + 0.35/(1+1) = 1.0 / 2 = 0.5$

* GLCM 2 ($P_2$):* \
非零项包括 $(0,2), (2,0)$和 $(1,1), (2,2)$：
- $"对比度" ： = 4 times (1/5 + 1/5) + 0 times (7/15 + 2/15)  = 1.6$
- $"同质性" ： = (1/5)/(1+2) + (1/5)/(1+2) + (7/15)/(1+0) + (2/15)/(1+0) = 0.4/5 + 9/15 approx 0.73$
